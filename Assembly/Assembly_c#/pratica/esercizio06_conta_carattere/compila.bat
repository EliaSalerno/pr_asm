@echo off
set FILENAME=conta
set DLL_NAME=%FILENAME%.dll
set OBJ_NAME=%FILENAME%.obj
set ASM_NAME=%FILENAME%.asm

echo ============================================================
echo   COMPILAZIONE ESERCIZIO 06: CONTA CARATTERE
echo ============================================================

ml /c /coff %ASM_NAME%
if %errorlevel% neq 0 (
    echo [ERRORE] Assemblaggio fallito.
    pause & exit /b 1
)

REM Esportiamo la funzione _ContaCarattere
link /DLL /SUBSYSTEM:WINDOWS /EXPORT:_ContaCarattere /OUT:%DLL_NAME% %OBJ_NAME%
if %errorlevel% neq 0 (
    echo [ERRORE] Linking fallito.
    pause & exit /b 1
)

echo.
echo [OK] DLL generata con successo.
echo [OK] Copia della DLL nella cartella di output del runner...

REM Copia nelle cartelle standard di build di .NET
if not exist bin\x86\Debug\net8.0-windows\ mkdir bin\x86\Debug\net8.0-windows\
copy /Y %DLL_NAME% bin\x86\Debug\net8.0-windows\

echo.
echo Fatto! Ora puoi avviare il progetto.
echo ============================================================
pause
