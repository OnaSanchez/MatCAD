/*
 * Simplified simulation of high-energy particle storms
 *
 * Parallel computing (Degree in Computer Engineering)
 * 2017/2018
 *
 * Version: 2.0
 *
 * Sequential reference code.
 *
 * (c) 2018 Arturo Gonzalez-Escribano, Eduardo Rodriguez-Gutiez
 * Grupo Trasgo, Universidad de Valladolid (Spain)
 *
 * This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
 * https://creativecommons.org/licenses/by-sa/4.0/
 */
#include<stdio.h>
#include<stdlib.h>
#include<math.h>
#include<sys/time.h>
#include<mpi.h>
#include<omp.h>

/* Function to get wall time */
double cp_Wtime(){
    struct timeval tv;
    gettimeofday(&tv, NULL);
    return tv.tv_sec + 1.0e-6 * tv.tv_usec;
}


#define THRESHOLD    0.001f

/* Structure used to store data for one storm of particles */
typedef struct {
    int size;    // Number of particles
    int *posval; // Positions and values
} Storm;

/* THIS FUNCTION CAN BE MODIFIED */
/* Function to update a single position of the layer */
void update( float *layer, int layer_size, int k, int pos, float energy ) {
    /* 1. Compute the absolute value of the distance between the
        impact position and the k-th position of the layer */
    int distance = pos - k;
    if ( distance < 0 ) distance = - distance;

    /* 2. Impact cell has a distance value of 1 */
    distance = distance + 1;

    /* 3. Square root of the distance */
    /* NOTE: Real world atenuation typically depends on the square of the distance.
       We use here a tailored equation that affects a much wider range of cells */
    float atenuacion = sqrtf( (float)distance );

    /* 4. Compute attenuated energy */
    float energy_k = energy / layer_size / atenuacion;

    /* 5. Do not add if its absolute value is lower than the threshold */
    if ( energy_k >= THRESHOLD / layer_size || energy_k <= -THRESHOLD / layer_size )
        layer[k] = layer[k] + energy_k;
}


/* ANCILLARY FUNCTIONS: These are not called from the code section which is measured, leave untouched */
/* DEBUG function: Prints the layer status */
void debug_print(int layer_size, float *layer, int *positions, float *maximum, int num_storms ) {
    int i,k;
    /* Only print for array size up to 35 (change it for bigger sizes if needed) */
    if ( layer_size <= 35 ) {
        /* Traverse layer */
        for( k=0; k<layer_size; k++ ) {
            /* Print the energy value of the current cell */
            printf("%10.4f |", layer[k] );

            /* Compute the number of characters.
               This number is normalized, the maximum level is depicted with 60 characters */
            int ticks = (int)( 60 * layer[k] / maximum[num_storms-1] );

            /* Print all characters except the last one */
            for (i=0; i<ticks-1; i++ ) printf("o");

            /* If the cell is a local maximum print a special trailing character */
            if ( k>0 && k<layer_size-1 && layer[k] > layer[k-1] && layer[k] > layer[k+1] )
                printf("x");
            else
                printf("o");

            /* If the cell is the maximum of any storm, print the storm mark */
            for (i=0; i<num_storms; i++)
                if ( positions[i] == k ) printf(" M%d", i );

            /* Line feed */
            printf("\n");
        }
    }
}

/*
 * Function: Read data of particle storms from a file
 */
Storm read_storm_file( char *fname ) {
    FILE *fstorm = fopen( fname, "r" );
    if ( fstorm == NULL ) {
        fprintf(stderr,"Error: Opening storm file %s\n", fname );
        exit( EXIT_FAILURE );
    }

    Storm storm;
    int ok = fscanf(fstorm, "%d", &(storm.size) );
    if ( ok != 1 ) {
        fprintf(stderr,"Error: Reading size of storm file %s\n", fname );
        exit( EXIT_FAILURE );
    }

    storm.posval = (int *)malloc( sizeof(int) * storm.size * 2 );
    if ( storm.posval == NULL ) {
        fprintf(stderr,"Error: Allocating memory for storm file %s, with size %d\n", fname, storm.size );
        exit( EXIT_FAILURE );
    }

    int elem;
    for ( elem=0; elem<storm.size; elem++ ) {
        ok = fscanf(fstorm, "%d %d\n",
                    &(storm.posval[elem*2]),
                    &(storm.posval[elem*2+1]) );
        if ( ok != 2 ) {
            fprintf(stderr,"Error: Reading element %d in storm file %s\n", elem, fname );
            exit( EXIT_FAILURE );
        }
    }
    fclose( fstorm );

    return storm;
}

