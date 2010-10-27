filename = './compare_ext_1.dat'
Kp = ''

set terminal postscript eps enhanced size 3,4
set output 'bla.eps'
set style function lines
set origin 0.0, 0.0
set multiplot
set size 1,0.3
set origin 0.0,0.0
plot [][-70:100] filename u 0:1 w l, filename u 0:4 w l
set origin 0.0,0.33
plot [][-70:100] filename u 0:2 w l, filename u 0:5 w l
set origin 0.0,0.66
plot [][-70:100] filename u 0:3 w l, filename u 0:6 w l
unset multiplot
