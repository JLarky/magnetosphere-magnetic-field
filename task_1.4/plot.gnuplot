#!/usr/bin/gnuplot
set terminal png size 1000,400
set pm3d map
#set palette rgbformulae 21,13,10
set contour surface
set cntrparam levels auto 10

unset title
set xrange [-180:180]
set yrange [-63:63]

set output 'field_map.png'
set cbrange [22000:65000]
splot './field.dat' u 1:2:3 t ''

set output 'field_diff.png'
set cbrange [-22000:22000]
splot './field.dat' u 1:2:4 t ''
