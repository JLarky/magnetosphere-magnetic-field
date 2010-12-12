#!/usr/bin/gnuplot
set output 'trace.png'
set terminal png size 600,400
plot 'trace.dat' u 2:1 t 'footprint'

set output 'pitch.png'
set terminal png size 600,800
set multiplot
set origin 0.037, 0.0
set size 0.963,0.5
plot 'pitch.dat' u 0:4 t 'latitude'
set origin 0.0,0.50
set size 1,0.5
plot 'pitch.dat' u 0:6 t 'pitch
unset multiplot




