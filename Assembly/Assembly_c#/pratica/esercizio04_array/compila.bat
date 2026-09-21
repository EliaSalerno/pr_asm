@echo off
setlocal
REM ============================================================
REM Compila somma_array.asm in somma_array.dll
REM Da eseguire nella "x86 Native Tools Command Prompt for VS"
REM ============================================================

echo [1/3] Assemblaggio di somma_array.asm...
ml /c /coff somma_array.asm
if errorlevel 1 ( echo [ERRORE] Assemblaggio fallito! & pause & exit /b 1 )

echo [2/3] Linking della DLL...
REM /NOENTRY: nessuna DllMain. /EXPORT:SommaArray senza underscore
REM (MASM con .MODEL FLAT, C aggiunge gia' il '_' al simbolo).
link /DLL /SUBSYSTEM:WINDOWS /NOENTRY /EXPORT:SommaArray /OUT:somma_array.dll somma_array.obj
if errorlevel 1 ( echo [ERRORE] Linking fallito! & pause & exit /b 1 )

echo [3/3] Copia della DLL nelle cartelle usate dal runner C#...
REM P/Invoke (.NET) cerca la DLL in bin\Debug\net8.0-windows\
copy /Y somma_array.dll ..\..\csharp_runner\somma_array.dll >nul
if not exist ..\..\csharp_runner\bin\Debug\net8.0-windows\ mkdir ..\..\csharp_runner\bin\Debug\net8.0-windows\
copy /Y somma_array.dll ..\..\csharp_runner\bin\Debug\net8.0-windows\somma_array.dll >nul

echo.
echo Fatto! Avvia il runner con:  dotnet run --project ..\..\csharp_runner
pause