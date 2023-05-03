/*
  # Librery of numerical solving integrals
  # @Version: 1.3.2
  #
  # @Authors:
  #           --> Ona Sánchez -- 1601181
  #           --> Gerard Lahuerta -- 1601350
  #
  # @Copyright (c) 2022 All Right Reserved
  #
  # Information about the librery in: https://www.overleaf.com/read/dncxfhyjpjgv
*/

#include <stdio.h>
#include <math.h>
#include <limits.h>
#include "integracio.h"

double Trapezi(double (*f)(double, void*), void* param, double x0, double xn, int n){
    /*
    Input: double (*f)(double, void*) --> function to integrate
           void* param --> parameter of the fuctions (not the variable)
           double x0 --> bottom value of the integral
           double xn --> top value of the integral
           int n --> number of subintervals

    Output: value of the integral

    Description: Calculate the integral of the function f in the inteval
                 [x0, xn] with n equidistant subintervals by Trapezi's Method

    Relevant information: In case of error returns LLONG_MAX
    */

    // Input error management
    if(xn == x0){
      return 0;
    }
    else if(n < 1){
      printf("%s",E_NUM_SUBINTER);
      return LLONG_MAX;
    }
    else if (f == NULL){
      printf("%s", E_FUNC);
      return LLONG_MAX;
    }

    // Start of the method
    double h = (xn-x0)/n;
    double suma = 0;

    for(unsigned i = 1; i < n; i++) suma += f(x0+i*h, param);

    return h/2 * (f(x0, param) + f(xn, param) + 2*suma);
}

double Simpson(double (*f)(double, void*), void* param, double x0, double x2n, int n){
    /*
    Input: double (*f)(double, void*) --> function to integrate
           void* param --> parameter of the fuctions (not the variable)
           double x0 --> bottom value of the integral
           double x2n --> top value of the integral
           int n --> number of subintervals

    Output: value of the integral

    Description: Calculate the integral of the function f in the inteval
                 [x0, x2n] with n equidistant subintervals by Simpson's Method

    Relevant information: In case of error returns LLONG_MAX
    */

    // Input error management
    if(x2n == x0){
      return 0;
    }
    else if(n < 1){
      printf("%s", E_NUM_SUBINTER);
      return LLONG_MAX;
    }
    else if (f == NULL){
      printf("%s", E_FUNC);
      return LLONG_MAX;
    }

    // Start of the method
    unsigned N = 2*n;
    double h = (x2n-x0)/N;
    double s_par = 0, s_impar = f(x0 + h, param);

    for(unsigned i = 1; i < n; i++){
      s_par += f(x0 + h*(2*i), param);
      s_impar += f(x0 + h*(2*i+1), param);
    }

    return h/3 * ( f(x0, param) + f(x2n, param) + 4*s_impar + 2*s_par);

}


double Legendre(double (*f)(double, void*), void* param, double x0, double xn, int n){
    /*
    Input: double (*f)(double, void*) --> function to integrate
           void* param --> parameter of the fuctions (not the variable)
           double x0 --> bottom value of the integral
           double xn --> top value of the integral
           int n --> number of subintervals

    Output: value of the integral

    Description: Calculate the integral of the function f in the inteval
                 [x0, xn] with n equidistant subintervals by Legendre's Method

    Relevant information: In case of error returns LLONG_MAX
    */

    // Input error management
    if(xn == x0){
      return 0;
    }
    else if (f == NULL){
      printf("%s", E_FUNC);
      return LLONG_MAX;
    }

    // Start of the method
    double dif = (xn-x0)/2;
    double sum = (xn+x0)/2;
    double area = 0;

    if(n == 2){
      double w[2] = {1,1};
      double x[2] = {-0.5773502691, 0.5773502691};

      for (unsigned i = 0; i < n; i++) area += f(dif*(x[i])+sum, param)*w[i];

    }
    else if( n == 5){
      double w[5] = {0.2369268850, 0.4786287049, 0.5688888888, 0.4786286704, 0.2369268856};
      double x[5] = {-0.9061798459, -0.5384693101, 0, 0.5384693101, 0.9061798459};

      for (unsigned i = 0; i < n; i++) area += f(dif*(x[i])+sum, param)*w[i];

    }
    else if( n == 10){
      double w[10] = {0.0666713443, 0.1494513491, 0.2190863625, 0.2692667193, 0.2955242247, 0.2955242247, 0.2692667193, 0.2190863625, 0.1495134915, 0.0666713443};
      double x[10] = {-0.9737065285, -0.8650633666, -0.6794095682, -0.4333953941, -0.1488743389, 0.1488743389, 0.4333953941, 0.6794095682, 0.8650633666, 0.9737065285};

      for (unsigned i = 0; i < n; i++) area += f(dif*(x[i])+sum, param)*w[i];

    }

    // Coefficients of the number of subintervals not in memory
    else {
      printf("%s",E_NUM_SUBINTER_LEG);
      return LLONG_MAX;
    }

    return dif*area;

}


double Txebixev(double (*f)(double, void*), void *param, double x0, double xn, int n){
    /*
    Input: double (*f)(double, void*) --> function to integrate
           void* param --> parameter of the fuctions (not the variable)
           double x0 --> bottom value of the integral
           double xn --> top value of the integral
           int n --> number of subintervals

    Output: value of the integral

    Description: Calculate the integral of the function f in the inteval
                 [x0, xn] with n equidistant subintervals by Txebixev's Method

    Relevant information: In case of error returns LLONG_MAX
    */

    // Input error management
    if(xn == x0){
      return 0;
    }
    else if(n < 1){
      printf("%s",E_NUM_SUBINTER);
      return LLONG_MAX;
    }
    else if (f == NULL){
      printf("%s",E_FUNC);
      return LLONG_MAX;
    }

    // Start of the method
    double dif = (xn-x0)/2, t, suma = 0, x;
    unsigned N = n+1;

    for(unsigned i = 0; i < N; i++){
      t = cos((2*i+1)*M_PI/(2*N));
      x = (t+1)*dif+x0;
      suma += sqrt(1-t*t)*f(x, param);
    }

    return (dif*M_PI*suma)/N;
}
