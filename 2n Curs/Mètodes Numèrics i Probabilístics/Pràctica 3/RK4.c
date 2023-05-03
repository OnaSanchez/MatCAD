/*
  # Program to compute a runge kutta with two variables and 4th order
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


void RK4( double (*f)(double, double, double, void*),
        double (*g)(double, double, double, void*), double *x, double *y,
        double x0, double y0, double t0, double tf, int n, void *prmf,
        void *prmg ){
    /*
    Input: double *f --> function of the variable x
            double *g --> function of the variable y
            double x0 --> initial value of x
            double y0 --> initial value of y
            double t0 --> initial value of time
            double tf --> final value of time
            int n --> number of steps to do the Runge Kutta
            void *prmf --> vector of parameters needed in the function f
            void *prmg --> vector of parameters needed in the function g

    Output: (void)

    Description: Does a Runge Kutta of 4th order to calculate the solution of
                 the ecuation system form by the fuctions f and g within the
                 time interval [ t0, tf ]

    Relevant information: In case of error returns to the program without
                          changing the variables x and y and shows an error
                          missatge by standard output
    */

    //Input error management
    if ( n < 1 ){
      printf(E_STEPS);
      return;
    }

    //Start of the method
    double h = (tf-t0)/n;
    double xn = x0, yn = y0;

    double k[4];
    double l[4];
    double t = t0;

    for(unsigned i = 0; i < n; i++){
      k[0] = f(t, xn, yn, prmf);
      k[1] = f(t + h / 2, xn + h * k[0] / 2, yn + h * l[0] / 2, prmf);
      k[2] = f(t + h / 2, xn + h * k[1] / 2, yn + h * l[1] / 2, prmf);
      k[3] = f(t + h, xn + h * k[2], yn + h * l[2], prmf);

      l[0] = g(t, xn, yn, prmg);
      l[1] = g(t + h / 2, xn + h * k[0] / 2, yn + h * l[0] / 2, prmg);
      l[2] = g(t + h / 2, xn + h * k[1] / 2, yn + h * l[1] / 2, prmg);
      l[3] = g(t + h, xn + h * k[2], yn + h * l[2], prmg);

      xn = xn + h * (k[0] + 2*k[1] + 2*k[2] + k[3]) / 6;
      yn = yn + h * (l[0] + 2*l[1] + 2*l[2] + l[3]) / 6;

      t0 += h;
    }

    //End of the method
    *x = xn;
    *y = yn;

}
