#!/bin/sh

rtd=$1

tcpdmpRtd() {
    adb shell <<EOF
${tp}/tcpdump -p -vv -s 0 -i any -w /sdcard/capture${tag}.pcap
exit
EOF
}

tcpdmpNotRtd() {
    adb shell <<EOF
su
${tp}/tcpdump -p -vv -s 0 -i any -w /sdcard/capture${tag}.pcap
exit
exit
EOF
}

stopTcpdumpRtd() {
    adb shell <<EOF
kill $pc
exit
EOF
}

stopTcpdumpNotRtd() {
    adb shell <<EOF
su
kill $pc
exit
exit
EOF
}

if [ $# -eq 3 ];then
    tp=$2
    tag=$3
    [ $rtd -eq 1 ] && tcpdmpRtd || tcpdmpNotRtd
elif [ "$2" = "-q" ];then
    pc=$(adb shell ps | grep tcpdump | awk '{print $2}')
    [ $rtd -eq 1 ] && stopTcpdumpRtd || stopTcpdumpNotRtd
fi
