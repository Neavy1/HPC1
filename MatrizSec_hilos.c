#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include <pthread.h>
#include <unistd.h>

// Estructura para pasar datos a los hilos
typedef struct {
    int **A;           // Matriz A
    int **B;           // Matriz B
    int **Result;      // Matriz resultado
    int tamaño;        // Tamaño de la matriz
    int fila_inicio;   // Fila de inicio para este hilo
    int fila_fin;      // Fila de fin para este hilo
    int thread_id;     // ID del hilo
} ThreadData;

// Variables globales para sincronización
int num_hilos_global = 1;

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

// Función que ejecuta cada hilo para multiplicar una porción de la matriz
void* multiplicarPorcion(void* arg) {
    ThreadData* data = (ThreadData*)arg;
    
    // Cada hilo procesa las filas asignadas
    for (int i = data->fila_inicio; i < data->fila_fin; ++i) {
        for (int j = 0; j < data->tamaño; ++j) {
            data->Result[i][j] = 0;
            for (int k = 0; k < data->tamaño; ++k) {
                data->Result[i][j] += data->A[i][k] * data->B[k][j];
            }
        }
    }
    
    return NULL;
}

// Multiplicación de matrices con hilos
double multiplicarMatricesHilos(int **A, int **B, int **Result, int tamaño, int num_hilos) {
    pthread_t* hilos = (pthread_t*)malloc(num_hilos * sizeof(pthread_t));
    ThreadData* thread_data = (ThreadData*)malloc(num_hilos * sizeof(ThreadData));
    
    clock_t start_time = clock();
    
    // Calcular filas por hilo
    int filas_por_hilo = tamaño / num_hilos;
    int filas_restantes = tamaño % num_hilos;
    
    // Crear y lanzar hilos
    for (int t = 0; t < num_hilos; ++t) {
        thread_data[t].A = A;
        thread_data[t].B = B;
        thread_data[t].Result = Result;
        thread_data[t].tamaño = tamaño;
        thread_data[t].thread_id = t;
        
        // Calcular rango de filas para este hilo
        thread_data[t].fila_inicio = t * filas_por_hilo;
        thread_data[t].fila_fin = (t + 1) * filas_por_hilo;
        
        // El último hilo toma las filas restantes
        if (t == num_hilos - 1) {
            thread_data[t].fila_fin += filas_restantes;
        }
        
        // Crear hilo
        if (pthread_create(&hilos[t], NULL, multiplicarPorcion, &thread_data[t]) != 0) {
            printf("Error creando hilo %d\n", t);
            exit(1);
        }
    }
    
    // Esperar a que todos los hilos terminen
    for (int t = 0; t < num_hilos; ++t) {
        if (pthread_join(hilos[t], NULL) != 0) {
            printf("Error esperando hilo %d\n", t);
            exit(1);
        }
    }
    
    clock_t end_time = clock();
    double cpu_time_used = ((double)(end_time - start_time)) / CLOCKS_PER_SEC;
    
    free(hilos);
    free(thread_data);
    
    return cpu_time_used;
}

// Multiplicación secuencial para referencia
double multiplicarMatricesSecuencial(int **A, int **B, int **Result, int tamaño) {
    clock_t start_time = clock();
    
    for (int i = 0; i < tamaño; ++i) {
        for (int j = 0; j < tamaño; ++j) {
            Result[i][j] = 0;
            for (int k = 0; k < tamaño; ++k) {
                Result[i][j] += A[i][k] * B[k][j];
            }
        }
    }
    
    clock_t end_time = clock();
    return ((double)(end_time - start_time)) / CLOCKS_PER_SEC;
}

