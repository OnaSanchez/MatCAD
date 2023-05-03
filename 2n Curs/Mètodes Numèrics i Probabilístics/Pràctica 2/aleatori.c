/*
  # Library generator of random numbers
  # @Version: 1.3
  #
  # @Authors:
  #           --> Ona Sánchez -- 1601181
  #           --> Gerard Lahuerta -- 1601350
  #
  # @Copyright (c) 2022 All Right Reserved
  #
  # Information about the program in:
*/

#include <stdio.h>
#include "aleatori.h"
#include <math.h>
#include <limits.h>
#include <stdlib.h>

void init_seed (double seed) {
  /*
  Input: double seed --> seed to initializate the random method

  Description: Initialization of the random method "srand()"
  */
  srand(seed);
}

double Uniforme(double a, double b){
  /*
  Input: double a --> bottom value of the interval
         double b --> upper value of the interval

  Output: double random value

  Description: Calculate a random number in [a,b] that follows a uniform distribution

  Relevant information: In case of error returns LLONG_MAX
  */

  // Input error management
  if( a >= b){
     printf("%s\n",E_INTER);
     return LLONG_MAX;
  }

  // Start of the method
  double rnd = (double)rand() / RAND_MAX;

  return rnd * (b-a) + a;
}

double Normal(double mu, double sigma){
  /*
  Input: double µ (mu)--> mean of normal distribution
         double σ (sigma)--> standard deviation of normal distribution

  Output: double random value

  Description: Calculate a random number that follows a normal distribution µ,σ

  Relevant information: In case of error returns LLONG_MAX
  */

  // Input error management
  if(sigma <= 0){
    printf("%s\n", E_SIGMA);
    return LLONG_MAX;
  }

  // Start of the method
  double u,v,s;
  do {
    u = Uniforme(-1,1);
    v = Uniforme(-1,1);
  } while( (s = u*u+v*v) >= 1);

  s = sqrt(-2*log(s)/s);

  if(rand()%2) return u*s*sigma+mu;
  return v*s*sigma+mu;
}

void muller(double * coef, int n){
  /*
  Input: double *coef --> vector to fill with the values of the coeficients
         int n --> number of parameters of the fourth degree polynomial function

  Output: void

  Description: Generate n random parameters

  Relevant information: The lenght of the vector coef must be equal to the
                        number of parameters of the polynomial function

  */

  // Input management error
  if(n <= 0){
    printf("%s\n", E_MULLER);
    return;
  }

  // Start of the method
  for(unsigned i = 0; i < n; i++) coef[i] = Normal(0,1);
  double aux=0;
  for(unsigned i = 0; i < n; i++) aux += coef[i]*coef[i];
  aux = sqrt(aux);
  for(unsigned i = 0; i < n; i++) coef[i]/=aux;

}
