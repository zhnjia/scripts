#!/bin/bash

dir=./
max=100
ptl="spdy"
url='m.baidu.com/?wpo=btmbase'

while getopts ":d:m:p:u:" arg
do
    case $arg in
        d) dir=$OPTARG
            ;;
        m) max=$OPTARG
            ;;
        p) ptl=$OPTARG
            ;;
        u) url=$OPTARG
            ;;
        *)
            exit 1
            ;;
    esac
done

workdir=$(mktemp -d)
rt=${dir}"/rt_"$(date +%Y%m%d_%H%M%S)".log"

for f in ${dir}/*.pcap
do
    tf=${workdir}/${f/\//\.}"."${ptl}
    if [ "$ptl" = "http" ];then
        tshark -r $f -R "http.request.full_uri == \"http\://${url}/\"" \
            -T fields -e tcp.stream 2> /dev/null \
            | xargs -I '{}' tshark -r $f -R 'tcp.stream == {} && http' 2> /dev/null \
            | head -n 2 > $tf
    elif [ "$ptl" = "spdy" ];then
        tshark -r $f -d tcp.port==443,spdy \
            -R 'spdy.header.value == "m.baidu.com" && spdy.header.value == "/?wpo=btmbase"' \
            -T fields -e spdy.streamid 2> /dev/null \
            | xargs -I '{}' tshark -r $f -d tcp.port==443,spdy -R 'spdy.streamid == {}' 2> /dev/null \
            | head -n 2 > $tf
    fi
    if [ $(wc -l < $tf) -ge 2 ]; then
        echo $(awk -v mx=$max 'NR==1 {st=$2};END {split(FILENAME,fn,"."); if ($2 != st && $2-st < mx) {printf("%f\t%s",$2-st,fn[3])}}' $tf) | tee -a $rt
    fi
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

