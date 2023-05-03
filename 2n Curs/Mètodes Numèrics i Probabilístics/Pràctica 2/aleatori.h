/*
  # Librery generator of random numbers
  # @Version: 1.2
  #
  # @Authors:
  #           --> Ona Sánchez -- 1601181
  #           --> Gerard Lahuerta -- 1601350
  #
  # @Copyright (c) 2022 All Right Reserved
  #
  # Information about the librery in:
*/

// Output messages of error
#define E_INTER "Data entry error: first value must be lower than the second one."
#define E_SIGMA "Data entry error: sigma value must be positive."
#define E_MULLER "Data entry error: value of lenth of the vector coefficient must be positive."

// Fuctions included in the librery
void init_seed(double);
double Uniforme (double, double);
double Normal (double, double);
void muller(double*, int);
