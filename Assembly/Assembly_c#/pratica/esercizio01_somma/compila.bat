@echo off
setlocal
REM ============================================================
REM Compila somma.asm in somma.dll
REM Da eseguire nella "x86 Native Tools Command Prompt for VS"
REM ============================================================

echo [1/3] Assemblaggio di somma.asm...
ml /c /coff somma.asm
if errorlevel 1 (
    echo [ERRORE] Assemblaggio fallito!
    pause & exit /b 1
)

echo [2/3] Linking della DLL...
REM IMPORTANTE:
REM  - /NOENTRY : la DLL non necessita di DllMain (nessun punto di ingresso).
REM  - /EXPORT:Somma (SENZA underscore!): con .MODEL FLAT, C, MASM decora
REM    gia' da solo il simbolo come _Somma; il linker x86 aggiunge un altro '_'
REM    ai nomi /EXPORT, quindi /EXPORT:_Somma cercherebbe __Somma (LNK2001).
link /DLL /SUBSYSTEM:WINDOWS /NOENTRY /EXPORT:Somma /OUT:somma.dll somma.obj
if errorlevel 1 (
    echo [ERRORE] Linking fallito!
    pause & exit /b 1
)

echo [3/3] Copia della DLL nelle cartelle usate dal runner C#...
REM P/Invoke (.NET) cerca la DLL nella cartella dell'eseguibile,
REM NON nella root del progetto: qui bin\Debug\net8.0-windows\
copy /Y somma.dll ..\..\csharp_runner\somma.dll >nul
if not exist ..\..\csharp_runner\bin\Debug\net8.0-windows\ mkdir ..\..\csharp_runner\bin\Debug\net8.0-windows\
copy /Y somma.dll ..\..\csharp_runner\bin\Debug\net8.0-windows\somma.dll >nul

echo.
echo Fatto! Avvia il runner con:  dotnet run --project ..\..\csharp_runner
pause