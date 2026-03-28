# Template Progetto Assembly + C#

Questo template permette di testare rapidamente funzioni scritte in Assembly x86 (32-bit) utilizzando un'applicazione C# come "runner".

## Struttura del Template
- `funzione.asm`: Il codice sorgente Assembly. Contiene un esempio di funzione `MiaFunzione`.
- `compila.bat`: Script per compilare l'Assembly in una DLL e copiarla automaticamente nella cartella di esecuzione.
- `TestRunner.csproj`: Progetto C# configurato per caricare DLL a 32-bit.
- `Program.cs`: Codice C# per chiamare la funzione Assembly e verificare il risultato.

## Come iniziare un nuovo esercizio
1. Copia l'intera cartella `template_progetto` e nominala come il tuo esercizio (es. `esercizio_potenza`).
2. Apri il file `.asm` e scrivi la tua logica.
3. Se cambi il nome della funzione in Assembly, ricordati di aggiornare:
   - Il comando `/EXPORT:_NomeFunzione` nel file `compila.bat`.
   - La riga `[DllImport(...)]` nel file `Program.cs`.
4. Apri il **"Developer Command Prompt for VS"** (o "x86 Native Tools").
5. Spostati nella cartella ed esegui `compila.bat`.
6. Avvia il runner C# (da Visual Studio o tramite `dotnet run`).

## Note Tecniche
- **Sintassi Intel**: Usiamo MASM (Microsoft Macro Assembler).
- **Convenzione Cdecl**: I parametri vengono passati sullo stack e lo stack viene pulito dal chiamante (C# lo fa automaticamente con `CallingConvention.Cdecl`).
- **Nomi Funzioni**: Per esportare una funzione `MiaFunzione` in x86, il linker si aspetta spesso un underscore davanti (`_MiaFunzione`).
