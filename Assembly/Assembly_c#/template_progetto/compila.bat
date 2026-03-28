@echo off
set FILENAME=funzione
set DLL_NAME=%FILENAME%.dll
set OBJ_NAME=%FILENAME%.obj
set ASM_NAME=%FILENAME%.asm

echo ============================================================
echo   COMPILATORE ASSEMBLY PER TESTRUNNER
echo ============================================================

REM Verifica se ML (Microsoft Assembler) e' disponibile nel PATH
ml /? >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERRORE] ML.EXE non trovato nel PATH.
    echo Esegui questo script da "Developer Command Prompt for VS" o "x86 Native Tools Command Prompt".
    pause
    exit /b 1
)

echo [1/3] Assemblaggio di %ASM_NAME%...
ml /c /coff %ASM_NAME%
if %errorlevel% neq 0 (
    echo [ERRORE] Errore durante l'assemblaggio.
    pause
    exit /b 1
)

echo [2/3] Linking della DLL...
REM Esportiamo la funzione aggiungendo l'underscore (convenzione CDECL x86)
link /DLL /SUBSYSTEM:WINDOWS /EXPORT:_MiaFunzione /OUT:%DLL_NAME% %OBJ_NAME%
if %errorlevel% neq 0 (
    echo [ERRORE] Errore durante il linking.
    pause
    exit /b 1
)

echo [3/3] Distribuzione della DLL...
REM Cerchiamo di copiare la DLL nelle cartelle di output di .NET se esistono
if exist bin\x86\Debug\net8.0-windows\ (
    copy /Y %DLL_NAME% bin\x86\Debug\net8.0-windows\ >nul
    echo      Copiata in Debug...
)
if exist bin\Debug\net8.0-windows\ (
    copy /Y %DLL_NAME% bin\Debug\net8.0-windows\ >nul
    echo      Copiata in Debug...
)

echo.
echo Successo! Ora puoi avviare il progetto in Visual Studio o con 'dotnet run'.
echo ============================================================
pause
