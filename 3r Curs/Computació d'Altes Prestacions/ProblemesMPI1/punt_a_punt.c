#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main ( int argc, char ** argv) {
 int PING_PONG_LIMIT;
 sscanf(argv[1],"%d", &PING_PONG_LIMIT);
 int rank, size;
 char mess[128];

 MPI_Init(&argc, &argv);
 MPI_Comm_rank(MPI_COMM_WORLD, &rank);
 MPI_Comm_size(MPI_COMM_WORLD, &size);

 // Estamos asumiendo 2 procesos para esta tarea
 if (size != 2 ) {
    fprintf (stderr, " El size debe ser dos para %s \n " , argv[ 0 ]);
    return 1;
 }

 int ping_pong_count=0;
 int count = strlen(mess)+1;

 strcpy(mess,"Tururururu Tiriririri");
 double t_inici, t_final, t_total, t_mitja;

 while (ping_pong_count<PING_PONG_LIMIT) {
      t_inici = MPI_Wtime();
      if (rank == 0 ) {
         MPI_Send (&mess, count , MPI_CHAR, 1, 20 , MPI_COMM_WORLD);

      }
      if(rank == 1) {
         MPI_Recv (&mess, 128, MPI_CHAR, 0, 20 , MPI_COMM_WORLD,
         MPI_STATUS_IGNORE);
         MPI_Send (&mess, count , MPI_CHAR, 0, 11 , MPI_COMM_WORLD);
      }
      if(rank == 0){
        MPI_Recv (&mess, 128, MPI_CHAR, 1, 11 , MPI_COMM_WORLD,
         MPI_STATUS_IGNORE);
      }
      ping_pong_count++;
      t_final = MPI_Wtime();
      t_total += t_final - t_inici;
  }

  t_mitja = t_total / PING_PONG_LIMIT;
  printf("El temps mitjà per interacció és de: %lf\n", t_mitja);
  MPI_Finalize();
}