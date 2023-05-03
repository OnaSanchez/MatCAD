#include <stdio.h>
#include <math.h>
#include "bisnwt.h"
#define PI 3.14159265359
/*
 * Compilar:
	gcc -o kplt2nu -g -Wall kplt2nu.c bisnwt.c -lm
 */
 
 
 double fexp (double x, void *prm) {
		return x - (((double *)prm)[0])*sin(x) - (((double *)prm)[1]);
	}

	double dfexp (double x, void *prm) {
		return 1 - (((double *)prm)[0])*cos(x) ;
	}
	

int main (int argc, char *argv[]) {
   double e, T, M0, tf;                 // excentricitat òrbita, període òrbita, anomalia mitjana, durada de la simulació en segons
   int nt, k;                           //nombre de punts de la simulacio
   double Mi, E, ti, tp, v, vi;         //per calcular la anomalia mitjana de cada ti, l'excentricitat i l'anomalia vertadera
   double a, b, dlt=.1, arr, tol=1e-12; //per cridar bisnwt
   int maxit=10;                        //per cridar bisnwt
   double prm[2];


   if (argc<6
         || sscanf(argv[1], "%lf", &e)!=1
         || sscanf(argv[2], "%lf", &T)!=1
         || sscanf(argv[3], "%lf", &M0)!=1
         || sscanf(argv[4], "%lf", &tf)!=1
         || sscanf(argv[5], "%d", &nt)!=1
      ) {
		fprintf(stderr,"%s e T M0 tf nt\n", argv[0]);
		return -1;
	  }
	  
	//Anomalia mitjana --> M = E - esinE 
	//Relació temps/anomalia --> M = 2pi (t-tp)/T    --> tp és un dels instants de temps que satelit passa per perigeu
	//Anomalia vertadera --> cosv = e-cosE / ecosE-1
	
	//M = 2pi (t-tp)/T --> el primer cop ti és 0:
	//M0 = 2*PI (0-tp)/T
	
	tp = -(M0*T)/(2*PI);

	for(int i=0; i<=nt; i++){
		
		ti = i*(tf/nt);	
		Mi = 2*PI * (ti - tp) / T; //anomalia mitjana
		a = Mi - PI;
		b = Mi + PI*PI;
		prm[0]=e;
		prm[1]=Mi;
		bisnwt(a,b,&arr,&dlt,tol,maxit,&fexp,&dfexp,prm);
		E = arr; //anomalia excèntrica del satèlit
		
		v=acos((e-cos(E))/((e*cos(E))-1)); //va de 0 a 180, si li dones 181 et fa el cos de 179 --> restar 
		
		for(k=0; k<=100; k++){
			if(k*2*PI <= E && E <= k*2*PI + PI){ //mitja volta de dalt
				vi = v + k*2*PI;
				break;
			} else if(k*2*PI+PI <= E && E <= k*2*PI+2*PI){ //mitja volta de baix
				vi = k*2*PI + 2*PI - v;
				break;
			}
		}
					
		printf("%lf   %lf   %lf\n", ti, Mi, vi);
	}
	
	
	return 0;
}