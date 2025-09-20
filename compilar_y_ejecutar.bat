@echo off
echo === Compilador de Matrices ===
echo.

REM Verificar si existe un compilador
where gcc >nul 2>nul
if %errorlevel% equ 0 (
    set COMPILER=gcc
    set FLAGS=-O3 -march=native -ffast-math
    goto :compile
)

where cl >nul 2>nul
if %errorlevel% equ 0 (
    set COMPILER=cl
    set FLAGS=/O2 /arch:AVX2
    goto :compile_msvc
)

echo Error: No se encontró ningún compilador (gcc o cl)
echo.
echo Instala uno de estos:
echo 1. MinGW-w64: https://www.mingw-w64.org/downloads/
echo 2. Visual Studio Build Tools
echo 3. O usa 'winget install mingw'
pause
exit /b 1

:compile
echo Compilando con GCC (optimizaciones activadas)...
%COMPILER% %FLAGS% -o MatrizSec_original.exe MatrizSec.c
if %errorlevel% neq 0 (
    echo Error en compilación del original
    pause
    exit /b 1
)

%COMPILER% %FLAGS% -o MatrizSec_optimizado.exe MatrizSec_optimizado.c
if %errorlevel% neq 0 (
    echo Error en compilación del optimizado
    pause
    exit /b 1
)
goto :run_tests

:compile_msvc
echo Compilando con MSVC (optimizaciones activadas)...
%COMPILER% %FLAGS% MatrizSec.c /Fe:MatrizSec_original.exe
if %errorlevel% neq 0 (
    echo Error en compilación del original
    pause
    exit /b 1
)

%COMPILER% %FLAGS% MatrizSec_optimizado.c /Fe:MatrizSec_optimizado.exe
if %errorlevel% neq 0 (
    echo Error en compilación del optimizado
    pause
    exit /b 1
)

:run_tests
echo.
echo === Pruebas de Rendimiento ===
echo.

echo Prueba 1: Matrices 100x100
echo Versión original:
MatrizSec_original.exe 100 0
echo Versión optimizada:
MatrizSec_optimizado.exe 100 0 1

echo.
echo Prueba 2: Matrices 500x500
echo Versión original:
MatrizSec_original.exe 500 0
echo Versión optimizada:
MatrizSec_optimizado.exe 500 0 1

echo.
echo Prueba 3: Ejemplo pequeño (10x10) mostrando matrices
echo Versión optimizada:
MatrizSec_optimizado.exe 10 1 1

echo.
echo === Compilación y pruebas completadas ===
pause
