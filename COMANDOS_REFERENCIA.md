# 📋 GUÍA DE COMANDOS - PROYECTO HPC MATRICES
## Manual de Referencia Rápida

---

## 🚀 **COMANDOS BÁSICOS PARA EJECUTAR**

### 🔧 **1. COMPILACIÓN**

```bash
# Compilar programa original
.\tcc\tcc.exe -o MatrizSec_original.exe MatrizSec.c

# Compilar versión optimizada
.\tcc\tcc.exe -o MatrizSec_optimizado.exe MatrizSec_optimizado.c

# Compilar versión con hilos
.\tcc\tcc.exe -o MatrizSec_hilos_windows.exe MatrizSec_hilos_windows.c
```

### ⚡ **2. EJECUCIÓN DE PROGRAMAS**

#### **Programa Original**
```bash
# Sintaxis: programa <tamaño> <mostrar(0/1)>
.\MatrizSec_original.exe 100 0          # 100x100, sin mostrar
.\MatrizSec_original.exe 10 1           # 10x10, mostrar matrices
```

#### **Programa Optimizado**
```bash
# Sintaxis: programa <tamaño> <mostrar(0/1)> <optimizado(0/1)>
.\MatrizSec_optimizado.exe 1000 0 1     # 1000x1000, optimizado
.\MatrizSec_optimizado.exe 500 0 0      # 500x500, algoritmo clásico
```

#### **Programa con Hilos** ⭐
```bash
# Sintaxis: programa <tamaño> <hilos> <iteraciones> <mostrar(0/1)>
.\MatrizSec_hilos_windows.exe 500 8 3 0   # 500x500, 8 hilos, 3 iter
.\MatrizSec_hilos_windows.exe 1000 4 5 0  # 1000x1000, 4 hilos, 5 iter
.\MatrizSec_hilos_windows.exe 100 2 3 1   # 100x100, 2 hilos, mostrar
```

---

## 🎯 **CONFIGURACIONES RECOMENDADAS**

### 🏆 **Mejores Speedups Demostrados**
```bash
# MÁXIMO SPEEDUP (2.90x)
.\MatrizSec_hilos_windows.exe 1000 8 5 0

# EXCELENTE RENDIMIENTO (2.72x)
.\MatrizSec_hilos_windows.exe 500 8 5 0

# BALANCEADO (2.20x, 55% eficiencia)
.\MatrizSec_hilos_windows.exe 500 4 5 0

# MATRICES GRANDES (1.84x)
.\MatrizSec_hilos_windows.exe 2000 4 3 0
```

### 📊 **Por Escenario de Uso**
```bash
# DESARROLLO Y PRUEBAS
.\MatrizSec_hilos_windows.exe 100 4 3 1   # Matrices pequeñas, mostrar

# BENCHMARKING CIENTÍFICO
.\MatrizSec_hilos_windows.exe 1000 8 5 0  # Máximo speedup

# PRODUCCIÓN HPC
.\MatrizSec_hilos_windows.exe 500 8 10 0  # Alto rendimiento, más iteraciones

# MEMORIA LIMITADA
.\MatrizSec_hilos_windows.exe 2000 4 2 0  # Matrices grandes, pocos hilos
```

---

## 🔄 **SCRIPTS AUTOMATIZADOS**

### 📈 **Benchmark Completo**
```bash
# Ejecutar todas las pruebas automáticamente
.\benchmark_completo.bat

# Benchmark simplificado (más rápido)
.\ejecutar_benchmark.bat

# Prueba rápida de funcionalidad
.\prueba_rapida_hilos.bat
```

### 📊 **Generar Análisis y Gráficos**
```bash
# Generar gráficos y estadísticas
python generar_graficos.py

# Mostrar resultados finales
.\mostrar_resultados.bat
```

### 🔧 **Compilación Automática**
```bash
# Compilar todas las versiones
.\compilar_y_ejecutar.bat
```

---

## 📋 **EJEMPLOS PRÁCTICOS PASO A PASO**

### 🎯 **Ejemplo 1: Prueba Rápida de Speedup**
```bash
# Paso 1: Compilar
.\tcc\tcc.exe -o MatrizSec_hilos_windows.exe MatrizSec_hilos_windows.c

# Paso 2: Probar secuencial
.\MatrizSec_hilos_windows.exe 500 1 3 0

# Paso 3: Probar paralelo
.\MatrizSec_hilos_windows.exe 500 8 3 0

# Resultado esperado: ~2.7x speedup
```

### 📊 **Ejemplo 2: Comparar Diferentes Hilos**
```bash
# Probar configuraciones para encontrar la óptima
.\MatrizSec_hilos_windows.exe 1000 1 3 0   # Baseline
.\MatrizSec_hilos_windows.exe 1000 2 3 0   # 2 hilos
.\MatrizSec_hilos_windows.exe 1000 4 3 0   # 4 hilos
.\MatrizSec_hilos_windows.exe 1000 8 3 0   # 8 hilos ⭐ (mejor)
.\MatrizSec_hilos_windows.exe 1000 16 3 0  # 16 hilos
```

### 🔬 **Ejemplo 3: Análisis Científico Completo**
```bash
# Paso 1: Ejecutar benchmark completo
.\ejecutar_benchmark.bat

# Paso 2: Generar gráficos
python generar_graficos.py

# Paso 3: Ver resultados
.\mostrar_resultados.bat

# Archivos generados:
# - analisis_speedup_matrices.png
# - rendimiento_absoluto.png
# - resultados_completos.csv
```

