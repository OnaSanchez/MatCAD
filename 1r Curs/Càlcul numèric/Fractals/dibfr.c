#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <assert.h>
#include "nwtfr.h"

int main (int argc, char *argv[]) {
   double xmn, xmx, ymn, ymx, tolcnv;
   int nx, ny, maxit, narr;
/* Línia de comandes
   int narr double xmn double xmx int nx double ymn double ymx int ny double tolcnv int maxit
 */
   if (argc<10
         || sscanf(argv[1], "%d", &narr)!=1 //nombre arrels polinomi
         || sscanf(argv[2], "%lf", &xmn)!=1 //rect
         || sscanf(argv[3], "%lf", &xmx)!=1 //rect
         || sscanf(argv[4], "%d", &nx)!=1 //nombre de punts horitzontals
         || sscanf(argv[5], "%lf", &ymn)!=1 //rect
         || sscanf(argv[6], "%lf", &ymx)!=1 //rect
         || sscanf(argv[7], "%d", &ny)!=1 //nombre punts verticals
         || sscanf(argv[8], "%lf", &tolcnv)!=1 //tolerancia
         || sscanf(argv[9], "%d", &maxit)!=1 //max iteracions
      ) {
      fprintf(stderr,"%s narr xmn xmx nx ymn ymx ny tolcnv maxit\n", argv[0]);
      return -1;
   }

   double u[narr], v[narr];
   int vermell[narr], verd[narr], blau[narr];
   for(int i=0; i<narr; i++){
     scanf("%lf %lf %d %d %d", u+i, v+i, vermell+i, verd+i, blau+i); //double = lf, & perquè li hem de dir la posició de memòria on es guardi.
   } //tota la info guardada :D

   double xj, yk, difx, dify; //formula
   difx = (xmx-xmn)/nx;
   dify = (ymx-ymn)/ny;

   for(int j=0; j<=nx; j++){
     for(int k=0; k<=ny; k++){
       xj = xmn + difx*j;
       yk = ymn + dify*k; //formula

       int color = cnvnwt(xj, yk, tolcnv, maxit, narr, u, v); //et retorna 0 1 o 2 depenent del color que vulguis.
       if(color!=-1){
       printf("%lf %lf %d %d %d\n", xj, yk, vermell[color]*255, verd[color]*255, blau[color]*255); //on tingui el 1 quedara un 255 aka que s'ha de posar aquell color.
     } else {
       printf("%lf %lf %d %d %d\n", xj, yk, 255, 255, 255); //si error s'ha de posar color blanc.
     }

     }
   }
   return 0;
}
