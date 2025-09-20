@echo off
setlocal enabledelayedexpansion

echo ============================================
echo    BENCHMARK COMPLETO - MATRIZ CON HILOS  
echo         PROYECTO HPC - SPEEDUP ANALYSIS
echo ============================================
echo.

REM Configuración del benchmark
set ITERACIONES=5
set TAMAÑOS=10 100 200 500 750 1000 2000
set HILOS=1 2 4 8 16

echo Compilando programa con hilos...
.\tcc\tcc.exe -o MatrizSec_hilos_windows.exe MatrizSec_hilos_windows.c
if %errorlevel% neq 0 (
    echo Error en compilacion
    pause
    exit /b 1
)
echo Compilacion exitosa!
echo.

REM Crear archivo de resultados con timestamp
set TIMESTAMP=%date:~6,4%%date:~3,2%%date:~0,2%_%time:~0,2%%time:~3,2%%time:~6,2%
set TIMESTAMP=%TIMESTAMP: =0%
set ARCHIVO_RESULTADOS=benchmark_speedup_%TIMESTAMP%.csv

echo === CONFIGURACION DEL BENCHMARK ===
echo Tamaños de matriz: %TAMAÑOS%
echo Número de hilos: %HILOS%
echo Iteraciones por prueba: %ITERACIONES%
echo Archivo de resultados: %ARCHIVO_RESULTADOS%
echo CPUs detectados: Se mostrará en cada prueba
echo.

REM Crear encabezado del CSV
echo Tamaño,Hilos,T_Secuencial,T_Paralelo_Avg,T_Paralelo_Min,T_Paralelo_Max,Speedup,Eficiencia,Correcto > %ARCHIVO_RESULTADOS%

REM Contador de pruebas
set /a PRUEBA_ACTUAL=0
set /a TOTAL_PRUEBAS=0

REM Calcular total de pruebas
for %%t in (%TAMAÑOS%) do (
    for %%h in (%HILOS%) do (
        set /a TOTAL_PRUEBAS+=1
    )
)

echo Total de pruebas a ejecutar: %TOTAL_PRUEBAS%
echo Tiempo estimado: ~%TOTAL_PRUEBAS% minutos
echo.
echo === INICIANDO BENCHMARK ===
echo.

REM Ejecutar benchmark para cada combinación
for %%t in (%TAMAÑOS%) do (
    echo ==========================================
    echo       PROBANDO MATRICES %%t x %%t
    echo ==========================================
    
    for %%h in (%HILOS%) do (
        set /a PRUEBA_ACTUAL+=1
        echo.
        echo [!PRUEBA_ACTUAL!/%TOTAL_PRUEBAS%] Tamaño: %%t, Hilos: %%h
        echo ----------------------------------------
        
        REM Ejecutar el programa y capturar resultado
        for /f "skip=1 tokens=*" %%i in ('MatrizSec_hilos_windows.exe %%t %%h %ITERACIONES% 0 ^| findstr /R "^[0-9]"') do (
            echo %%i >> %ARCHIVO_RESULTADOS%
            
            REM Extraer speedup para mostrar en pantalla
            for /f "tokens=7 delims=," %%s in ("%%i") do (
                echo   Speedup: %%sx
            )
        )
    )
    
    echo.
    echo Completado tamaño %%t x %%t
)

echo.
echo ============================================
echo           BENCHMARK COMPLETADO
echo ============================================
echo.

REM Mostrar resumen de speedups
echo === TABLA DE SPEEDUPS ===
echo.
echo Tamaño    ^| 1 Hilo ^| 2 Hilos ^| 4 Hilos ^| 8 Hilos ^| 16 Hilos
echo ---------|--------|---------|---------|---------|----------

for %%t in (%TAMAÑOS%) do (
    set "LINEA=%%t"
    
    REM Pad the size to 8 characters for alignment
    if %%t lss 10 set "LINEA=      %%t"
    if %%t geq 10 if %%t lss 100 set "LINEA=     %%t"
    if %%t geq 100 if %%t lss 1000 set "LINEA=    %%t"
    if %%t geq 1000 set "LINEA=   %%t"
    
    set "LINEA=!LINEA! ^|"
    
    for %%h in (%HILOS%) do (
        REM Buscar speedup para esta combinación
        for /f "tokens=7 delims=," %%s in ('findstr "^%%t,%%h," %ARCHIVO_RESULTADOS%') do (
            set "SPEEDUP=%%s"
            set "LINEA=!LINEA! !SPEEDUP!x ^|"
        )
    )
    echo !LINEA!
)

echo.
echo === ANALISIS DE EFICIENCIA ===
echo.

