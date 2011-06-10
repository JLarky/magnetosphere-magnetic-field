#!/usr/bin/gnuplot
set output 'e_variations.png'
set terminal png size 800,1000
set origin 0.0, 0.0
set multiplot
set size 1,0.2

#set xrange [251.8:251.999]
#set xrange [250.5:250.7]
set xrange [250.:250.2]
set xrange [250.06:250.14]

set origin 0.0,0.8
set title "latitude"
plot [][-90:90] 'data.dat' u 1:2 w l t ''

set origin 0.0,0.6
set title "longitude"
plot [][-180:180] 'data.dat' u 1:3 w l t ''

set logscale y

set origin 0.0,0.4
set title "800-2500 keV protons"
plot [][:0.3] 'data.dat' u 1:6 w l t ''

set origin 0.0,0.2
set title ">2500 keV protons"
plot [][0.1:2] 'data.dat' u 1:7 w l t ''

set origin 0.0,0.0
set title "100-300 keV electrons"
set xlabel 'day'
plot [][0.1:10] 'data.dat' u 1:8 w l t ''
unset multiplot
