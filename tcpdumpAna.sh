#!/bin/bash

dir=./
max=100

while getopts ":d:m:" arg
do
    case $arg in
        d) dir=$OPTARG
            ;;
        m) max=$OPTARG
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
    spdy=${workdir}/${f/\//\.}.spdy
    tshark -r $f -d tcp.port==443,spdy -R spdy 2> /dev/null | grep -E "Stream=1 Request=\"GET http.*baidu.com|Stream=1 Response=2" > $spdy
    if [ $(wc -l < $spdy) -eq 2 ]; then
        echo $(awk -v mx=$max 'NR==1 {st=$2};END {split(FILENAME,fn,"."); if ($2 != st && $2-st < mx) {printf("%f\t%s",$2-st,fn[3])}}' $spdy) | tee -a $rt
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

