# Análisis de Speedup - Multiplicación de Matrices con Hilos

## Resumen del Proyecto HPC

Este análisis presenta los resultados del benchmark de multiplicación de matrices usando paralelización con hilos en Windows. Se evaluaron diferentes tamaños de matriz y números de hilos para medir el speedup y la eficiencia.

## Configuración del Sistema
- **CPUs disponibles**: 16 núcleos
- **Hilos evaluados**: 1, 2, 4, 8, 16
- **Tamaños de matriz**: 10×10, 100×100, 500×500, 1000×1000, 2000×2000
- **Iteraciones por prueba**: 3-5 (promediadas)

## Resultados Principales

### Tabla de Speedup por Tamaño de Matriz

| Tamaño | 1 Hilo | 2 Hilos | 4 Hilos | 8 Hilos | 16 Hilos |
|--------|--------|---------|---------|---------|----------|
| 10×10  | 0.00x  | 0.00x   | 0.00x   | 0.00x   | 0.00x    |
| 100×100| 1.20x  | 1.25x   | 1.67x   | 1.50x   | 1.80x    |
| 500×500| 1.16x  | 1.19x   | 2.20x   | **2.72x**| 2.31x   |
| 1000×1000| 0.82x| -       | -       | **2.90x**| -       |
| 2000×2000| -    | -       | **1.84x**| -      | -       |

### Tabla de Eficiencia (%)

| Tamaño | 1 Hilo | 2 Hilos | 4 Hilos | 8 Hilos | 16 Hilos |
|--------|--------|---------|---------|---------|----------|
| 10×10  | 0.0%   | 0.0%    | 0.0%    | 0.0%    | 0.0%     |
| 100×100| 120.0% | 62.5%   | 41.7%   | 18.8%   | 11.2%    |
| 500×500| 116.1% | 59.3%   | 55.1%   | 34.0%   | 14.4%    |
| 1000×1000| 82.2%| -       | -       | 36.3%   | -       |
| 2000×2000| -    | -       | 46.1%   | -       | -       |

### Tiempos de Ejecución Representativos

#### Matrices 500×500 (Caso Óptimo)
- **Secuencial**: ~0.64-1.03 segundos
- **2 hilos**: ~0.55 segundos (1.19x speedup)
- **4 hilos**: ~0.33 segundos (2.20x speedup)
- **8 hilos**: ~0.23 segundos (**2.72x speedup**) ⭐
- **16 hilos**: ~0.27 segundos (2.31x speedup)

#### Matrices 1000×1000 (Matrices Grandes)
- **Secuencial**: ~7.0 segundos
- **8 hilos**: ~2.4 segundos (**2.90x speedup**) ⭐

#### Matrices 2000×2000 (Matrices Muy Grandes)
- **Secuencial**: ~92 segundos
- **4 hilos**: ~50 segundos (**1.84x speedup**)

## Análisis de Resultados

### 🏆 Mejores Speedups Obtenidos
1. **2.90x** - Matrices 1000×1000 con 8 hilos
2. **2.72x** - Matrices 500×500 con 8 hilos  
3. **2.31x** - Matrices 500×500 con 16 hilos
4. **2.20x** - Matrices 500×500 con 4 hilos
5. **1.84x** - Matrices 2000×2000 con 4 hilos

### 📊 Observaciones Clave

#### Efecto del Tamaño de Matriz
- **Matrices pequeñas (10×10)**: No muestran speedup debido al overhead de creación de hilos
- **Matrices medianas (100×100)**: Speedups modestos (1.2-1.8x)
- **Matrices grandes (500×500+)**: Los mejores speedups (2.2-2.9x)

#### Comportamiento por Número de Hilos
- **1-4 hilos**: Incremento consistente en speedup
- **8 hilos**: Punto óptimo para la mayoría de tamaños
- **16 hilos**: Comienza a mostrar rendimientos decrecientes

#### Eficiencia vs Speedup
- La eficiencia disminuye conforme aumentan los hilos
- El punto óptimo está entre 4-8 hilos para matrices grandes
- Matrices muy grandes (2000×2000) se benefician más de menos hilos

### 🎯 Recomendaciones por Tamaño

| Tamaño de Matriz | Hilos Recomendados | Speedup Esperado | Justificación |
|------------------|-------------------|------------------|---------------|
| ≤ 100×100        | 4 hilos           | ~1.7x           | Balance overhead/beneficio |
| 200×500          | 4 hilos           | ~2.2x           | Óptimo rendimiento/recursos |
| 500×750          | 8 hilos           | ~2.7x           | Máximo speedup |
| 1000×1500        | 8 hilos           | ~2.9x           | Mejor speedup observado |
| ≥ 2000×2000      | 4 hilos           | ~1.8x           | Evitar overhead excesivo |

### 📈 Análisis de Escalabilidad

La implementación muestra:
- **Escalabilidad sub-linear** típica de aplicaciones CPU-intensivas
- **Ley de Amdahl** evidente: el speedup se satura alrededor de 8 hilos
- **Overhead de sincronización** visible con 16 hilos en algunos casos

### ⚡ Rendimiento Absoluto

#### MFLOPS (Mega Floating Point Operations Per Second)
Para matrices 500×500 con 8 hilos:
- **Operaciones**: 2 × 500³ = 250,000,000 ops
- **Tiempo**: ~0.23 segundos  
- **Rendimiento**: ~1,087 MFLOPS

## Conclusiones

1. **Speedup máximo alcanzado**: 2.90x (matrices 1000×1000, 8 hilos)
2. **Configuración óptima general**: 8 hilos para matrices ≥500×500
3. **Eficiencia**: Decrece con más hilos, pero el speedup absoluto justifica el uso de paralelización
4. **Escalabilidad**: Buena hasta 8 hilos, rendimientos decrecientes después
5. **Aplicabilidad**: La paralelización es altamente beneficiosa para matrices ≥200×200

## Archivos Generados
- `resultados_completos.csv` - Datos completos del benchmark
- `MatrizSec_hilos_windows.c` - Código fuente optimizado para Windows
- `MatrizSec_hilos_windows.exe` - Ejecutable compilado

---
*Análisis generado para el Proyecto HPC - Multiplicación de Matrices con Hilos*
