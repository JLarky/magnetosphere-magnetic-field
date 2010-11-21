set terminal png size 600,700
set style function lines
set origin 0.0, 0.0
set multiplot
set title "Kp = ".Kp
set size 1,0.35
set origin 0.0,0.0
plot [][-150:150] filename u 0:3 w l t 'model Bz', filename u 0:6 w l t 'data'
set origin 0.0,0.33
plot [][-150:150] filename u 0:2 w l t 'model By', filename u 0:5 w l t 'data'
set origin 0.0,0.66
plot [][-150:150] filename u 0:1 w l t 'model Bx', filename u 0:4 w l t 'data'
unset multiplot
