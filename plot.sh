#!/bin/bash

main() {
    plot=$1
    max=$(expr $(cat $plot | wc -l) + 5)
    network=$2

    gnuplot <<EOF
set xrange [0:${max}]
set ylabel "time(s)"
set title "turbo2 server connection -- ${network}"
set term pngcairo lw 1 font "AR_PL_UKai_CN,14" size 1000,600
set output "${plot}.png"
set grid
set key bmargin center reverse Left
plot "$plot" u 1:2 w lp pt 5 title "tcp connection before ssl", \
"$plot" u 1:3 w lp pt 5 title "server send DH parameter", \
"$plot" u 1:4 w lp pt 5 title "client exchange public key", \
"$plot" u 1:5 w lp pt 5 title "server exchange public key", \
"$plot" u 1:6 w lp pt 5 title "connection with ssl enabled", \
"$plot" u 1:7 w lp pt 7 lc "black" title "connection with ssl disabled"
EOF
}

main $@
