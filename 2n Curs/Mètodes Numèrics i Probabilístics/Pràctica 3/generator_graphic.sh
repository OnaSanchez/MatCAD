#!/usr/bin/bash

# Creation of the data needed
./pendol 0 1 1 4 -2 0 4 100 > "data_inf.txt"
./pendol 0 1 1 -4 2 0 4 1000 > "data_sup.txt"

./pendol 0 1 1 -3.14 0 0 200 1000 > "data_sup_eye.txt"
./pendol 0 1 1 0 -2 0 50 1000 > "data_inf_eye_lf.txt"
./pendol 0 1 1 0 -2 0 -30 1000 > "data_inf_eye_rg.txt"

./pendol 0 1 1 0 1.5 0 10 100 > "data_elip.txt"
./pendol 0 1 1 0 1 0 8 100 > "data_circ.txt"

# Plotting the results
./gnu_graphic.gp > graphic.gp

# Deletion of the data files (no more needed)
rm data_elip.txt
rm data_circ.txt
rm data_inf.txt
rm data_sup_eye.txt
rm data_sup.txt
rm data_inf_eye_lf.txt
rm data_inf_eye_rg.txt
