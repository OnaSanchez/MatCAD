#include <stdio.h>
#include <math.h>

void avalp (double x, double y, double *px, double *py, //ens donen un complex z = x+iy, *px ha de tenir la part real de p(z) i *py la part imaginària.
      int n, double u[], double v[]) { //p(z)= (z − w0)(z − w1). . .(z − wn−1) on w = u + iv. Amb u dins de u[] i v dins de v[].

        double part_real, part_real_seguent, part_imaginaria, part_imaginaria_seguent, real;

        part_real = x - u[0];
        part_imaginaria = y - v[0];

        for(int i=1; i<n; i++){

          part_real_seguent = x - u[i];
          part_imaginaria_seguent = y - v[i];

          real = part_real*part_real_seguent - part_imaginaria*part_imaginaria_seguent;
          part_imaginaria = part_imaginaria*part_real_seguent + part_real*part_imaginaria_seguent;
          part_real = real;
        }

        *px = part_real;
        *py = part_imaginaria;
}

void avaldp (double x, double y, double *dpx, double *dpy,
      int n, double u[], double v[]) {

      double part_real, part_imaginaria, real=M_PI, total_real, total_imaginari, chorrada_suprema[n][2];

      total_real = 0;
      total_imaginari = 0;

      for(int i=0; i<n; i++){
        chorrada_suprema[i][0] = x - u[i]; //part real
        chorrada_suprema[i][1] = y - v[i]; //imaginaria
      }
      for(int i=0; i<n; i++){
        real = M_PI;
        for(int j=0; j<n; j++){
          if(i!=j){
            if(real==M_PI){ //el número pi no tindra mai part real
               part_real = chorrada_suprema[j][0];
               part_imaginaria = chorrada_suprema[j][1];
               real = 0; //si no le cambiamos el valor no para de entrar en el if.
            }else{
              real = part_real*chorrada_suprema[j][0] - part_imaginaria*chorrada_suprema[j][1] ;
              part_imaginaria = part_imaginaria*chorrada_suprema[j][0]  + part_real*chorrada_suprema[j][1];
              part_real = real;
            }
          }
        }
        total_real += part_real;
        total_imaginari += part_imaginaria;

      }

      *dpx = total_real;
      *dpy = total_imaginari;

}


int cnvnwt (double x, double y, double tolcnv, int maxit, //aplicar el mètode Newton fins a un maxim de maxit iterats. tolcnv és la tolerància.
      int n, double u[], double v[]) { //n és la llargada de u i de v.

        //la z = x0 = x + iy
        //1r vull evaluar p(z)  --> avalp
        //2n vull evaluar p'(z) --> avaldp
        //3r vull calcular x2 = x1 - (p(x1)/p'(x1))
        //4t si distancia < tolcnv, retornar j, si no tornar al 1r pas
        //repetir com a maxim maxit cops, si no ha retornat j que retorni -1.

        double  px, py, dpx, dpy, next_x, next_y, numerador_real, numerador_imaginari, denominador, frac_real, frac_imaginaria, distancia;
        int i = 0;

        do{
          avalp(x,y,&px,&py,n,u,v); //tinc la part real a px i la part imaginaria a py --> p(x1) EL PX I PY FUNCIONEN COM UNA VARIABLE, NO COM APUNTADORS.
          avaldp(x,y,&dpx,&dpy,n,u,v); //part real a dpx i part imaginaria a dpy --> p'(x1)

          numerador_real = px*dpx + py*dpy;
          numerador_imaginari = -px*dpy + dpx*py;
          denominador = pow(dpx,2) + pow(dpy,2);

          frac_real = numerador_real / denominador;
          frac_imaginaria = numerador_imaginari / denominador;

          next_x = x - frac_real; //x2
          next_y = y - frac_imaginaria; // y2

          for(int j=0; j<n; j++){
            distancia = sqrt(pow(x-u[j],2) + pow(y-v[j],2)); //distancia del punt x + yi a les arrels que estan als vectors u i v
            if(distancia < tolcnv){
              return j;
            }
          }

          x = next_x;
          y = next_y;

          i++;
        }while(i<maxit);
          return -1;

}
