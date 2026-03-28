# Corso di Assembly x86 — Terza Informatica

## Struttura del corso

```
Assembly/
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
│   ├── approfondimento_architetture_x86  ← Dettagli storici e tecnici IA-32/x64
│   ├── approfondimento_applicazioni_bit  ← RGB, Permessi, Flags di rete
│   └── test/                            ← Materiale per la valutazione
│       ├── verifica_lezioni_01_06.md    ← Test di verifica teorico-pratico
│       └── SOLUZIONI_verifica_01_06.md  ← Griglia di correzione
│
├── pratica/                             ← Esercizi → compilati come .dll
│   ├── esercizio01_somma/               ← Somma(a, b)
│   ├── esercizio02_massimo/             ← Massimo(a, b)
│   ├── esercizio03_fattoriale/          ← Fattoriale(n)
│   ├── esercizio04_array/               ← SommaArray(int*, len)
│   ├── esercizio05_stringa/             ← LunghezzaStringa(char*)
│   ├── esercizio06_conta_carattere/     ← ContaOccorrenze(char*, char)
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
    └── Program.cs                       ← Chiama tutte le DLL Assembly
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
- Esportazione corretta delle funzioni Assembly (`_MiaFunzione`).
- Copia automatica della DLL nelle cartelle di build di .NET.
- Gestione dei puntatori e blocchi `unsafe` in C#.

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
| 6 | Calling Convention | **Array**, **Stringa** | cdecl, P/Invoke, puntatori |
| 7 | Operazioni Bitwise | **Bitwise** (es. 8) | AND, OR, XOR, NOT, Maschere |
| 8 | Applicazioni Bit | **Colori RGB** (es. 9) | Bit manipulation reale (pack/unpack) |
| **TEST** | **Test Verifica 1-6** | — | Verifica competenze acquisite |
