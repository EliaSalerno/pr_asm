@echo off
setlocal
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
REM IMPORTANTE - NON aggiungere l'underscore!
REM Con .MODEL FLAT, C, MASM decora gia' da solo il simbolo come _MiaFunzione.
REM Il linker x86 aggiunge un ulteriore '_' ai nomi /EXPORT, quindi
REM /EXPORT:_MiaFunzione cercherebbe __MiaFunzione -> LNK2001.
REM /NOENTRY: la DLL non necessita di DllMain.
link /DLL /SUBSYSTEM:WINDOWS /NOENTRY /EXPORT:MiaFunzione /OUT:%DLL_NAME% %OBJ_NAME%
if %errorlevel% neq 0 (
    echo [ERRORE] Errore durante il linking.
    pause
    exit /b 1
)

echo [3/3] Distribuzione della DLL nella cartella di output di .NET...
REM P/Invoke cerca la DLL in bin\Debug\net8.0-windows\ (cartella dell'eseguibile).
if not exist bin\x86\Debug\net8.0-windows\ mkdir bin\x86\Debug\net8.0-windows\
copy /Y %DLL_NAME% bin\x86\Debug\net8.0-windows\ >nul
if not exist bin\Debug\net8.0-windows\ mkdir bin\Debug\net8.0-windows\
copy /Y %DLL_NAME% bin\Debug\net8.0-windows\ >nul

echo.
echo Successo! Ora puoi avviare il progetto in Visual Studio o con 'dotnet run'.
echo ============================================================
pause