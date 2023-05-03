#!/usr/bin/gnuplot

# Range of the x and y values to show
set xrange [-3.14:3.14]
set yrange [-3.14:3.14]

# Inicialization of the labels
set xlabel "Velocity"
set ylabel "Acceleration"
set title "Graphic"
unset key

# Output
set term png
set output "graphic.png"

plot "data_inf.txt" u 2:3 with lines lt -1,\
     "data_sup.txt" u 2:3 with lines lt -1,\
     "data_sup_eye.txt" u 2:3 with lines lt 1,\
     "data_inf_eye_lf.txt" u 2:3 with lines lt 1,\
     "data_inf_eye_rg.txt" u 2:3 with lines lt 1,\
     "data_elip.txt" u 2:3 with lines lt 2,\
     "data_circ.txt" u 2:3 with lines lt 3
