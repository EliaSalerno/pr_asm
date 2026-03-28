@echo off
ml /c /coff fattoriale.asm
if errorlevel 1 ( echo ERRORE assemblaggio! & pause & exit /b 1 )
link /DLL /SUBSYSTEM:WINDOWS /EXPORT:_Fattoriale /OUT:fattoriale.dll fattoriale.obj
if errorlevel 1 ( echo ERRORE linking! & pause & exit /b 1 )
copy fattoriale.dll ..\..\csharp_runner\fattoriale.dll
echo Fatto. DLL copiata in csharp_runner\
pause