/*
 * MAIN PROGRAM
 */
int main(int argc, char *argv[]) {
    int i,j,k;

    /* 1.1. Read arguments */
    if (argc<3) {
        fprintf(stderr,"Usage: %s <size> <storm_1_file> [ <storm_i_file> ] ... \n", argv[0] );
        exit( EXIT_FAILURE );
    }

    int layer_size = atoi( argv[1] );
    int num_storms = argc-2;
    Storm storms[ num_storms ];

    /* 1.2. Read storms information */
    for( i=2; i<argc; i++ )
        storms[i-2] = read_storm_file( argv[i] );

    /* 1.3. Intialize maximum levels to zero */
    float maximum[ num_storms ];
    int positions[ num_storms ];

     #pragma omp parallel for
    for (i=0; i<num_storms; i++) {
        maximum[i] = 0.0f;
        positions[i] = 0;
    }

    /* 2. Begin time measurement */
    double ttotal = cp_Wtime();

    /* START: Do NOT optimize/parallelize the code of the main program above this point */

    int rank, nprocs, size;
    MPI_Status status;
    MPI_Init( &argc, &argv );
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &nprocs);


    size = layer_size/nprocs;

    float *layer = (float *)malloc( sizeof(float) * layer_size );
    float *layer_copy = (float *)malloc( sizeof(float) * layer_size );
    float *layer_priv = (float *)malloc( sizeof(float) * size );
    float *layer_copy_priv = (float *)malloc( sizeof(float) * size );

    if ( layer == NULL || layer_copy == NULL ) {
        fprintf(stderr,"Error: Allocating the layer memory\n");
        exit( EXIT_FAILURE );
    }

//      printf("holaaa\n");


    if(rank == 0){
         #pragma omp parallel for
         for( k=0; k<layer_size; k++ ){ layer[k] = 0.0f; layer_copy[k] = 0.0f; }
    }

