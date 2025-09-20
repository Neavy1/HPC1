#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>

// Tamaño de bloque para optimización de cache
#define BLOCK_SIZE 64

// Función para llenar la matriz con números aleatorios entre 1 y 100
void llenarMatriz(int **matriz, int tamaño) {
    for (int i = 0; i < tamaño; ++i) {
        for (int j = 0; j < tamaño; ++j) {
            matriz[i][j] = rand() % 100 + 1;
        }
    }
}

// Función para mostrar la matriz en pantalla
void mostrarMatriz(int **matriz, int tamaño) {
    for (int i = 0; i < tamaño; ++i) {
        for (int j = 0; j < tamaño; ++j) {
            printf("%d ", matriz[i][j]);
        }
        printf("\n");
    }
}

// Multiplicación de matrices optimizada con blocking para mejor cache locality
void multiplicarMatricesOptimizada(int **A, int **B, int **Result, int tamaño) {
    // Inicializar matriz resultado a cero
    for (int i = 0; i < tamaño; ++i) {
        memset(Result[i], 0, tamaño * sizeof(int));
    }
    
    // Blocking/Tiling para optimización de cache
    for (int ii = 0; ii < tamaño; ii += BLOCK_SIZE) {
        for (int jj = 0; jj < tamaño; jj += BLOCK_SIZE) {
            for (int kk = 0; kk < tamaño; kk += BLOCK_SIZE) {
                
                int i_limit = (ii + BLOCK_SIZE < tamaño) ? ii + BLOCK_SIZE : tamaño;
                int j_limit = (jj + BLOCK_SIZE < tamaño) ? jj + BLOCK_SIZE : tamaño;
                int k_limit = (kk + BLOCK_SIZE < tamaño) ? kk + BLOCK_SIZE : tamaño;
                
                for (int i = ii; i < i_limit; ++i) {
                    for (int j = jj; j < j_limit; ++j) {
                        register int sum = Result[i][j];
                        for (int k = kk; k < k_limit; ++k) {
                            sum += A[i][k] * B[k][j];
                        }
                        Result[i][j] = sum;
                    }
                }
            }
        }
    }
}

// Función original para comparación
void multiplicarMatrices(int **A, int **B, int **Result, int tamaño) {
    for (int i = 0; i < tamaño; ++i) {
        for (int j = 0; j < tamaño; ++j) {
            Result[i][j] = 0;
            for (int k = 0; k < tamaño; ++k) {
                Result[i][j] += A[i][k] * B[k][j];
            }
        }
    }
}

// Función para asignar memoria de forma más eficiente
int** asignarMatriz(int tamaño) {
    int **matriz = (int **)malloc(tamaño * sizeof(int *));
    if (!matriz) {
        printf("Error: No se pudo asignar memoria para la matriz\n");
        exit(1);
    }
    
    for (int i = 0; i < tamaño; ++i) {
        matriz[i] = (int *)calloc(tamaño, sizeof(int)); // calloc inicializa a 0
        if (!matriz[i]) {
            printf("Error: No se pudo asignar memoria para la fila %d\n", i);
            exit(1);
        }
    }
    return matriz;
}

// Función para liberar memoria
void liberarMatriz(int **matriz, int tamaño) {
    for (int i = 0; i < tamaño; ++i) {
        free(matriz[i]);
    }
    free(matriz);
}

int main(int argc, char *argv[]) {
    if (argc != 4) {
        printf("Uso: %s <tamaño> <imprimir(0/1)> <optimizado(0/1)>\n", argv[0]);
        printf("Ejemplo: %s 1000 0 1\n", argv[0]);
        return 1;
    }

    int tamaño = atoi(argv[1]);
    int imprimir = atoi(argv[2]);
    int optimizado = atoi(argv[3]);
    
    // Validación de entrada
    if (tamaño <= 0 || tamaño > 10000) {
        printf("Error: El tamaño debe estar entre 1 y 10000\n");
        return 1;
    }

    // Inicializar semilla una sola vez
    srand(time(NULL));

    printf("Multiplicación de matrices %dx%d\n", tamaño, tamaño);
    printf("Algoritmo: %s\n", optimizado ? "Optimizado (Blocking)" : "Clásico");

    // Asignar memoria para las matrices
    int **A = asignarMatriz(tamaño);
    int **B = asignarMatriz(tamaño);
    int **Result = asignarMatriz(tamaño);

    // Llenar las matrices A y B con números aleatorios
    printf("Llenando matrices...\n");
    llenarMatriz(A, tamaño);
    llenarMatriz(B, tamaño);

    // Mostrar las matrices si se solicita (solo para matrices pequeñas)
    if (imprimir == 1 && tamaño <= 20) {
        printf("Matriz A:\n");
        mostrarMatriz(A, tamaño);
        printf("\nMatriz B:\n");
        mostrarMatriz(B, tamaño);
    } else if (imprimir == 1 && tamaño > 20) {
        printf("Matrices muy grandes para mostrar (tamaño > 20)\n");
    }

    // Multiplicar las matrices y medir tiempo
    printf("Iniciando multiplicación...\n");
    clock_t start_time = clock();
    
    if (optimizado) {
        multiplicarMatricesOptimizada(A, B, Result, tamaño);
    } else {
        multiplicarMatrices(A, B, Result, tamaño);
    }
    
    clock_t end_time = clock();
    double cpu_time_used = ((double)(end_time - start_time)) / CLOCKS_PER_SEC;
    
    // Mostrar resultado si se solicita y la matriz es pequeña
    if (imprimir == 1 && tamaño <= 20) {
        printf("\nMatriz Resultado:\n");
        mostrarMatriz(Result, tamaño);
    }
    
    printf("\nTiempo de ejecución: %.4f segundos\n", cpu_time_used);
    printf("Operaciones por segundo: %.2f MFLOPS\n", 
           (2.0 * tamaño * tamaño * tamaño) / (cpu_time_used * 1000000));

    // Liberar memoria
    liberarMatriz(A, tamaño);
    liberarMatriz(B, tamaño);
    liberarMatriz(Result, tamaño);

    return 0;
}
