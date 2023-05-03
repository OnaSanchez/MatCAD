#include <stdio.h>
#include <math.h>
#include "bisnwt.h"

int bisnwt (double a, double b, double *arr, //a,b són dos nums pertanyents als reals tals que f(a)f(b)<0, s'ha de trobar c amb bissecció, si c < tol es guarda a *arr, si no Newton i tornar arrel a *arr.
      double *dlt, double tol, int maxit, //tol = tolerància, maxit = maxim iterats mètode de Newton,*dlt = delta, ha de ser < tol, es guarda el valor que ha donat la convergència de Newton.
      double (*f)(double,void*), double (*df)(double,void*), void *prm) { //*f apunta a funció que avalua, recibe un double i devuelve un double f i *df apunta a funció que avalua f' recibe un double i devuelve un double.


	
   double interval=(b-a), c=(b+a)/2, fc, x0, x1, fx0, dfx0; //c = punt_mig 
   int iteracions=0;
   double fa=(*f)(a,prm);
   
	while(*dlt>tol){
		//1- BISECCIÓ FINS QUE AMPLADA DEL INTERVAL < *dlt --> delta
		
		   while(interval>*dlt){
			   			   
			   fc=(*f)(c,prm);			  
				   
			   if(fa < 0){ //fa < 0 i fb > 0
				if(fc < 0){
					a = c;
				  } else {
					b = c;
				  }
				} else { //fa > 0 i fb < 0 
					if(fc > 0){
						a = c;
					} else {
						b = c;
					}		   
				}
			   interval=(b-a);
			   c = (b+a)/2;
			   fa=(*f)(a,prm);		
		   }
		   
		   //2- GUARDEM C DINS *ARR O FEM NEWTON
		   if(interval<tol){
			   *arr = c;
			   return -1;
			} else { //newton a partir de x0 = c. Iterar fins |xn -xn-1| < tol o superem maxit iterats
			   
			   x0 = c;
			   iteracions=1;
			   
			   while(interval>=tol && iteracions <= (maxit)){
				   
				   iteracions ++;
				   fx0=(*f)(x0,prm);
				   dfx0=(*df)(x0,prm);
				   x1 = x0 - (fx0/dfx0);
				   interval = fabs(x1 - x0);
				   x0=x1;
				   
				}
		   
			   //3- CONVERGEIX / NO CONVERGEIX
			   if(interval < tol){ //si convergeix:
				   
				   *arr = x0;
				   return iteracions;
				   
				} else { //si no ha convergit:

				   *dlt = *dlt/2; //dividim delta/2
					//a i b ja estan com extrems de l'últim interval de la última bisecció
				}
			}
		
		}
   return 0;
}