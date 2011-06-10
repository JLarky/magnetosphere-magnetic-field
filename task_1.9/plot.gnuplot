#!/usr/bin/gnuplot

set output 'overall.png'
set terminal png size 800,1000
set origin 0.0, 0.0
set multiplot
set size 1,0.25

set xlabel 'hours'
set xrange [:14]

set origin 0.0,0.75
set ylabel 'Bl, nT'
plot 'cluster1.dat' u 1:2 w l t 'C1', 'cluster3.dat' u 1:2 w l t 'C3'

set origin 0.0,0.5
set ylabel 'Bm, nT'
plot 'cluster1.dat' u 1:3 w l t 'C1', 'cluster3.dat' u 1:3 w l t 'C3'

set origin 0.0,0.25
set ylabel 'Bn, nT'
plot [][-80:] 'cluster1.dat' u 1:4 w l t 'C1', 'cluster3.dat' u 1:4 w l t 'C3'

set origin 0.0,0.0
set ylabel '|B|, nT'
plot [][:90] 'cluster1.dat' u 1:5 w l t 'C1', 'cluster3.dat' u 1:5 w l t 'C3'
unset multiplot



set output '1h.png'
set multiplot

set xlabel 'hours'
set xrange [6:7]

set origin 0.0,0.75
set ylabel 'Bl, nT'
plot 'cluster1.dat' u 1:2 w l t 'C1', 'cluster3.dat' u 1:2 w l t 'C3'

set origin 0.0,0.5
set ylabel 'Bm, nT'
plot 'cluster1.dat' u 1:3 w l t 'C1', 'cluster3.dat' u 1:3 w l t 'C3'

set origin 0.0,0.25
set ylabel 'Bn, nT'
plot [][:] 'cluster1.dat' u 1:4 w l t 'C1', 'cluster3.dat' u 1:4 w l t 'C3'

set origin 0.0,0.0
set ylabel '|B|, nT'
plot [][:] 'cluster1.dat' u 1:5 w l t 'C1', 'cluster3.dat' u 1:5 w l t 'C3'
unset multiplot



set output 'diff.png'
set multiplot

set xlabel 'hours'
set ylabel 'Bn, nT'

set origin 0.0,0.75
set xrange [6.5:7]
plot 'cluster1.dat' u 1:4 w l t 'C1', 'cluster3.dat' u 1:4 w l t 'C3'

set origin 0.0,0.5
set xrange [6.5:6.75]
plot 'cluster1.dat' u 1:4 w l t 'C1', 'cluster3.dat' u 1:4 w l t 'C3'

set origin 0.0,0.25
set xrange [6.56:6.66]
plot [][:-5] 'cluster1.dat' u 1:4 w l t 'C1', 'cluster3.dat' u 1:4 w l t 'C3'

set origin 0.0,0.0
set xrange [6.58:6.6]
plot [][-30:-10] 'cluster1.dat' u 1:4 w lp t 'C1', 'cluster3.dat' u 1:4 w lp t 'C3'
unset multiplot
