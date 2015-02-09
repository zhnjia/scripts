#!/bin/bash

dir=./

while getopts ":d:" arg
do
    case $arg in
        d) dir=$OPTARG
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
    tshark -r $f -d tcp.port==443,spdy -R spdy 2> /dev/null | grep -Ew "Stream=1 Request=\"GET http.*baidu.com|Stream=1 Response=200" > $spdy
    if [ $(wc -l < $spdy) -eq 2 ]; then
        echo $(awk 'NR==1 {st=$2};END {split(FILENAME,fn,"."); if ($2 != st) {print fn[3],$2-st}}' $spdy) | tee -a $rt
    fi
done

sed -i '/^$/d' $rt
awk '{sum+=$2;vl[NR]=$2} END {print sum/NR,stdDev(vl,sum/NR,NR)} function stdDev (vs,pv,n) {t=0;for (v in vs)  t+=(v-pv)*(v-pv); return sqrt(t/n)}' $rt | tee -a $rt

rm -rf $workdir
exit 0

