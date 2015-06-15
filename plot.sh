#!/bin/bash

main() {
    plot=$1
    max=$(expr $(cat $plot | wc -l) + 5)
    network=$2

    gnuplot <<EOF
set xrange [0:${max}]
set ylabel "time(s)"
set title "SSL handshake request time -- ${network}"
set term pngcairo lw 1 font "AR_PL_UKai_CN,14" size 2000,400
set output "${plot}.png"
set grid
plot "$plot" u 1:2 w lp pt 7 title "server send DH parameter", "$plot" u 1:3 w lp pt 7 title "client exchange public key", "$plot" u 1:4 w lp pt 7 title "server exchange public key", "$plot" u 1:5 w lp pt 7 title "total"
EOF
}

main $@
