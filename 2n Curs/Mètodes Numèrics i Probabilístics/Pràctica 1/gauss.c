/*
  # Program to obtain the probability of the tails of a Normal Distribution
  # @Version: 1.5.2
  #
  # @Authors:
  #           --> Ona Sánchez -- 1601181
  #           --> Gerard Lahuerta -- 1601350
  #
  # @Copyright (c) 2022 All Right Reserved
  #
  # Information about the program in: https://www.overleaf.com/read/dncxfhyjpjgv
*/

// Libraries needed
#include <stdio.h>
#include <math.h>
#include <limits.h>
#include "integracio.h"

// Gauss function
double Gauss(double x, void *param){
  double *coef = (double*)(param);
  return exp(-(x-coef[0])*(x-coef[0])/(2*coef[1]))/(sqrt(2*M_PI*coef[1]));
}

// Main function
int main(int argc, char const *argv[]) {
  /*
  Input: int mu --> parameter mu of a normal distribution
         int sigma --> parameter sigma squared of a normal distribution
         int x --> limit value of the tail
         int n --> number of subintervals (OPTIONAL, by defaul n = 10)

  Output: control integer (int).

  Description: Calculate the area of the tails of the Gauss distribution
               with n equidistant subintervals by the methods of the library
               "integracio.h"

  Relevant information: In case of error returns -1
                        In case of no error returns 0
  */


  // Declaration of variables needed
  double param[2], x, area, tol = 10e-10;
  int n = 10;

  // Input error management
  if (argc<3
        || sscanf(argv[1], "%lf", &param[0])!=1 // mu
        || sscanf(argv[2], "%lf", &param[1])!=1 // sigma
        || sscanf(argv[3], "%lf", &x)!=1 // value for the probability
     ) {
     fprintf(stderr,"%s mu sigma x\n", argv[0]);
     return -1;
  }
  if(!(param[1] > 0) ){
    printf("The value of sigma squared has to be positive (more than 0)\n");
    return -1;
  }
  /*if( x < 0 ){
    printf("The value of x  has to be positive (more or equal to 0)\n");
    return -1;
  }*/

  // Check if n value is introduced
  if(argc > 4 && sscanf(argv[4], "%d", &n))
  //printf("Value of interval, n, changed to %d\n\n", n);

/*
  // Calculus of the area by Trapezi's formula
  area = Trapezi(&Gauss, param, param[0], -x, n);
  if(area != LLONG_MAX){
    area += 1-Trapezi(&Gauss, param, param[0], x, n);
    if(area < tol) area = 0;
    printf("Area Trapezi --> %.18f\n", area);
  }
*/
  // Calculus of the area by Simpson's formula
  x = fabs(x);
  area = Simpson(&Gauss, param, param[0], -x, n);
  if(area != LLONG_MAX){
    area += 1-Simpson(&Gauss, param, param[0], x, n);
    if(area < tol) area = 1;
    else area = 1 - area;
    printf("%.18f\n", area);
  }
/*
  // Calculus of the area by Legendre's formula
  area = Legendre(&Gauss, param, param[0], -x, n);
  if(area != LLONG_MAX){
    area += 1-Legendre(&Gauss, param, param[0], x, n);
    if(area < tol) area = 0;
    printf("Area Legendre--> %.18f\n", area);
  }

  // Calculus of the area by Txebixev's formula
  area = Txebixev(&Gauss, param, param[0], -x, n);
  if(area != LLONG_MAX){
    area += 1-Txebixev(&Gauss, param, param[0], x, n);
    if(area < tol) area = 0;
    printf("Area Txebixev--> %.18f\n", area);
  }
*/
  // End of the program without any error
  return 0;
}