//      printf("DIOS\n");

    MPI_Scatter(layer, size, MPI_FLOAT, layer_priv, size, MPI_FLOAT, 0, MPI_COMM_WORLD);
    MPI_Scatter(layer_copy, size, MPI_FLOAT, layer_copy_priv, size, MPI_FLOAT, 0, MPI_COMM_WORLD);
  //  printf("Oleole\n");

    for( i=0; i<num_storms; i++) {

        /* 4.1. Add impacts energies to layer cells */
        /* For each particle */
        for( j=0; j<storms[i].size; j++ ) {
            /* Get impact energy (expressed in thousandths) */
            float energy = (float)storms[i].posval[j*2+1] * 1000;
            /* Get impact position */
            int position = storms[i].posval[j*2];

            /* For each cell in the layer */
            #pragma omp parallel for
            for( k=0; k<size; k++ ) {

                /* Update the energy value for the cell */
                int distance = abs(position - (rank*size + k)) + 1;
                float atenuacion = sqrtf( (float)distance );
                /* 4. Compute attenuated energy */
                float energy_k = energy / (layer_size * atenuacion);
                float Tls = THRESHOLD / layer_size;

                /* 5. Do not add if its absolute value is lower than the threshold */
                if ( energy_k >= Tls || energy_k <= -Tls )
                         layer_priv[k] = layer_priv[k] + energy_k;

            }
        }

/* 4.2. Energy relaxation between storms */
        /* 4.2.1. Copy values to the ancillary array */
        #pragma omp parallel for
        for( k=0; k<size; k++ ) layer_copy_priv[k] = layer_priv[k];

        /* 4.2.2. Update layer using the ancillary values.
 *                   Skip updating the first and last positions */
        float inferior, superior;
//      printf("Oleole2\n");
        if(rank != nprocs-1){
                MPI_Send(&layer_priv[size-1], 1, MPI_FLOAT, rank + 1, rank, MPI_COMM_WORLD);
                MPI_Recv(&superior, 1, MPI_FLOAT, rank + 1, rank + 1 + nprocs, MPI_COMM_WORLD, &status);
        }
        if(rank != 0){
                MPI_Send(&layer_priv[0], 1, MPI_FLOAT, rank - 1, rank + nprocs, MPI_COMM_WORLD);
                MPI_Recv(&inferior, 1, MPI_FLOAT, rank - 1, rank - 1, MPI_COMM_WORLD, &status);
        }


        if(rank == 0){
                #pragma omp parallel for
                for ( k=1; k<size; k++ ) {
                        if(k != size-1) layer_priv[k] = ( layer_copy_priv[k-1] + layer_copy_priv[k] + layer_copy_priv[k+1] ) / 3;
                        else layer_priv[k] = ( layer_copy_priv[k-1] + layer_copy_priv[k] + superior ) / 3;
                }
        }
        else if(rank == nprocs -1){
                #pragma omp parallel for
                for( k=0; k<size-1; k++ ) {
                        if(k != 0) layer_priv[k] = ( layer_copy_priv[k-1] + layer_copy_priv[k] + layer_copy_priv[k+1] ) / 3;
                        else layer_priv[k] = ( inferior + layer_copy_priv[k] + layer_copy_priv[k+1] ) / 3;
                }
        }
        else {
                #pragma omp parallel for
                for( k=0; k<size; k++ ){
                        if(k == 0) layer_priv[k] = ( inferior + layer_copy_priv[k] + layer_copy_priv[k+1] ) / 3;
                        else if(k == size - 1) layer_priv[k] = ( layer_copy_priv[k-1] + layer_copy_priv[k] + superior ) / 3;
                        else    layer_priv[k] = ( layer_copy_priv[k-1] + layer_copy_priv[k] + layer_copy_priv[k+1] ) / 3;
                }
        }
//      printf("Oleole3\n");
        struct tupla {
                float maxi_layer;
                int posicio_layer;
        };

//      printf("OK?\n");

        struct tupla *aux = malloc(size * sizeof *aux);
        struct tupla *maxi = malloc(size * sizeof *maxi);

//      printf("SIP\n");
        #pragma omp parallel for
        for(k = 0; k < size; k++){ aux[k].maxi_layer = layer_priv[k]; aux[k].posicio_layer = rank*(size) + k;}

        MPI_Reduce(aux, maxi, size, MPI_FLOAT_INT, MPI_MAXLOC, 0, MPI_COMM_WORLD);
//      printf("Oleole4\n");
        maximum[i] = maxi[0].maxi_layer;
        positions[i] = maxi[0].posicio_layer;

        if(rank == 0){
                for(j=1; j<size; j++){
                        if(maxi[j].maxi_layer > maximum[i]){
                                maximum[i] = maxi[j].maxi_layer;
                                positions[i] = maxi[j].posicio_layer;
                        }
                }
        }
    }

/* END: Do NOT optimize/parallelize the code below this point */

    /* 5. End time measurement */
    ttotal = cp_Wtime() - ttotal;

    /* 6. DEBUG: Plot the result (only for layers up to 35 points) */
    #ifdef DEBUG
    debug_print( layer_size, layer, positions, maximum, num_storms );
    #endif

    if (rank == 0){
        /* 7. Results output, used by the Tablon online judge software */
        printf("\n");
        /* 7.1. Total computation time */
        printf("Time: %lf\n", ttotal );
        /* 7.2. Print the maximum levels */
        printf("Result:");
        for (i=0; i<num_storms; i++)
            printf(" %d %f", positions[i], maximum[i] );
        printf("\n");
    }
    /* 8. Free resources */
    for( i=0; i<argc-2; i++ )
        free( storms[i].posval );

    /* 9. Program ended successfully */
    return 0;
