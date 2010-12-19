#!/usr/bin/gnuplot
set output 'diff.png'
set terminal png size 600,800
set origin 0.0, 0.0
set multiplot
set size 1,0.5
set origin 0.0,0.50
 set title "RMSD of magnetic field module"
 set xlabel 'Distance, Earth radii'
 set ylabel 'nT'
plot [1:9][:80] './compare.dat' u 1:2 w d t 'deviation', 30 t '30 nT'
set origin 0.0,0.00
 set title "RMSD of magnetic field module diveded by dipole field module"
 set xlabel 'Distance, Earth radii'
 set ylabel '%'
plot [1:9] './compare.dat' u 1:3 w d t 'deviation', 10 t '10%'
unset multiplot
