#!/bin/sh

if [ $# -eq 3 ];then
    tp=$1
    path=$2
    tag=$3

    adb shell <<EOF
${tp}/tcpdump -p -vv -s 0 -i any -w /sdcard/capture${tag}.pcap
exit
EOF
elif [ "$1" = "-q" ];then
    pc=$(adb shell ps | grep tcpdump | awk '{print $2}')
    adb shell <<EOF
kill $pc
exit
EOF
    #adb pull /sdcard/capture${tag}.pcap ./${path}/${tag}.pcap
    #adb shell rm /sdcard/capture${tag}.pcap
fi
