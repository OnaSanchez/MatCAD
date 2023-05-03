/*
  # Program to obtain the probability that an arbitrary four degree polinomial
  # function has four real roots, four complex root or two roots of both
  # @Version: 2.0
  #
  # @Authors:
  #           --> Ona Sánchez -- 1601181
  #           --> Gerard Lahuerta -- 1601350
  #
  # @Copyright (c) 2022 All Right Reserved
*/
#include <stdio.h>
#include <stdlib.h>
#include "aleatori.h"
#include <time.h>
#include <sys/time.h>

int main(int argc, char const *argv[]){
  /*
  Input: int extra --> request extra information (OPTIONAL: default extra = 0)
         int n --> number of samples to generate (OPTIONAL: default n =  2*10^7)
         double seed --> seed to initializate the random methods
                         (OPTIONAL: default seed = a random value)

  Output: control integer

  Description: Generate n of fourth degree polynomials with a random method and
               calculate the fraction of each type.


  Relevant information: The types are 0 --> 4 real roots
                                      1 --> 4 complex roots
                                      2 --> 2 of each
  */

  struct timeval t, t2;
  int microsegundos;
  gettimeofday(&t, NULL);

  double coefs[5], discriminants[5], seed;
  unsigned n_types[3] = {0, 0, 0};
  unsigned char extra;
  int n;

  //Input management
  if(argc > 1 && sscanf(argv[1], "%hhu", &extra) && extra) printf("Extra information has been requested.\n");

  if(argc > 2 && sscanf(argv[2],"%d",&n) && n > 0) printf("Number of samples changed.\n");
  else n = 2e7;

  if(argc > 3 && sscanf(argv[3], "%lf", &seed)) printf("Values of the seed changed.\n");
  else seed = time(NULL);
  init_seed(seed);

  // Start of the method
  printf("Calculating...\n");
  for (unsigned i = 0; i < n; i++) {
    muller(coefs, 5);

    // Calculations of the needed discriminants
    discriminants[0] = coefs[0]*coefs[4]-4*coefs[1]*coefs[3]+3*coefs[2]*coefs[2]; //P

    discriminants[4] = coefs[1]*coefs[1]-coefs[0]*coefs[2]; //R

    discriminants[3] = discriminants[4]*coefs[4] + coefs[0]*coefs[3]*coefs[3];
    discriminants[3] += (coefs[2]*coefs[2]-2*coefs[1]*coefs[3])*coefs[2]; //Q

    discriminants[1] = 27*discriminants[3]*discriminants[3];
    discriminants[1] -= discriminants[0]*discriminants[0]*discriminants[0]; //D

    discriminants[2] = 12*discriminants[4]*discriminants[4];
    discriminants[2] -= coefs[0]*coefs[0]*discriminants[0]; //S

    // Filtration of the fuctions types ( 2R\2C -- 4R -- 4C)
    if(discriminants[1] > 0) n_types[2]++;
    else{
      if (discriminants[4] > 0 && discriminants[2] > 0) n_types[0]++;
      else n_types[1]++;
    }
  }
  printf("End of the calculations.\n\n");

  //Output management
  for (unsigned i = 0; i < 84; i++) printf("-");
  printf("\n");

  if(extra)printf("Number of polynomial functions of degree 4 generated: %d\n\n",n);

  if(extra)printf("Number of which has 4 real root: %d\n", n_types[0]);
  printf("Fraction of polynomials quadratic with 4 real roots: %lf \n\n", (double)n_types[0]/n);

  if(extra)printf("Number of which has 4 complex root: %d\n", n_types[1]);
  printf("Fraction of polynomials quadratic with 4 complex roots: %lf \n\n", (double)n_types[1]/n);

  if(extra)printf("Number of which has 2 real roots and 2 complex roots: %d\n", n_types[2]);
  printf("Fraction of polynomials quadratic with 2 real roots and 2 complex roots: %lf \n", (double)n_types[2]/n);

  if(extra){
    for (unsigned i = 0; i < 84; i++) printf(".");
    printf("\n");

    unsigned other = n-n_types[0]-n_types[1]-n_types[2];
    printf("Number of other cases: %d\n", other);
    printf("Fraction of other cases: %lf \n", (double)other/n);

    for (unsigned i = 0; i < 84; i++) printf("-");
    printf("\n");

    gettimeofday(&t2, NULL);
    microsegundos =  (t2.tv_sec - t.tv_sec)*1000 + (t2.tv_usec - t.tv_usec)/1000.0;
    printf("Time elapsed from the start to the end of the program: %d ms\n", microsegundos);
  }
  return 0;
}
