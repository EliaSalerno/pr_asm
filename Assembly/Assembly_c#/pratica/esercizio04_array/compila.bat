@echo off
ml /c /coff somma_array.asm
if errorlevel 1 ( echo ERRORE assemblaggio! & pause & exit /b 1 )
link /DLL /SUBSYSTEM:WINDOWS /EXPORT:_SommaArray /OUT:somma_array.dll somma_array.obj
if errorlevel 1 ( echo ERRORE linking! & pause & exit /b 1 )
copy somma_array.dll ..\..\csharp_runner\somma_array.dll
echo Fatto. DLL copiata in csharp_runner\
pause
