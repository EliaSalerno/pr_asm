@echo off
setlocal
set FILENAME=bitwise
set DLL_NAME=%FILENAME%.dll
set OBJ_NAME=%FILENAME%.obj
set ASM_NAME=%FILENAME%.asm

echo ============================================================
echo   COMPILAZIONE ESERCIZIO 08: OPERAZIONI BITWISE
echo ============================================================

echo [1/3] Assemblaggio di %ASM_NAME%...
ml /c /coff %ASM_NAME%
if %errorlevel% neq 0 (
    echo [ERRORE] Assemblaggio fallito.
    pause & exit /b 1
)

echo [2/3] Linking della DLL...
REM Esportazione SENZA underscore: con .MODEL FLAT, C, MASM aggiunge
REM gia' il '_' al simbolo nell'oggetto. /NOENTRY: nessuna DllMain.
link /DLL /SUBSYSTEM:WINDOWS /NOENTRY /EXPORT:InvertiBit /EXPORT:IsolaBit /OUT:%DLL_NAME% %OBJ_NAME%
if %errorlevel% neq 0 (
    echo [ERRORE] Linking fallito.
    pause & exit /b 1
)

echo [3/3] Copia della DLL nella cartella di build del progetto .NET...
REM La cartella reale di output di 'dotnet run' e' bin\Debug\net8.0-windows\
if not exist bin\Debug\net8.0-windows\ mkdir bin\Debug\net8.0-windows\
copy /Y %DLL_NAME% bin\Debug\net8.0-windows\ >nul

echo.
echo Fatto! Avvia il progetto con:  dotnet run
echo ============================================================
pause