#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <mpi.h>

#define N 1024

float matriu[N][N];

void Init_Mat(float M[N][N]){
    int i, j;
    for (i = 0; i < N; i++)
        for (j = 0; j < N; j++)
            M[i][j] = ((j%2) ? -1.0 : 1.0)*(sin(i*1.0));
}

int main(int argc, char *argv[])
{
    int rank, size, d, i, j;
    MPI_Status status;
    float s, norm;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    printf("%d\n",rank);


    d = N/8;//size;
    float matriu_local[d][N];


    if (rank == 0){
        Init_Mat(matriu);
    }

    MPI_Scatter(matriu, // Valores a compartir
            d*N, // Cantidad que se envia a cada proceso
            MPI_FLOAT, // Tipo del dato que se enviara
            matriu_local, // Variable donde recibir los datos
            d*N, // Cantidad que recibe cada proceso
            MPI_FLOAT, // Tipo del dato que se recibira
            0,  // proceso principal que reparte los datos
            MPI_COMM_WORLD); // Comunicador (En este caso, el global)


    s = 0.0;
    norm = 0;


    for (i = 0; i < d; i++)
        for (j = 0; j < N; j++) s += matriu_local[i][j]*matriu_local[i][j];

    MPI_Reduce(&s, // Elemento a enviar
        &norm, // Variable donde se almacena la reunion de los datos
        1, // Cantidad de datos a reunir
        MPI_FLOAT, // Tipo del dato que se reunira
        MPI_SUM, // Operacion aritmetica a aplicar
        0, // Proceso que recibira los datos
        MPI_COMM_WORLD); // Comunicador

    if (rank == 0){
        norm = sqrt(norm);
        printf("norm=%f\n",norm);

    }

    MPI_Finalize();
}