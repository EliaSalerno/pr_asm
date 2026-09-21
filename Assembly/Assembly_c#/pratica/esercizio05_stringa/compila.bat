@echo off
setlocal
REM ============================================================
REM Compila lunghezza_stringa.asm in lunghezza_stringa.dll
REM Da eseguire nella "x86 Native Tools Command Prompt for VS"
REM ============================================================

echo [1/3] Assemblaggio di lunghezza_stringa.asm...
ml /c /coff lunghezza_stringa.asm
if errorlevel 1 ( echo [ERRORE] Assemblaggio fallito! & pause & exit /b 1 )

echo [2/3] Linking della DLL...
REM /NOENTRY: nessuna DllMain. /EXPORT:LunghezzaStringa senza underscore
REM (MASM con .MODEL FLAT, C aggiunge gia' il '_' al simbolo).
link /DLL /SUBSYSTEM:WINDOWS /NOENTRY /EXPORT:LunghezzaStringa /OUT:lunghezza_stringa.dll lunghezza_stringa.obj
if errorlevel 1 ( echo [ERRORE] Linking fallito! & pause & exit /b 1 )

echo [3/3] Copia della DLL nelle cartelle usate dal runner C#...
REM P/Invoke (.NET) cerca la DLL in bin\Debug\net8.0-windows\
copy /Y lunghezza_stringa.dll ..\..\csharp_runner\lunghezza_stringa.dll >nul
if not exist ..\..\csharp_runner\bin\Debug\net8.0-windows\ mkdir ..\..\csharp_runner\bin\Debug\net8.0-windows\
copy /Y lunghezza_stringa.dll ..\..\csharp_runner\bin\Debug\net8.0-windows\lunghezza_stringa.dll >nul

echo.
echo Fatto! Avvia il runner con:  dotnet run --project ..\..\csharp_runner
pause