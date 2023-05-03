/*
  # Library generator of random numbers
  # @Version: 1.0
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
#include <stdlib.h>
#include <limits.h>
#include <gsl/gsl_rng.h>

const gsl_rng_type *T;
const gsl_rng *rng;

void init_seed(double seed){
  /*
  Input: double seed --> seed to initializate the random method

  Description: Initialization of the random method of the gsl library
  */
  gsl_rng_env_setup();
  T = gsl_rng_taus2;
  rng = gsl_rng_alloc(T);
  gsl_rng_set(rng, (unsigned long)seed );
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
  return gsl_rng_uniform(rng) * (b-a) + a;

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

  if((int)gsl_rng_uniform(rng)%2) return u*s*sigma+mu;
  return v*s*sigma+mu;
}
