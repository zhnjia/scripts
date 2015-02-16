#!/bin/sh

#adb shell rm /sdcard/browser/.log/turbo-$(date +%Y%m%d).log

usage() {
    cat <<EOF
$0 [-m] [-n <counts>] [-w <time>] [-d <dir>] [-e <web page>] [-t <path of tcpdump] [-s <stop>]

example:
    $0 -n 200 -w 5 -d test -t /data/local/tmp

OPTIONS
    -n counts       total times to visit web page
    -w time         seconds to wait for taking screen capture
    -d dir          save logs/pcaps/pics to dir
    -t tcpdump      path of tcpdump
    -s stop         stop testing
    -h              show usage
    --demo=<1|0>
    --url=<page>
        web pages, 'http://m.baidu.com/'
EOF
}

if [ $# -eq 0 ];then usage; exit 0; fi

isDeviceRooted() {
    adb root 2>&1 | grep -wq "adbd cannot run as root in production builds"
    echo $?
}

dir=$(date +%Y%m%d_%H%M%S)
loop=100
wt=5
wb='http://m.baidu.com/?wpo=btmbase'
tp="/data/data"
demo=0
preLogID=0
preTcpdumpID=0

cmds=$(getopt -o n:w:d:t:hs -l url:,demo: -- "$@")
if [ $? -ne 0 ];then usage; exit 1; fi
eval set -- "$cmds"

while true; do
    case $1 in
        -n) loop=$2;shift 2
            ;;
        -w) wt=$2;shift 2
            ;;
        -d) dir=$2;shift 2
            ;;
        -t) tp=$2;shift 2
            ;;
        --url) wb=$2;shift 2
            ;;
        -s)
            kill $preLogID
            adb shell ps | grep tcpdump | awk '{print $2}' | xargs -I '{}' adb shell kill '{}'
            exit 0
            ;;
        --demo) demo=$2;shift 2
            ;;
        -h) usage
            exit 0
            ;;
        --) shift;break
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
    local rtd=$(isDeviceRooted)
    [ -d $dir ] || mkdir $dir
    while [ $loop -ge $i ]
    do
        local t=$(date +%H_%M_%S)
        adb logcat -c
        adb logcat -v time > ./${dir}/${t}.log &
        preLogID=$!

        sh ./testtcpdump.sh $rtd $tp $t &

        sleep 1s
        if [ $demo -eq 1 ];then
            adb shell am start -n com.oupeng.android.turboexample/com.oupeng.android.turboexample.MainActivity -d 'url-http://m.baidu.com'
        else
            adb shell am start -n com.android.browser/com.android.browser.BrowserActivity
            sleep 2s
            #adb shell am start -a android.intent.action.VIEW -d http://${wb} com.android.browser
            adb shell am start -a android.intent.action.VIEW -d ${wb} com.android.browser
        fi
        sleep ${wt}s

        adb  shell screencap -p /mnt/sdcard/test.png
        echo "pull ${t}.png"
        adb  pull /mnt/sdcard/test.png  ./${dir}/${t}.png

        if [ $demo -eq 1 ];then
            adb shell am force-stop com.oupeng.android.turboexample
        else
            adb shell am force-stop com.android.browser
        fi

        sleep 3s
        kill $preLogID

        sh testtcpdump.sh $rtd -q > /dev/null

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
