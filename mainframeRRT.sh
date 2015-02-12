#!/bin/bash

usage() {
    cat <<EOF
Usage:
    $0 -v -d <path> [--max=seconds] [--protocal=PROTOCAL] [--port=PORT] [--url=URL]

OPTIONS
    -v
        show processing infomation
    -d <path>
        path of pcaps
    --max=seconds
        ignore pcaps which rtt is larger than seconds
    --protocal=PROTOCAL
        protocal filter, as http/spdy
    --port=PORT
        spdy port filter, as 443/9090
    --url=URL
        4mURL to search in pcap
EOF
}

if [ $# -eq 0 ];then usage;exit 0; fi

dir=./
max=100
ptl="spdy"
url='m.baidu.com/?wpo=btmbase'
port=443
detial=0

cmds=$(getopt -o vd: -l max:,protocal:,port:,url: -- "$@")
if [ $? -ne 0 ];then usage;exit 1; fi
eval set -- "$cmds"
while true; do
    case "$1" in
        -v)
            detial=1;shift
            ;;
        -d)
            dir=$2;shift 2
            ;;
        --max)
            max=$2;shift 2
            ;;
        --protocal)
            ptl=$2;shift 2
            ;;
        --port)
            port=$2;shift 2
            ;;
        --url)
            url=$2;shift 2
            ;;
        --) shift;break
            ;;
    esac
done

workdir=$(mktemp -d)
rt=${dir}"/rt_"$(date +%Y%m%d_%H%M%S)".log"

cat <<EOF
protocal:[$ptl], port:[$port], url:[$url], max:[$max], dir:[$dir], detial:[$detial], output:[$rt]
start [Y/n]?:
EOF

read cmd
[ "$cmd" = "n" ] && exit 1

total=$(ls ${dir}/*.pcap | wc -l)
i=1

for f in ${dir}/*.pcap
do
    tf=${workdir}/${f/\//\.}"."${ptl}
    if [ "$ptl" = "http" ];then
        tshark -r $f -R "http.request.full_uri == \"http\://${url}/\"" \
            -T fields -e tcp.stream 2> /dev/null \
            | xargs -I '{}' tshark -r $f -R 'tcp.stream == {} && http' 2> /dev/null \
            | head -n 2 > $tf
    elif [ "$ptl" = "spdy" ];then
        si=$(tshark -r $f -d tcp.port==${port},spdy \
            -R "spdy.header.value == \"${url%%/*}\" && spdy.header.value == \"/${url#*/}\"" \
            -T fields -e spdy.streamid 2> /dev/null )
        [ -z "$si" ] && continue
        tshark -r $f -d tcp.port==${port},spdy -R "spdy.streamid == $si && spdy.type == 1" 2> /dev/null > $tf
        tshark -r $f -d tcp.port==${port},spdy -R "spdy.streamid == $si && spdy.type == 2" 2> /dev/null >> $tf
    fi
    if [ $(wc -l < $tf) -ge 2 ]; then
        value=$(awk -v mx=$max 'NR==1 {st=$2};END {split(FILENAME,fn,"."); if ($2 != st && $2-st < mx) {printf("%f\t%s",$2-st,fn[3])}}' $tf)
        if [ $detial -eq 1 ];then
            echo $value | tee -a $rt
        else
            echo $value >> $rt
            echo -ne "$(expr $i \* 100 / ${total})%\r"
        fi
    fi
    i=$(expr $i + 1)
done

sed -i '/^$/d' $rt
awk '{ sum+=$1;vl[NR]=$1 }
END {
    printf("avg=%f, min=%f, max=%f, stdDev=%f\n",sum/NR,extreme(vl,NR,0),extreme(vl,NR,1),stdDev(vl,sum/NR,NR))
}
function stdDev(vs,pv,n) {
    t=0
    for (v in vs)
        t+=(vs[v]-pv)*(vs[v]-pv)
    return sqrt(t/n)
}
function extreme(vs,n,e) {
    t=vs[1]
    for (v in vs) {
        if (e==1 && vs[v] > t) t=vs[v]
        if (e==0 && vs[v] < t) t=vs[v]
    }
    return t
}' $rt | tee -a $rt

rm -rf $workdir
exit 0

