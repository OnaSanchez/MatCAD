/*
  # Program that compute the solutions to the "pendol" ecuation with a 4th-order
  # Runger Kutta
  #
  # @Version: 1.0
  #
  # @Authors:
  #           --> Ona Sánchez -- 1601181
  #           --> Gerard Lahuerta -- 1601350
  #
  # @Copyright (c) 2022 All Right Reserved
*/

#include <stdio.h>
#include "RK4.h"
#include <math.h>


// Functions of the sistem
double f(double t, double x, double y, void* prm){
  return y;
}

double g(double t, double x, double y, void* prm){
  double *aux = (double*) prm;
  return -aux[0]*y - aux[1]*sin(x);
}


int main(int argc, char const *argv[]) {

  // Input error management
  if (argc < 9){
    printf("Data entry error: number of parameters must be 8.\n");
    return -1;
  }

  double param[2];
  double x0, y0, t0, tf, l;
  int n;

  if ( !sscanf(argv[1],"%lf",&param[0]) ) goto error_input;
  if ( !sscanf(argv[2],"%lf",&param[1]) ) goto error_input;
  if ( !sscanf(argv[3],"%lf",&l) ) goto error_input;
  if ( !sscanf(argv[4],"%lf",&x0) ) goto error_input;
  if ( !sscanf(argv[5],"%lf",&y0) ) goto error_input;
  if ( !sscanf(argv[6],"%lf",&t0) ) goto error_input;
  if ( !sscanf(argv[7],"%lf",&tf) ) goto error_input;
  if ( !sscanf(argv[8],"%d",&n) ) goto error_input;

  if ( !(l > 0) || !(param[1] > 0) || param[0] < 0 ) goto error_physic;
  if ( !(n > 0) ) goto error_step;


  // Start of the method
  param[1]/=l;

  unsigned pas = 100;
  double h = (tf-t0)/n;
  double x = x0, y = y0;

  printf("%.10lf    %.10lf    %.10lf\n", t0, x, y);
  for (unsigned i = 0; i < n; i++){
    RK4(f, g, &x, &y, x, y, t0+h*i, t0+h*(i+1), pas, param, param);
    printf("%.10lf    %.10lf    %.10lf\n", t0+h*(i+1), x, y);
  }
  return 0;


  // Error messages 
  error_input:
  printf("Data entry error: data could not be saved.\n");
  return -1;

  error_physic:
  printf("Data entry error: values of parameters L, M and \"alpha\" must positive.\n");
  return -2;

  error_step:
  printf("Data entry error: value of parameter n must be positive.\n");
  return -3;

}
