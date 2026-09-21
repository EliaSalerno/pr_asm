# Corso di Assembly x86 — Terza Informatica

## Struttura del corso

```
Assembly_c#/
├── README.md                            ← Questo file
│
├── teoria/                              ← Lezioni teoriche (Markdown)
│   ├── lezione01_architettura.md        ← Von Neumann, ciclo fetch-decode-execute, basi
│   ├── lezione02_registri.md            ← EAX..EDI, EIP, EFLAGS, sottoregistri
│   ├── lezione03_memoria.md             ← RAM, little-endian, indirizzamento
│   ├── lezione04_istruzioni.md          ← MOV, ADD, CMP, JMP, CALL, RET...
│   ├── lezione05_stack_chiamate.md      ← Stack, frame, prologo/epilogo
│   ├── lezione05b_pratica_stack.md      ← Analisi dello Stack Frame nel debugger
│   ├── lezione06_calling_convention.md  ← cdecl, P/Invoke, interfaccia con C#
│   ├── lezione07_operazioni_bitwise.md  ← AND, OR, XOR, NOT, Shift/Rotate
│   ├── approfondimento_architetture_x86.md  ← Dettagli storici e tecnici IA-32/x64
│   ├── approfondimento_applicazioni_bit.md  ← RGB, Permessi, Flags di rete
│   └── test/                            ← Materiale per la valutazione
│       ├── test01..test06, verifica_1   ← Test per ogni lezione + chiavi (docente)
│       ├── verifica_lezioni_01_06.md    ← Test di verifica teorico-pratico
│       └── SOLUZIONI_verifica_01_06.md  ← Griglia di correzione
│
├── pratica/                             ← Esercizi → compilati come .dll
│   ├── esercizio01_somma/               ← Somma(a, b)
│   ├── esercizio02_massimo/             ← Massimo(a, b)
│   ├── esercizio03_fattoriale/          ← Fattoriale(n)
│   ├── esercizio04_array/               ← SommaArray(int*, len)
│   ├── esercizio05_stringa/             ← LunghezzaStringa(char*)
│   ├── esercizio06_conta_carattere/     ← ContaCarattere(char*, char)
│   ├── esercizio07_stack_frame/         ← Analisi Variabili Locali (Media)
│   ├── esercizio08_bitwise/             ← Inversione e Isolamento Bit
│   └── esercizio09_colori_rgb/          ← Manipolazione pack/unpack RGB
│
├── template_progetto/                   ← Template pronto per nuovi esercizi
│   ├── funzione.asm, Program.cs, ...    ← Struttura base pre-configurata
│   └── README.md                        ← Istruzioni per l'uso del template
│
└── csharp_runner/                       ← Programma C# principale (VS Code)
    ├── AssemblyRunner.csproj            ← Progetto .NET 8, piattaforma x86
    └── Program.cs                       ← Chiama le DLL Assembly (es. 1-5)
```

---

## Requisiti

| Strumento | Versione | Link di Download |
|-----------|---------|------------------|
| **Visual Studio Build Tools** | 2019 o 2022 | [Scarica qui](https://visualstudio.microsoft.com/visual-cpp-build-tools/) |
| **VS Code** | qualsiasi | [Scarica qui](https://code.visualstudio.com/) |
| **.NET SDK** | 8 o superiore | [Scarica qui](https://dotnet.microsoft.com/download/dotnet/8.0) |
| **MASM (ml.exe)** | incluso in VS | Fornito con i Build Tools sopra |

> Per verificare l'installazione apri un terminale e digita: `dotnet --version`

---

## Flusso di lavoro (lezione per lezione)

```
  [1] Leggere la teoria       → teoria/lezioneXX_*.md
        ↓
  [2] Usare il template       → Copia cartella 'template_progetto'
        ↓
  [3] Scrivere il codice      → .asm (per la logica) e .cs (per il test)
        ↓
  [4] Compilare la DLL        → doppio clic su compila.bat
        (dalla x86 Native Tools Command Prompt for VS)
        ↓
  [5] Avviare il runner       → dotnet run
        ↓
  [6] Debugging               → Visual Studio "Registers" e "Memory" windows
```

---

## Novità: Template di Progetto
Per facilitare la creazione di nuovi esercizi, è disponibile la cartella `template_progetto`. Contiene una configurazione già testata per:
- Esportazione corretta delle funzioni Assembly: nel `/EXPORT` si usa il nome **senza underscore** (`/EXPORT:MiaFunzione`). MASM con `.MODEL FLAT, C` aggiunge già il prefisso `_` al simbolo nell'oggetto; usarlo anche nel `/EXPORT` causerebbe un errore LNK2001 (DLL da 0 byte).
- Copia automatica della DLL nella cartella di build di .NET (`bin\Debug\net8.0-windows\`), dove P/Invoke la cerca davvero.
- Gestione dei puntatori e blocchi `unsafe` in C#.

> Le DLL si linkano con `/DLL /NOENTRY`: non serve una `DllMain` né la libreria CRT.

---

## Punti chiave della pipeline (da non dimenticare)

1. **Progetto C# a 32 bit**: `.csproj` con `<PlatformTarget>x86</PlatformTarget>`, altrimenti la DLL Assembly (32 bit) non si carica (`BadImageFormatException`).
2. **Link senza underscore**: `link /DLL /SUBSYSTEM:WINDOWS /NOENTRY /EXPORT:NomeFunzione ...`.
3. **Dove va la DLL**: il P/Invoke cerca la DLL nella cartella dell'eseguibile (es. `bin\Debug\net8.0-windows\`), non nella root del progetto. Gli script `compila.bat` già gestiscono la copia.

---

## Tabella lezioni e esercizi

| # | Teoria | Esercizio pratico | Concetti chiave |
|---|--------|------------------|-----------------|
| 1 | Architettura, von Neumann | — | CPU, RAM, fetch-decode-execute |
| 2 | Registri x86 | — | EAX..EDI, flag, EIP |
| 3 | Memoria, indirizzamento | — | little-endian, [ptr], DWORD/BYTE |
| 4 | Set di istruzioni | **Somma** (es. 1) | MOV, ADD, prologo semplice |
| 5 | Stack e chiamate | **Massimo**, **Fattoriale** | CMP, JGE, cicli, ricorsione |
| 5b| Analisi Stack Frame | **Stack Frame** (es. 7) | Variabili locali, EBP-4, offset |
| 6 | Calling Convention | **Array**, **Stringa**, **Conta Carattere** (es. 4-6) | cdecl, P/Invoke, puntatori |
| 7 | Operazioni Bitwise | **Bitwise** (es. 8) | AND, OR, XOR, NOT, Maschere |
| 8 | Applicazioni Bit | **Colori RGB** (es. 9) | Bit manipulation reale (pack/unpack) |
| **TEST** | **Test Verifica 1-6** | — | Verifica competenze acquisite |