// Función para asignar memoria para matriz
int** asignarMatriz(int tamaño) {
    int **matriz = (int **)malloc(tamaño * sizeof(int *));
    if (!matriz) {
        printf("Error: No se pudo asignar memoria para la matriz\n");
        exit(1);
    }
    
    for (int i = 0; i < tamaño; ++i) {
        matriz[i] = (int *)calloc(tamaño, sizeof(int));
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
    if (argc != 5) {
        printf("Uso: %s <tamaño> <num_hilos> <iteraciones> <mostrar(0/1)>\n", argv[0]);
        printf("Ejemplo: %s 1000 4 5 0\n", argv[0]);
        printf("Hilos soportados: 1, 2, 4, 8, 16\n");
        return 1;
    }

    int tamaño = atoi(argv[1]);
    int num_hilos = atoi(argv[2]);
    int iteraciones = atoi(argv[3]);
    int mostrar = atoi(argv[4]);
    
    // Validaciones
    if (tamaño <= 0 || tamaño > 10000) {
        printf("Error: El tamaño debe estar entre 1 y 10000\n");
        return 1;
    }
    
    if (num_hilos != 1 && num_hilos != 2 && num_hilos != 4 && num_hilos != 8 && num_hilos != 16) {
        printf("Error: Número de hilos debe ser 1, 2, 4, 8 o 16\n");
        return 1;
    }
    
    if (iteraciones <= 0 || iteraciones > 100) {
        printf("Error: Iteraciones debe estar entre 1 y 100\n");
        return 1;
    }

    // Información del sistema
    printf("=== Multiplicación de Matrices con Hilos ===\n");
    printf("Tamaño: %dx%d\n", tamaño, tamaño);
    printf("Hilos: %d\n", num_hilos);
    printf("Iteraciones: %d\n", iteraciones);
    printf("CPUs disponibles: %d\n", (int)sysconf(_SC_NPROCESSORS_ONLN));
    printf("==========================================\n");

    // Inicializar semilla
    srand(time(NULL));

    // Asignar memoria para las matrices
    int **A = asignarMatriz(tamaño);
    int **B = asignarMatriz(tamaño);
    int **Result = asignarMatriz(tamaño);
    int **ResultSecuencial = asignarMatriz(tamaño);

    // Llenar las matrices A y B
    llenarMatriz(A, tamaño);
    llenarMatriz(B, tamaño);

    // Mostrar matrices si se solicita (solo para matrices pequeñas)
    if (mostrar == 1 && tamaño <= 20) {
        printf("Matriz A:\n");
        mostrarMatriz(A, tamaño);
        printf("\nMatriz B:\n");
        mostrarMatriz(B, tamaño);
    }

    // Arrays para almacenar tiempos
    double* tiempos_paralelos = (double*)malloc(iteraciones * sizeof(double));
    double tiempo_secuencial = 0.0;
    
    // Ejecutar multiplicación secuencial una vez para referencia
    printf("Ejecutando versión secuencial...\n");
    tiempo_secuencial = multiplicarMatricesSecuencial(A, B, ResultSecuencial, tamaño);
    
    // Ejecutar múltiples iteraciones de la versión paralela
    printf("Ejecutando versión paralela (%d iteraciones)...\n", iteraciones);
    for (int iter = 0; iter < iteraciones; ++iter) {
        // Reinicializar matriz resultado
        for (int i = 0; i < tamaño; ++i) {
            memset(Result[i], 0, tamaño * sizeof(int));
        }
        
        tiempos_paralelos[iter] = multiplicarMatricesHilos(A, B, Result, tamaño, num_hilos);
        printf("Iteración %d: %.4f segundos\n", iter + 1, tiempos_paralelos[iter]);
    }
    
    // Calcular estadísticas
    double suma_paralelo = 0.0;
    double min_paralelo = tiempos_paralelos[0];
    double max_paralelo = tiempos_paralelos[0];
    
    for (int i = 0; i < iteraciones; ++i) {
        suma_paralelo += tiempos_paralelos[i];
        if (tiempos_paralelos[i] < min_paralelo) min_paralelo = tiempos_paralelos[i];
        if (tiempos_paralelos[i] > max_paralelo) max_paralelo = tiempos_paralelos[i];
    }
    
    double promedio_paralelo = suma_paralelo / iteraciones;
    double speedup = tiempo_secuencial / promedio_paralelo;
    double eficiencia = speedup / num_hilos * 100.0;
    
    // Mostrar resultado si se solicita
    if (mostrar == 1 && tamaño <= 20) {
        printf("\nMatriz Resultado:\n");
        mostrarMatriz(Result, tamaño);
    }
    
    // Verificar corrección (comparar con resultado secuencial)
    int correcto = 1;
    for (int i = 0; i < tamaño && correcto; ++i) {
        for (int j = 0; j < tamaño && correcto; ++j) {
            if (Result[i][j] != ResultSecuencial[i][j]) {
                correcto = 0;
            }
        }
    }
    
    printf("\n=== RESULTADOS ===\n");
    printf("Tiempo secuencial: %.4f segundos\n", tiempo_secuencial);
    printf("Tiempo paralelo promedio: %.4f segundos\n", promedio_paralelo);
    printf("Tiempo paralelo mínimo: %.4f segundos\n", min_paralelo);
    printf("Tiempo paralelo máximo: %.4f segundos\n", max_paralelo);
    printf("Speedup: %.2fx\n", speedup);
    printf("Eficiencia: %.1f%%\n", eficiencia);
    printf("Resultado correcto: %s\n", correcto ? "SÍ" : "NO");
    
    // Formato CSV para análisis posterior
    printf("\n=== CSV OUTPUT ===\n");
    printf("Tamaño,Hilos,T_Secuencial,T_Paralelo_Avg,T_Paralelo_Min,T_Paralelo_Max,Speedup,Eficiencia,Correcto\n");
    printf("%d,%d,%.4f,%.4f,%.4f,%.4f,%.2f,%.1f,%s\n", 
           tamaño, num_hilos, tiempo_secuencial, promedio_paralelo, 
           min_paralelo, max_paralelo, speedup, eficiencia, 
           correcto ? "SI" : "NO");

    // Liberar memoria
    liberarMatriz(A, tamaño);
    liberarMatriz(B, tamaño);
    liberarMatriz(Result, tamaño);
    liberarMatriz(ResultSecuencial, tamaño);
    free(tiempos_paralelos);

    return 0;
}
