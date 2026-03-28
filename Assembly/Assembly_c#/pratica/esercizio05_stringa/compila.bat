@echo off
ml /c /coff lunghezza_stringa.asm
if errorlevel 1 ( echo ERRORE assemblaggio! & pause & exit /b 1 )
link /DLL /SUBSYSTEM:WINDOWS /EXPORT:_LunghezzaStringa /OUT:lunghezza_stringa.dll lunghezza_stringa.obj
if errorlevel 1 ( echo ERRORE linking! & pause & exit /b 1 )
copy lunghezza_stringa.dll ..\..\csharp_runner\lunghezza_stringa.dll
echo Fatto. DLL copiata in csharp_runner\
pause
