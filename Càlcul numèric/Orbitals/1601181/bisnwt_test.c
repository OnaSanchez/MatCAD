#include <stdio.h>
#include <math.h>
#include "bisnwt.h"

double fexp (double x, void *prm) {
   return exp(x)-2;
}

double dfexp (double x, void *prm) {
   return exp(x);
}

int main (void) {
   double a=-9, b=1, dlt=10, arr, tol=1e-12;
   int maxit=10;
   int output = bisnwt(a,b,&arr,&dlt,tol,maxit,&fexp,&dfexp,NULL);
   printf("%lf\n", arr);
   printf("%d", output);
   return 0;
}
	