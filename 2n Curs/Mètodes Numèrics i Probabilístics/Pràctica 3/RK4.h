/*
  # Llibrary to compute a runge kutta with two variables and 4th order
  #
  # @Version: 1.0
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
#define E_STEPS "Data entry error: Number of steps must be positive, n > 0.\n"

// Fuctions included in the librery
void RK4( double (*f1)(double, double, double, void*),
double (*f2)(double, double, double, void*), double *x, double *y,
double x0, double y0, double t0, double tf, int n, void *prm, void *prm2 );
