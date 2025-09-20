@echo off
setlocal enabledelayedexpansion

echo ============================================
echo    BENCHMARK DE MULTIPLICACION DE MATRICES  
echo         CON HILOS - PROYECTO HPC
echo ============================================
echo.

REM Configuración del benchmark
set ITERACIONES=5
set TAMAÑOS=10 100 200 500 750 1000 2000
set HILOS=1 2 4 8 16

REM Verificar si existe un compilador
where gcc >nul 2>nul
if %errorlevel% equ 0 (
    set COMPILER=gcc
    set FLAGS=-O3 -pthread
    goto :compile
)

if exist "tcc\tcc.exe" (
    set COMPILER=tcc\tcc.exe
    set FLAGS=-lpthread
    goto :compile
) else (
    echo Error: No se encontro ningun compilador
    echo Necesitas GCC o TCC instalado
    pause
    exit /b 1
)

:compile
echo Compilando programa con hilos...
%COMPILER% %FLAGS% -o MatrizSec_hilos.exe MatrizSec_hilos.c
if %errorlevel% neq 0 (
    echo Error en compilacion
    pause
    exit /b 1
)
echo Compilacion exitosa!
echo.

REM Crear archivo de resultados
set TIMESTAMP=%date:~6,4%%date:~3,2%%date:~0,2%_%time:~0,2%%time:~3,2%%time:~6,2%
set TIMESTAMP=%TIMESTAMP: =0%
set ARCHIVO_RESULTADOS=benchmark_resultados_%TIMESTAMP%.csv

echo Creando archivo de resultados: %ARCHIVO_RESULTADOS%
echo Tamaño,Hilos,T_Secuencial,T_Paralelo_Avg,T_Paralelo_Min,T_Paralelo_Max,Speedup,Eficiencia,Correcto > %ARCHIVO_RESULTADOS%

echo.
echo === INICIANDO BENCHMARK ===
echo Archivo de resultados: %ARCHIVO_RESULTADOS%
echo Iteraciones por prueba: %ITERACIONES%
echo.

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
echo.

REM Ejecutar benchmark para cada combinación
for %%t in (%TAMAÑOS%) do (
    echo ==========================================
    echo Probando matrices %%t x %%t
    echo ==========================================
    
    for %%h in (%HILOS%) do (
        set /a PRUEBA_ACTUAL+=1
        echo.
        echo [!PRUEBA_ACTUAL!/%TOTAL_PRUEBAS%] Tamaño: %%t, Hilos: %%h
        echo Ejecutando...
        
        REM Ejecutar el programa y capturar solo la línea CSV
        for /f "skip=1 tokens=*" %%i in ('MatrizSec_hilos.exe %%t %%h %ITERACIONES% 0 ^| findstr /R "^[0-9]"') do (
            echo %%i >> %ARCHIVO_RESULTADOS%
            echo   Resultado: %%i
        )
    )
)

echo.
echo ============================================
echo           BENCHMARK COMPLETADO
echo ============================================
echo.
echo Resultados guardados en: %ARCHIVO_RESULTADOS%
echo.

REM Mostrar resumen de resultados
echo === RESUMEN DE SPEEDUPS ===
echo.
echo Tamaño    ^| 1 Hilo ^| 2 Hilos ^| 4 Hilos ^| 8 Hilos ^| 16 Hilos
echo ---------|--------|---------|---------|---------|----------

REM Procesar resultados para mostrar tabla de speedups
for %%t in (%TAMAÑOS%) do (
    set LINEA=%%t       ^|
    
    for %%h in (%HILOS%) do (
        REM Buscar la línea correspondiente en el archivo CSV
        for /f "tokens=7 delims=," %%s in ('findstr "^%%t,%%h," %ARCHIVO_RESULTADOS%') do (
            set SPEEDUP=%%s
            if "!SPEEDUP!"=="" set SPEEDUP=0.00
            set LINEA=!LINEA! !SPEEDUP!x  ^|
        )
    )
    echo !LINEA!
)

echo.
echo === ANALISIS RAPIDO ===

REM Encontrar mejor speedup
echo.
echo Buscando mejores speedups...
for /f "skip=1 tokens=1,2,7 delims=," %%a in (%ARCHIVO_RESULTADOS%) do (
    set SIZE=%%a
    set THREADS=%%b  
    set SPEEDUP=%%c
    echo Tamaño %%a con %%b hilos: %%cx speedup
)

echo.
echo Para analisis detallado, abrir: %ARCHIVO_RESULTADOS%
echo.

REM Crear script de Python para graficas (opcional)
echo Creando script de analisis...
(
echo import pandas as pd
echo import matplotlib.pyplot as plt
echo import numpy as np
echo.
echo # Leer datos
echo df = pd.read_csv^('%ARCHIVO_RESULTADOS%'^)
echo.
echo # Crear graficas de speedup
echo plt.figure^(figsize=^(12, 8^)^)
echo.
echo for size in df['Tamaño'].unique^(^):
echo     data = df[df['Tamaño'] == size]
echo     plt.plot^(data['Hilos'], data['Speedup'], 'o-', label=f'Tamaño {size}'^)
echo.
echo plt.xlabel^('Número de Hilos'^)
echo plt.ylabel^('Speedup'^)
echo plt.title^('Speedup vs Número de Hilos por Tamaño de Matriz'^)
echo plt.legend^(^)
echo plt.grid^(True^)
echo plt.savefig^('speedup_analysis.png'^)
echo print^("Gráfico guardado como speedup_analysis.png"^)
) > analizar_resultados.py

echo Script de análisis Python creado: analizar_resultados.py
echo ^(Ejecutar con: python analizar_resultados.py^)

echo.
pause
