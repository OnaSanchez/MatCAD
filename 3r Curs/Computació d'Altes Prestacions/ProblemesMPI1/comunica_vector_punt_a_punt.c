#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <mpi.h>

void init_loc( double vloc[], int n, int b, int r, int p){

    int num_b = n/(p*b);

    for( int i = 0; i < num_b; i++ )
        for( int j = 0; j < b; j++ )
            vloc[i*b+j] = r + j/(10.0*b);
}

void print_local( double vloc[], int n, int r ){

    printf("Local del %d\n\t\t", r);

    for( int i = 0; i < n; i++ ) printf("%f ", vloc[i]);

    printf("\n");
}

void print_w( double w[], int n, int r ){
    printf("\nGlobal a %d\n\t\t", r);

    for( int i = 0; i < n; i++ ) printf("%f ", w[i]);

    printf("\n");
}

void comunica_vector( double vloc[], int n, int b, int p, int r, double w[] ){

    MPI_Status *stat;
    int i, j;
    
    MPI_Send(vloc, b, MPI_DOUBLE, 0, 0, MPI_COMM_WORLD);
    if (r == 0){ 
        for (i = 0; i < b; i ++) w[i] = vloc[i];
        for (j = 1; j < p; j++){
            MPI_Recv(vloc, b, MPI_DOUBLE, j, 0, MPI_COMM_WORLD, stat);
            for (i = 0; i < b; i++) w[j*b+i] = vloc[i];
        }

        for (i = 1; i < p; i++) MPI_Send(w, n, MPI_DOUBLE, i, 20, MPI_COMM_WORLD);
    }
    else MPI_Recv(w, n, MPI_DOUBLE, 0, 20, MPI_COMM_WORLD, stat);
}

int main(int argc, char *argv[]){

    double *vloc, *w;
    int rank, size;
    int n, b;

    if (argc < 3) return 1;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if (( b = atoi(argv[1])) < 1) return 1;
    if (( n = atoi(argv[2])) < b*size) return 1;

    if ( n%b*size ){
        MPI_Finalize();
        return 1;
    }

    if ((vloc = (double *)malloc((n/size)*sizeof(double))) == NULL) return 1;
    if ((w = (double *)malloc(n*sizeof(double))) == NULL) return 1;


    //printf("CONTROL 1\n");

    init_loc( vloc, n, b, rank, size );

   // printf("CONTROL 2\n");
    print_local( vloc, n/size, rank );
    comunica_vector( vloc, n, b, size, rank, w );

    //printf("CONTROL 3\n");

    print_w( w, n, rank );

    free(w);
    free(vloc);

    MPI_Finalize();
}