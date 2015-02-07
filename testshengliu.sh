#!/bin/sh

#adb shell rm /sdcard/browser/.log/turbo-$(date +%Y%m%d).log

help() {
    cat <<EOF
testshengliu.sh [-m] [-n <counts>] [-w <time>] [-d <dir>] [-e <web page>] [-t <path of tcpdump] [-s <stop>]

OPTIONS
    -n counts       total times to visit web page
    -w time         seconds to wait for taking screen capture
    -d dir          save logs/pcaps/pics to dir
    -e page         web pages
    -t tcpdump      path of tcpdump
    -s stop         stop testing
    -m miui
    -h              show help
EOF
}

dir=$(date +%Y%m%d_%H%M%S)
loop=100
wt=5
wb='m.baidu.com/?wpo=btmbase'
tp="/data/data"
miui=0
preLogID=0
preTcpdumpID=0

isDeviceRooted() {
    [ "$(adb root)" = 'adbd cannot run as root in production builds' ] && echo 1 || echo 0
}

while getopts ":n:w:d:e:t:hm" arg
do
    case $arg in
        n) loop=$OPTARG
            ;;
        w) wt=$OPTARG
            ;;
        d) dir=$OPTARG
            ;;
        e) wb=$OPTARG
            echo $wb
            ;;
        t) tp=$OPTARG
            ;;
        m) miui=1
            ;;
        s)
            kill $preLogID
            adb shell ps | grep tcpdump | awk '{print $2}' | xargs -I '{}' adb shell kill '{}'
            exit 0
            ;;
        h) help
            exit 0
            ;;
    esac
done

# params
# $1: path to save results
# $2: seconds to wait
# $3: path of tcpdump
# $4: web page
main() {
    local i=1
    [ -d $dir ] || mkdir $dir
    while [ $loop -ge $i ]
    do
        local t=$(date +%H_%M_%S)
        adb logcat -c
        adb logcat -v time > ./${dir}/${t}.log &
        preLogID=$!

        #if [ $(isDeviceRooted) -eq 0 ];then
        if [ $miui -eq 1 ];then
            adb shell ${tp}/tcpdump -p -vv -s 0 -i any -w /sdcard/capture${t}.pcap &
        else
            #sh -x ./testtcpdump.sh $tp ${dir} $t > /dev/null &
            sh ./testtcpdump.sh $tp ${dir} $t &
        fi

        sleep 1s
        adb shell am start -n com.android.browser/com.android.browser.BrowserActivity
        sleep 2s
        #adb shell am start -a android.intent.action.VIEW -d http://${wb} com.android.browser
        adb shell am start -a android.intent.action.VIEW -d 'http://m.baidu.com/?wpo=btmbase' com.android.browser
        sleep ${wt}s

        adb  shell screencap -p /mnt/sdcard/test.png
        echo "pull ${t}.png"
        adb  pull /mnt/sdcard/test.png  ./${dir}/${t}.png

        adb shell am force-stop com.android.browser

        sleep 3s
        kill $preLogID

        #if [ $(isDeviceRooted) -eq 0 ];then
        if [ $miui -eq 1 ];then
           adb shell ps | grep tcpdump | awk '{print $2}' | xargs -I '{}' adb shell kill '{}'
        else
           sh testtcpdump.sh -q > /dev/null
        fi

        echo "pull ${t}.pcap"
        adb pull /sdcard/capture${t}.pcap ./${dir}/${t}.pcap
        adb shell rm /sdcard/capture${t}.pcap

        echo test -------- $i -------- completed.
        i=$(expr $i + 1)

    done
}

main

#adb pull /sdcard/browser/.log/turbo-$(date +%Y%m%d).log $dir
#awk '{print $4,$5}' ${dir}/turbo-$(date +%Y%m%d).log > ${dir}/loadTime.log
