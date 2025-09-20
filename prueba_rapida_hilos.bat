@echo off
echo ============================================
echo         PRUEBA RAPIDA DE HILOS
echo ============================================
echo.

REM Compilar primero
if exist "tcc\tcc.exe" (
    echo Intentando compilar con TCC...
    tcc\tcc.exe -o MatrizSec_hilos.exe MatrizSec_hilos.c
    if %errorlevel% neq 0 (
        echo TCC no soporta pthread en Windows. Necesitamos GCC.
        echo.
        echo Opciones:
        echo 1. Instalar MinGW: winget search mingw
        echo 2. Instalar Visual Studio Build Tools
        echo 3. Usar version sin hilos por ahora
        echo.
        pause
        exit /b 1
    )
) else (
    where gcc >nul 2>nul
    if %errorlevel% equ 0 (
        echo Compilando con GCC...
        gcc -O3 -pthread -o MatrizSec_hilos.exe MatrizSec_hilos.c
        if %errorlevel% neq 0 (
            echo Error en compilacion
            pause
            exit /b 1
        )
    ) else (
        echo No se encontro compilador compatible
        echo Necesitas GCC para soporte de pthread
        pause
        exit /b 1
    )
)

echo Compilacion exitosa!
echo.

echo === PRUEBA CON MATRIZ 100x100 ===
echo.
echo 1 Hilo:
MatrizSec_hilos.exe 100 1 3 0

echo.
echo 2 Hilos:
MatrizSec_hilos.exe 100 2 3 0

echo.
echo 4 Hilos:
MatrizSec_hilos.exe 100 4 3 0

echo.
echo === PRUEBA CON MATRIZ 500x500 ===
echo.
echo 1 Hilo:
MatrizSec_hilos.exe 500 1 2 0

echo.
echo 4 Hilos:
MatrizSec_hilos.exe 500 4 2 0

echo.
echo === PRUEBA COMPLETA ===
pause
