@echo off
REM ============================================================
REM Compila massimo.asm in massimo.dll
REM ============================================================
echo Compilazione di massimo.asm...
ml /c /coff massimo.asm
if errorlevel 1 ( echo ERRORE assemblaggio! & pause & exit /b 1 )
link /DLL /SUBSYSTEM:WINDOWS /EXPORT:_Massimo /OUT:massimo.dll massimo.obj
if errorlevel 1 ( echo ERRORE linking! & pause & exit /b 1 )
copy massimo.dll ..\..\csharp_runner\massimo.dll
echo Fatto. DLL copiata in csharp_runner\
pause