REM Encontrar mejores speedups por tamaño
echo Mejores speedups por tamaño de matriz:
for %%t in (%TAMAÑOS%) do (
    set MAX_SPEEDUP=0
    set BEST_THREADS=1
    
    for %%h in (%HILOS%) do (
        for /f "tokens=7 delims=," %%s in ('findstr "^%%t,%%h," %ARCHIVO_RESULTADOS% 2^>nul') do (
            set CURRENT_SPEEDUP=%%s
            REM Simple comparison (works for most cases)
            if %%s gtr !MAX_SPEEDUP! (
                set MAX_SPEEDUP=%%s
                set BEST_THREADS=%%h
            )
        )
    )
    echo   Tamaño %%t: !MAX_SPEEDUP!x con !BEST_THREADS! hilos
)

echo.
echo === ARCHIVOS GENERADOS ===
echo Resultados CSV: %ARCHIVO_RESULTADOS%
echo.

REM Crear script de análisis Python mejorado
echo Generando script de análisis...
(
echo import pandas as pd
echo import matplotlib.pyplot as plt
echo import numpy as np
echo import seaborn as sns
echo.
echo # Configurar estilo
echo plt.style.use^('seaborn-v0_8'^)
echo sns.set_palette^("husl"^)
echo.
echo # Leer datos
echo df = pd.read_csv^('%ARCHIVO_RESULTADOS%'^)
echo.
echo # Crear figura con múltiples subplots
echo fig, ^(ax1, ax2^) = plt.subplots^(1, 2, figsize=^(15, 6^)^)
echo.
echo # Gráfico 1: Speedup vs Hilos por tamaño
echo for size in sorted^(df['Tamaño'].unique^(^)^):
echo     data = df[df['Tamaño'] == size]
echo     ax1.plot^(data['Hilos'], data['Speedup'], 'o-', 
echo              label=f'Tamaño {size}', linewidth=2, markersize=8^)
echo.
echo ax1.set_xlabel^('Número de Hilos', fontsize=12^)
echo ax1.set_ylabel^('Speedup', fontsize=12^)
echo ax1.set_title^('Speedup vs Número de Hilos', fontsize=14, fontweight='bold'^)
echo ax1.legend^(bbox_to_anchor=^(1.05, 1^), loc='upper left'^)
echo ax1.grid^(True, alpha=0.3^)
echo ax1.set_xlim^(0.5, 16.5^)
echo.
echo # Línea de speedup ideal
echo ax1.plot^([1, 16], [1, 16], '--', color='gray', alpha=0.7, label='Speedup Ideal'^)
echo.
echo # Gráfico 2: Eficiencia vs Hilos
echo for size in sorted^(df['Tamaño'].unique^(^)^):
echo     data = df[df['Tamaño'] == size]
echo     ax2.plot^(data['Hilos'], data['Eficiencia'], 's-', 
echo              label=f'Tamaño {size}', linewidth=2, markersize=8^)
echo.
echo ax2.set_xlabel^('Número de Hilos', fontsize=12^)
echo ax2.set_ylabel^('Eficiencia ^(%%^)', fontsize=12^)
echo ax2.set_title^('Eficiencia vs Número de Hilos', fontsize=14, fontweight='bold'^)
echo ax2.legend^(bbox_to_anchor=^(1.05, 1^), loc='upper left'^)
echo ax2.grid^(True, alpha=0.3^)
echo ax2.set_xlim^(0.5, 16.5^)
echo ax2.set_ylim^(0, 110^)
echo.
echo plt.tight_layout^(^)
echo plt.savefig^('analisis_speedup_completo.png', dpi=300, bbox_inches='tight'^)
echo print^("✓ Gráficos guardados como 'analisis_speedup_completo.png'"^)
echo.
echo # Estadísticas resumen
echo print^("\\n=== ESTADISTICAS RESUMEN ==="^)
echo print^(f"Mejor speedup general: {df['Speedup'].max^(^):.2f}x"^)
echo best_row = df[df['Speedup'] == df['Speedup'].max^(^)]
echo print^(f"Conseguido con: Tamaño {best_row['Tamaño'].iloc[0]}, {best_row['Hilos'].iloc[0]} hilos"^)
echo print^(f"Eficiencia promedio: {df['Eficiencia'].mean^(^):.1f}%%"^)
echo print^(f"Mejor eficiencia: {df['Eficiencia'].max^(^):.1f}%%"^)
echo.
echo print^("\\n=== RECOMENDACIONES ==="^)
echo for size in sorted^(df['Tamaño'].unique^(^)^):
echo     size_data = df[df['Tamaño'] == size]
echo     best_speedup_idx = size_data['Speedup'].idxmax^(^)
echo     best = size_data.loc[best_speedup_idx]
echo     print^(f"Tamaño {size}: Usar {best['Hilos']} hilos ^(Speedup: {best['Speedup']:.2f}x^)"^)
) > analizar_speedup.py

echo ✓ Script de análisis creado: analizar_speedup.py
echo.
echo === INSTRUCCIONES ===
echo 1. Revisar resultados en: %ARCHIVO_RESULTADOS%
echo 2. Para análisis gráfico: python analizar_speedup.py
echo 3. Los gráficos se guardarán como: analisis_speedup_completo.png
echo.
echo ¡Benchmark completado exitosamente!
pause
