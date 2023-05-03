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

// Output messages of error
#define E_NUM_SUBINTER "Error en la introducció de les dades: el nombre de subintervals ha de ser extrictament major a 0.\n"
#define E_FUNC "Error en la introducció de les dades: Apuntador a funció NULL.\n"
#define E_NUM_SUBINTER_LEG "Error en la introducció de les dades: el nombre de subintervals ha de ser igual a 2, 5 o 10.\n"

// Fuctions included in the librery
double Trapezi(double (*f)(double, void*), void* , double, double, int);
double Simpson(double (*f)(double, void*), void*, double, double, int);
double Legendre(double (*f)(double, void*), void*, double, double, int);
double Txebixev(double (*f)(double, void*), void*, double, double, int);
