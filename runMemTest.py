#!/usr/bin/python

import threading, subprocess, signal, shlex, time, os, json
import matplotlib.pyplot as plt
import numpy as np
import argparse

PERIOD = 60 # 1 minute
INTERVAL = 0.2
DEFAULTPACKAGE = 'com.opera.android'
ITEM = ['Java Heap', 'Native Heap', 'Code', 'Stack', 'Graphics', 'Private Other', 'System', 'TOTAL']
MEMSTATS = dict.fromkeys(ITEM, [])

def collectMemSize(kv):
    key = kv[0].strip();
    if MEMSTATS.has_key(key):
        size = kv[1].strip()
        if size.isalnum():
            sz = int(size) / 1024
        else:
            sz = int(size.split()[0].strip()) / 1024
        if len(MEMSTATS[key]) == 0:
            MEMSTATS[key] = [sz]
        else:
            MEMSTATS[key].append(sz)
        return sz
    return -1

def profileminimeminfo(process = DEFAULTPACKAGE):
    DUMPMEMINFO = "adb shell dumpsys meminfo -s " + process + " | head -n17 | tail -9"
    args = shlex.split(DUMPMEMINFO)
    ps = subprocess.Popen(args, shell=False, stdout=subprocess.PIPE)
    output = ps.stdout.readlines()
    for l in output:
        v = collectMemSize(l.split(':'))
        # if v != -1:
        #     print(v)
    threading.Timer(INTERVAL, profileminimeminfo).start()
    return

def stopProfile(signum, frame):
    fn = "./res_" + time.strftime("%Y%m%d%s") + "."
    saveResult(fn)
    savetojson(fn)
    drawResult(fn)
    os._exit(0)

def drawResult(filename_prefix):
    x = range(0, len(MEMSTATS[ITEM[0]]))
    labels = [ITEM[0], ITEM[1], ITEM[2], ITEM[3], ITEM[4], ITEM[5], ITEM[6]]
    fig, ax = plt.subplots(gridspec_kw={"left":.05, "right":.70})
    ax.stackplot(x \
                 , MEMSTATS[ITEM[0]] \
                 , MEMSTATS[ITEM[1]] \
                 , MEMSTATS[ITEM[2]] \
                 , MEMSTATS[ITEM[3]] \
                 , MEMSTATS[ITEM[4]] \
                 , MEMSTATS[ITEM[5]] \
                 , MEMSTATS[ITEM[6]] \
                 , labels=labels)
    ax.legend(bbox_to_anchor=(1.05, 1), loc=2, borderaxespad=0.)
    ax.grid(linestyle='-', color='darkgray')
    ax.set_yticks(range(0, max(MEMSTATS[ITEM[7]]), 2))
    plt.savefig(filename_prefix + "png", format='png')
    plt.show()
    return

def saveResult(filename_prefix):
    res_f = filename_prefix + "orig"
    with open(res_f, "w+") as fr:
        for it in ITEM:
            line = it + ":"
            for sz in MEMSTATS[it]:
                line = line + "\t" + str(sz)
            fr.write(line + "\n")
    return

def savetojson(filename_prefix):
    res_f = filename_prefix + "json"
    with open(res_f, "w+") as fr:
        fr.write(json.dumps(MEMSTATS))
    return

if __name__ == '__main__':
    signal.signal(signal.SIGINT, stopProfile)
    signal.signal(signal.SIGTERM, stopProfile)

    parser = argparse.ArgumentParser(description='memory profiler')
    parser.add_argument('-p', type=str, dest='process', default=DEFAULTPACKAGE, help='Name of process to profiling.')
    args = parser.parse_args()
    print("Starting to profile: [" + args.process + "]")

    profileminimeminfo(args.process)
