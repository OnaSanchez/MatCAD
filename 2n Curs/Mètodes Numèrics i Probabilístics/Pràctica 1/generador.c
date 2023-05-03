/*
  # Program to obtain random values using a normal distribution
  # @Version: 1.1
  #
  # @Authors:
  #           --> Ona Sánchez -- 1601181
  #           --> Gerard Lahuerta -- 1601350
  #
  # @Copyright (c) 2022 All Right Reserved
  #
  # Information about the program in:
*/

// Libraries needed
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "aleatori.h"

// Main function
int main(int argc, char const *argv[]) {
  /*
  Input: double mu --> parameter mu of a normal distribution
         double sigma --> parameter sigma squared of a normal distribution
         unisgned n --> number of samples shown by standard Output
         double seed --> seed to initializate the random methods

  Output: control integer (int).

  Description: Calculates a sample of random values using Normal(mu,sigma)
               By default, the number of values returned is 2000000
               The random seed by default is "random" (time in your computer)
               These two parameters can be changed when executing the program by
               introducing them as arguments

  Relevant information: In case of error returns -1
                        In case of no error returns 0
  */

  // Declaration of variables needed
  double param[2], seed = time(NULL);
  int n;


  // Input error management
  if (argc<3
        || sscanf(argv[1], "%lf", &param[0])!=1 // mu
        || sscanf(argv[2], "%lf", &param[1])!=1 // sigma
     ) {
     fprintf(stderr,"%s mu sigma\n", argv[0]);
     return -1;
  }

  if(!(param[1] > 0) ){
    printf("The value of sigma squared has to be positive (more than 0)\n");
    return -2;
  }

  // Check if n value is introduced
  if(argc > 3 && sscanf(argv[3], "%d", &n) && n > 0) printf("The value of numbers requested has changed to %u\n", n);
  else n = 2000000;
  // Check if a seed is introduced
  if(argc > 4 && sscanf(argv[4], "%lf", &seed)) printf("The seed for random generation has been changed by %lf\n",seed);
  init_seed(seed);

  // Calculus of the random values using Normal(mu,sigma)
  printf("%6s  %6s    %9s\n","mu","sigma","x");
  for(unsigned i = 0; i<n; i++){
    printf("%.4f %.4f %.12f\n", param[0], param[1], Normal(param[0],  param[1]));
  }

  return 0;
}
