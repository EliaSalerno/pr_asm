@echo off
setlocal
REM ============================================================
REM Compila fattoriale.asm in fattoriale.dll
REM Da eseguire nella "x86 Native Tools Command Prompt for VS"
REM ============================================================

echo [1/3] Assemblaggio di fattoriale.asm...
ml /c /coff fattoriale.asm
if errorlevel 1 ( echo [ERRORE] Assemblaggio fallito! & pause & exit /b 1 )

echo [2/3] Linking della DLL...
REM /NOENTRY: nessuna DllMain. /EXPORT:Fattoriale senza underscore
REM (MASM con .MODEL FLAT, C aggiunge gia' il '_' al simbolo).
link /DLL /SUBSYSTEM:WINDOWS /NOENTRY /EXPORT:Fattoriale /OUT:fattoriale.dll fattoriale.obj
if errorlevel 1 ( echo [ERRORE] Linking fallito! & pause & exit /b 1 )

echo [3/3] Copia della DLL nelle cartelle usate dal runner C#...
REM P/Invoke (.NET) cerca la DLL in bin\Debug\net8.0-windows\
copy /Y fattoriale.dll ..\..\csharp_runner\fattoriale.dll >nul
if not exist ..\..\csharp_runner\bin\Debug\net8.0-windows\ mkdir ..\..\csharp_runner\bin\Debug\net8.0-windows\
copy /Y fattoriale.dll ..\..\csharp_runner\bin\Debug\net8.0-windows\fattoriale.dll >nul

echo.
echo Fatto! Avvia il runner con:  dotnet run --project ..\..\csharp_runner
pause