---

## 🛠️ **COMANDOS DE MANTENIMIENTO**

### 📁 **Gestión de Archivos**
```bash
# Limpiar archivos temporales
del *.tmp
del salida_temp.txt

# Listar archivos generados
dir *.png
dir *.csv
dir *.md

# Verificar executables
dir *.exe
```

### 🔍 **Verificación de Sistema**
```bash
# Verificar compilador
.\tcc\tcc.exe --version

# Verificar Python y librerías
python --version
python -c "import matplotlib, pandas, numpy; print('OK')"

# Verificar CPUs disponibles
echo %NUMBER_OF_PROCESSORS%
```

---

## ⚡ **COMANDOS RÁPIDOS FRECUENTES**

### 🏃 **Ejecución Rápida (Copiar y Pegar)**
```bash
# Speedup máximo demostrado
.\MatrizSec_hilos_windows.exe 1000 8 3 0

# Prueba rápida desarrollo
.\MatrizSec_hilos_windows.exe 100 4 3 1

# Benchmark de 5 configuraciones principales
.\MatrizSec_hilos_windows.exe 500 1 3 0 && .\MatrizSec_hilos_windows.exe 500 2 3 0 && .\MatrizSec_hilos_windows.exe 500 4 3 0 && .\MatrizSec_hilos_windows.exe 500 8 3 0 && .\MatrizSec_hilos_windows.exe 500 16 3 0
```

### 📊 **Generar Reportes Rápido**
```bash
# Todo en uno (compilar + benchmark + gráficos)
.\tcc\tcc.exe -o MatrizSec_hilos_windows.exe MatrizSec_hilos_windows.c && .\ejecutar_benchmark.bat && python generar_graficos.py
```

---

## 🚨 **SOLUCIÓN DE PROBLEMAS**

### ❌ **Si no compila:**
```bash
# Verificar compilador
where tcc
dir tcc\tcc.exe

# Reinstalar TCC si es necesario
# (descargar desde proyecto original)
```

### ❌ **Si falla Python:**
```bash
# Instalar librerías faltantes
pip install matplotlib seaborn pandas numpy

# Verificar instalación
python -c "import matplotlib; print('OK')"
```

### ❌ **Si no encuentra archivos:**
```bash
# Verificar directorio actual
cd /d "C:\Users\LENOVO\Desktop\Proyecto HPC"
dir
```

### ❌ **Si el speedup es bajo:**
```bash
# Verificar que no hay otros procesos pesados
# Usar tamaños de matriz ≥500 para mejores resultados
# Preferir 8 hilos en sistemas con 8+ cores
```

---

## 📝 **PARÁMETROS DE ENTRADA**

### 🔢 **Rangos Recomendados**
```
Tamaño de matriz:  10 - 2000 (óptimo: 500-1000)
Número de hilos:   1, 2, 4, 8, 16 (óptimo: 4-8)
Iteraciones:       3-10 (3 para pruebas, 5+ para benchmark)
Mostrar matrices:  0 (no), 1 (sí, solo ≤20x20)
```

### ⚠️ **Limitaciones**
```
- Matrices >2000: mucho tiempo de ejecución
- Hilos >16: rendimientos decrecientes
- Mostrar matrices >20x20: salida muy larga
- Iteraciones >10: innecesario para análisis
```

---

## 🎯 **CONFIGURACIONES GANADORAS COMPROBADAS**

```bash
# 🏆 TOP 5 CONFIGURACIONES CON MEJOR SPEEDUP
.\MatrizSec_hilos_windows.exe 1000 8 5 0   # 2.90x ⭐ MÁXIMO
.\MatrizSec_hilos_windows.exe 500 8 5 0    # 2.72x ⭐ EXCELENTE  
.\MatrizSec_hilos_windows.exe 500 16 5 0   # 2.31x ✅ BUENO
.\MatrizSec_hilos_windows.exe 500 4 5 0    # 2.20x ✅ BALANCEADO
.\MatrizSec_hilos_windows.exe 2000 4 3 0   # 1.84x ✅ GRANDES
```

---

## 📚 **ARCHIVOS DE REFERENCIA**

### 📖 **Documentación**
- `REPORTE_FINAL_HPC.md` - Análisis ejecutivo completo
- `TABLA_COMPARATIVA_SPEEDUP.md` - Comparativas detalladas
- `analisis_speedup_completo.md` - Análisis técnico

### 📊 **Datos**
- `resultados_completos.csv` - Dataset completo
- `analisis_speedup_matrices.png` - Gráficos principales
- `rendimiento_absoluto.png` - MFLOPS comparativo

---

## 🏁 **COMANDO DE DEMOSTRACIÓN FINAL**

```bash
# 🚀 DEMO COMPLETA (ejecutar todo de una vez)
echo "=== DEMO PROYECTO HPC ===" && .\MatrizSec_hilos_windows.exe 500 8 3 0 && echo "SPEEDUP MAXIMO DEMOSTRADO!" && python generar_graficos.py
```

---

**💡 TIP**: Guarda este archivo como referencia. Estos comandos te permiten reproducir todo el análisis de speedup en cualquier momento.

**🎯 RECUERDA**: Los mejores resultados se obtienen con matrices 500x500-1000x1000 usando 8 hilos.

---
*📋 Comandos verificados y probados - Proyecto HPC Matrices con Hilos*
