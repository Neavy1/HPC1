@echo off
echo === BENCHMARK MANUAL DE SPEEDUP ===
echo.

REM Crear archivo de resultados
echo Tamaño,Hilos,T_Secuencial,T_Paralelo_Avg,T_Paralelo_Min,T_Paralelo_Max,Speedup,Eficiencia,Correcto > resultados_speedup.csv

echo Iniciando pruebas...

REM Pruebas con matriz 10x10
echo.
echo ===== MATRIZ 10x10 =====
MatrizSec_hilos_windows.exe 10 1 3 0 >> salida_temp.txt
MatrizSec_hilos_windows.exe 10 2 3 0 >> salida_temp.txt  
MatrizSec_hilos_windows.exe 10 4 3 0 >> salida_temp.txt
MatrizSec_hilos_windows.exe 10 8 3 0 >> salida_temp.txt
MatrizSec_hilos_windows.exe 10 16 3 0 >> salida_temp.txt

REM Pruebas con matriz 100x100
echo.
echo ===== MATRIZ 100x100 =====
MatrizSec_hilos_windows.exe 100 1 3 0 >> salida_temp.txt
MatrizSec_hilos_windows.exe 100 2 3 0 >> salida_temp.txt
MatrizSec_hilos_windows.exe 100 4 3 0 >> salida_temp.txt
MatrizSec_hilos_windows.exe 100 8 3 0 >> salida_temp.txt
MatrizSec_hilos_windows.exe 100 16 3 0 >> salida_temp.txt

REM Pruebas con matriz 500x500
echo.
echo ===== MATRIZ 500x500 =====
MatrizSec_hilos_windows.exe 500 1 3 0 >> salida_temp.txt
MatrizSec_hilos_windows.exe 500 2 3 0 >> salida_temp.txt
MatrizSec_hilos_windows.exe 500 4 3 0 >> salida_temp.txt
MatrizSec_hilos_windows.exe 500 8 3 0 >> salida_temp.txt
MatrizSec_hilos_windows.exe 500 16 3 0 >> salida_temp.txt

echo.
echo Procesando resultados...
REM Extraer líneas CSV y agregarlas al archivo final
findstr /R "^[0-9]" salida_temp.txt >> resultados_speedup.csv

echo.
echo Resultados guardados en: resultados_speedup.csv
del salida_temp.txt

pause
