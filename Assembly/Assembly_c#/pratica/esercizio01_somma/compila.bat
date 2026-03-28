@echo off
REM ============================================================
REM Compila somma.asm in somma.dll
REM Da eseguire nella "x86 Native Tools Command Prompt for VS"
REM ============================================================
echo Compilazione di somma.asm...
ml /c /coff somma.asm
if errorlevel 1 (
    echo ERRORE nella fase di assemblaggio!
    pause & exit /b 1
)
echo Linking in DLL...
link /DLL /SUBSYSTEM:WINDOWS /EXPORT:_Somma /OUT:somma.dll somma.obj
if errorlevel 1 (
    echo ERRORE nella fase di linking!
    pause & exit /b 1
)
echo.
echo Successo! Copia somma.dll nella cartella csharp_runner\
copy somma.dll ..\..\csharp_runner\somma.dll
echo Fatto.
pause
