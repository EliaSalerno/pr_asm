@echo off
ml /c /coff media.asm
link /DLL /SUBSYSTEM:WINDOWS /EXPORT:_CalcolaMedia /OUT:media.dll media.obj
if not exist bin\x86\Debug\net8.0-windows\ mkdir bin\x86\Debug\net8.0-windows\
copy /Y media.dll bin\x86\Debug\net8.0-windows\
echo Operazione completata.
pause
