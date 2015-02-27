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
        URL to search in pcap
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
rt=${dir}"/rt_"$(date +%Y%m%d_%H%M%S)"."${ptl}".log"

cat <<EOF
protocal:[$ptl], port:[$port], url:[$url], max:[$max], dir:[$dir], detial:[$detial], output:[$rt]
start [Y/n]?:
EOF

read cmd
[ "$cmd" = "n" ] && exit 1

total=$(ls ${dir}/*.pcap | wc -l)
i=1
nores=0
missed() {
    nores=$(expr $nores + 1)
    mf[$nores]=$1
}

for f in ${dir}/*.pcap
do
    tf=${workdir}/${f/\//\.}
    if [ "$ptl" = "http" ];then
        tshark -r $f -R "http.request.full_uri == \"http\://${url}\"" \
            -T fields -e tcp.stream 2> /dev/null \
            | xargs -I '{}' tshark -r $f -T fields -e frame.time_relative -R 'frame.number == 1 or (tcp.stream == {} and http)' 2> /dev/null \
            | head -n 3 > $tf
    elif [ "$ptl" = "spdy" ];then
        si=$(tshark -r $f -d tcp.port==${port},spdy \
            -R "spdy.header.value == \"${url%%/*}\" and spdy.header.value == \"/${url#*/}\"" \
            -T fields -e spdy.streamid 2> /dev/null )
        [ -z "$si" ] && continue
        tshark -r $f -d tcp.port==${port},spdy -T fields -e frame.time_relative \
            -R "frame.number == 1 or (spdy.streamid == $si and (spdy.type == 1 or spdy.type == 2))" 2> /dev/null > $tf
    fi
    if [ $(wc -l < $tf) -lt 3 ];then
        missed $f
        i=$(expr $i + 1)
        continue
    else
        value=$(awk -v mx=$max 'NR==2 {st=$1};END {split(FILENAME,fn,"."); if ($1 != st && $1-st < mx) {printf("%f\t%s",$1-st,fn[3])}}' $tf)
        if [ $detial -eq 1 ];then
            echo $value | tee -a $rt
        else
            echo $value >> $rt
            echo -ne "$(expr $i \* 100 / ${total})%\r"
        fi
    fi
    i=$(expr $i + 1)
done

if [ ! -e $rt ];then
    echo "lost: 100%"
    exit 0
fi

sed -i '/^$/d' $rt
awk -v nrs=$(echo "scale=2;$nores * 100 / ${total}" | bc) '{ sum+=$1;vl[NR]=$1 }
END {
    printf("avg=%f, min=%f, max=%f, stdDev=%f, no-res=%2.2f%%\n",sum/NR,extreme(vl,NR,0),extreme(vl,NR,1),stdDev(vl,sum/NR,NR),nrs)
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

for f in ${mf[@]}; do
    echo -n $f", " | tee -a $rt
done

rm -rf $workdir
exit 0

