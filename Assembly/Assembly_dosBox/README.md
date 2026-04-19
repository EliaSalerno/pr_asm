# Laboratorio di Linguaggio Assembly — Architettura Intel 8086

> **Ambiente:** DOSBox + MASM 6.0 (Microsoft Macro Assembler)
> **Livello:** Principianti assoluti
> **Durata totale:** ~10 ore (5 sessioni da 2 ore ciascuna)

Questo laboratorio è un percorso didattico progressivo sulla programmazione in linguaggio Assembly per l'architettura Intel 8086, eseguito all'interno dell'emulatore **DOSBox**. Il corso copre l'intera catena: dall'architettura hardware alla scrittura, compilazione ed esecuzione di programmi Assembly completi con I/O, cicli e procedure.

---

## Struttura della Directory

```
Assembly_dosBox/
│
├── README.md                              <- questo file
├── print_msg.md                           <- spiegazione dettagliata della stampa stringa in Assembly 16-bit
│
├── doc_lezioni/                           <- documentazione teorica e materiale delle lezioni
│   ├── Laboratorio_Assembly_8086.docx     <- documento originale del corso
│   ├── asm_8086_esercizi.docx             <- raccolta di esercizi Assembly 8086
│   ├── Spiegazione_DOSSEG.md              <- spiegazione della direttiva DOSSEG
│   ├── interrupt_dos.md                   <- guida completa a INT 21h con esempi
│   ├── operazioni_logiche.md              <- operazioni logiche bit a bit con esercizi
│   ├── segmentazione.md                   <- attività di valutazione sulla memoria segmentata
│   └── segmento_offset.md                 <- spiegazione coppia segmento:offset
│
├── pr_materiale/                          <- materiale pronto per la distribuzione agli studenti
│   ├── DOSBox0.74-3-win32-installer.exe   <- installer DOSBox per Windows
│   └── tools/                             <- strumenti DOS pronti all'uso
│       ├── MASM.EXE                       <- Assemblatore (versione 16-bit anni '90)
│       ├── LINK.EXE                       <- Linker
│       ├── debug.exe                      <- Debugger DOS
│       └── edit.com                       <- Editor di testo DOS
│
├── pr_materiale.zip                       <- archivio compresso di pr_materiale/
│
├── ASM8086/                               <- workspace di sviluppo principale
│   │
│   ├── default/                           <- cartella con i tool di default (MASM, LINK, debug)
│   ├── default.zip                        <- archivio della cartella default
│   │
│   ├── primo/                             <- Esercizio 1: Hello World e varianti
│   │   ├── p1/                            <- versioni di Hello World
│   │   │   ├── p1.asm                     <- Hello World base (senza terminatore '$')
│   │   │   ├── p1_1.asm                   <- Hello World con 0Dh, 0Ah, '$'
│   │   │   ├── p1_2.asm                   <- Hello World con 0Dh, 0Ah (senza '$')
│   │   │   ├── p1_3.asm                   <- Hello World con errore virgola
│   │   │   └── ESEGUIBI/                  <- .EXE compilati (P1, P1_1, P1_2, P1_3)
│   │   └── p2/                            <- esperimenti con CR/LF e due stringhe
│   │       ├── cose_da_rivedere.md        <- Q&A su problemi comuni Assembly DOSBox
│   │       ├── p2_cr_lf_dopo/             <- CR+LF dopo la prima stringa
│   │       ├── p2_cr_lf_prima/            <- CR+LF prima della stringa
│   │       ├── p2_no_lf/                  <- varianti senza LF
│   │       └── p2_no_lfterm/              <- varianti senza LF e terminatore
│   │
│   ├── secondo/                           <- Esercizio 2: Hello personalizzato
│   │   ├── secondo.asm / SECONDO.EXE     <- messaggio personalizzato
│   │   └── secondo1.asm / SECONDO1.EXE   <- riscrittura compatta
│   │
│   ├── terzo/                             <- Esercizio 3: operazioni aritmetiche e I/O
│   │   ├── scambio.asm                    <- scambio di due valori (incompleto)
│   │   ├── stampa_stringa/                <- stampa "Ciao mondo!" con INT 21h/09h
│   │   │   └── stampa.asm + OBJ/EXE
│   │   ├── stampa_numero/                 <- stampa di un numero (incompleto)
│   │   │   └── stampa.asm
│   │   ├── moltiplicazione/               <- esercizi sulla MUL
│   │   │   ├── 8_bit/                     <- MUL a 8 bit (DB): 06h × 07h
│   │   │   └── 16_bit/                    <- MUL a 16 bit (DW)
│   │   │       ├── MUL/                   <- moltiplicazione semplice 06h × 07h
│   │   │       └── MUL_OVER/              <- moltiplicazione con overflow detection
│   │   └── divisione/                     <- (vuota, da implementare)
│   │
│   ├── esercitazioni/                     <- esercitazioni per gli studenti
│   │   ├── asm/                           <- file sorgente .asm (varie versioni)
│   │   │   ├── ese_1.asm ... ese_1_5.asm  <- varianti stampa "Hello world!"
│   │   │   └── ese_t1.asm, ese_t3.asm, ese_test.asm  <- versioni test
│   │   ├── obj_exe/                       <- cartelle con file compilati (.OBJ/.EXE)
│   │   └── default/                       <- tools di default (MASM, LINK, debug)
│   │
│   ├── prova/                             <- esercizio di prova: stampa su due righe
│   │   └── ese1.asm + OBJ/EXE
│   │
│   └── test/                              <- test e documentazione di setup
│       ├── asm/                           <- (vuota)
│       └── doc/
│           └── Guida_Opzione1_File_Pronti.md  <- guida rapida setup DOSBox
│
└── roba_inutile/                          <- materiale non più utilizzato
    ├── Guida_Opzione2_Setup_Floppy.md     <- guida installazione MASM dai floppy
    ├── Laboratorio_Assembly_8086.zip      <- archivio del documento
    ├── Microsoft Macro Assembler 6.0 (3.5-720k).7z  <- immagini floppy MASM 6.0
    └── doc_temp/                          <- file temporanei (contenuto docx estratto)
```

---
<br><br>

## Setup dell'Ambiente

### Prerequisito: DOSBox

Scaricare e installare DOSBox. L'installer è già disponibile nella cartella `pr_materiale/`:

- **Installer incluso:** [`pr_materiale/DOSBox0.74-3-win32-installer.exe`](./pr_materiale/DOSBox0.74-3-win32-installer.exe)
- **Sito ufficiale:** [https://www.dosbox.com/download.php?main=1](https://www.dosbox.com/download.php?main=1)

### Setup rapido — File pronti (consigliato)

I file `MASM.EXE`, `LINK.EXE`, `debug.exe` e `edit.com` nella versione originale a 16-bit degli anni '90 sono **già presenti** nella cartella `pr_materiale/tools/`.

Vedere: [`ASM8086/test/doc/Guida_Opzione1_File_Pronti.md`](./ASM8086/test/doc/Guida_Opzione1_File_Pronti.md)

Una volta aperto DOSBox, eseguire questi comandi:

```dosbox
mount c "C:\Users\elias\Desktop\progetti_git\pr_asm\Assembly\Assembly_dosBox\ASM8086"
c:
set PATH=%PATH%;c:\default
```

### Comandi DOS Essenziali in DOSBox

| Comando | Funzione |
|---------|----------|
| `DIR` | Elenca i file nella directory corrente |
| `CD nomecartella` | Entra nella cartella specificata |
| `CD ..` | Torna alla cartella superiore |
| `COPY file1 file2` | Copia un file |
| `TYPE nomefile` | Mostra il contenuto di un file di testo |
| `CLS` | Pulisce lo schermo |

---

## Documentazione Teorica (`doc_lezioni/`)

La cartella `doc_lezioni/` contiene tutto il materiale didattico organizzato per argomento:

| File | Contenuto |
|------|-----------|
| [`Laboratorio_Assembly_8086.docx`](./doc_lezioni/Laboratorio_Assembly_8086.docx) | Documento completo del laboratorio (5 sessioni) |
| [`asm_8086_esercizi.docx`](./doc_lezioni/asm_8086_esercizi.docx) | Raccolta esercizi Assembly 8086 |
| [`Spiegazione_DOSSEG.md`](./doc_lezioni/Spiegazione_DOSSEG.md) | Cos'è `DOSSEG` e perché si usa |
| [`interrupt_dos.md`](./doc_lezioni/interrupt_dos.md) | Guida completa `INT 21h`: I/O, file, directory, data/ora |
| [`operazioni_logiche.md`](./doc_lezioni/operazioni_logiche.md) | AND, OR, XOR, NOT, TEST, shift, rotate — con esercizi |
| [`segmentazione.md`](./doc_lezioni/segmentazione.md) | Attività di valutazione sulla memoria segmentata |
| [`segmento_offset.md`](./doc_lezioni/segmento_offset.md) | Spiegazione della coppia segmento:offset |

A livello root si trova anche:

| File | Contenuto |
|------|-----------|
| [`print_msg.md`](./print_msg.md) | Perché servono tutte quelle istruzioni per stampare una stringa |

---

## Parte Teorica — Riepilogo

### Sessione 1 — Architettura 8086: Registri e Memoria

#### Cenni Storici

L'Intel 8086 fu introdotto nel **1978** ed è il capostipite dell'architettura x86. È un processore a **16 bit** con bus dati a 16 bit e bus indirizzi a 20 bit, capace di indirizzare fino a **1 MB di RAM**.

#### Registri General-Purpose (GPR)

| Registro | High (8 bit) | Low (8 bit) | Utilizzo tipico |
|----------|-------------|-------------|-----------------|
| `AX` | `AH` | `AL` | Accumulatore — operazioni aritmetiche e I/O |
| `BX` | `BH` | `BL` | Base — indirizzamento indiretto |
| `CX` | `CH` | `CL` | Contatore — cicli e operazioni su stringhe |
| `DX` | `DH` | `DL` | Dati — I/O e prodotti a 32 bit con AX |

#### Registri di Segmento

| Registro | Funzione |
|----------|----------|
| `CS` | Code Segment — punta al segmento contenente il codice eseguibile |
| `DS` | Data Segment — punta al segmento dei dati |
| `SS` | Stack Segment — punta al segmento dello stack |
| `ES` | Extra Segment — usato nelle operazioni su stringhe |

#### Modello di Memoria Segmentato

L'8086 usa un modello di memoria segmentato: la memoria è divisa in **segmenti da 64 KB** ciascuno. L'indirizzo fisico a 20 bit si calcola con la formula:

```
Indirizzo Fisico = (Registro di Segmento × 16) + Offset
```

> Approfondimento: [`doc_lezioni/segmento_offset.md`](./doc_lezioni/segmento_offset.md)

---

### Sessione 2 — Struttura di un Programma Assembly per MASM

#### Template Base per un Programma `.EXE`

```asm
DOSSEG          ; Ordinamento standard dei segmenti (per MS-DOS)
.MODEL SMALL    ; Modello di memoria: codice+dati < 64KB ciascuno
.STACK 100h     ; Riserva 256 byte per lo stack

.DATA
    ; Qui si dichiarano variabili e stringhe

.CODE
MAIN PROC
    MOV AX, @DATA   ; Inizializza DS con l'indirizzo del segmento dati
    MOV DS, AX

    ; --- IL TUO CODICE VA QUI ---

    MOV AX, 4C00h   ; Funzione DOS: termina il programma
    INT 21h          ; Chiama il sistema operativo
MAIN ENDP
END MAIN             ; Fine del programma, entry point = MAIN
```

> Approfondimento su DOSSEG: [`doc_lezioni/Spiegazione_DOSSEG.md`](./doc_lezioni/Spiegazione_DOSSEG.md)

---

### Sessione 3 — Operazioni Aritmetiche e Logiche

> Approfondimento: [`doc_lezioni/operazioni_logiche.md`](./doc_lezioni/operazioni_logiche.md)

---

### Sessione 5 — Interrupt DOS e I/O

> Approfondimento completo: [`doc_lezioni/interrupt_dos.md`](./doc_lezioni/interrupt_dos.md)

---

## Parte Pratica (`ASM8086/`)

### Esercizio 1 — Hello, World! (`primo/p1/`)

**File:** [`ASM8086/primo/p1/p1.asm`](./ASM8086/primo/p1/p1.asm)

Stampa `Hello, World!` sullo schermo usando `INT 21h` funzione `09h`. Sono presenti diverse varianti (`p1_1.asm`, `p1_2.asm`, `p1_3.asm`) che esplorano il comportamento del terminatore `$` e dei caratteri CR/LF.

**Compilazione e lancio in DOSBox:**

```dosbox
cd primo\p1
masm p1.asm;
link p1.obj;
p1.exe
```

> Il `;` finale nei comandi `MASM` e `LINK` bypassa le domande interattive, accettando i valori predefiniti.

---

### Esercizio 1b — Hello con due stringhe (`primo/p2/`)

Esperimenti sulla stampa di due stringhe separate sulla stessa riga o su righe diverse, esplorando la posizione di CR+LF:

| Cartella | Comportamento |
|----------|---------------|
| `p2_cr_lf_dopo/` | CR+LF **dopo** la prima stringa → "Hello," va a capo, poi "world!" |
| `p2_cr_lf_prima/` | CR+LF **prima** della stringa |
| `p2_no_lf/` | Varianti senza LF |
| `p2_no_lfterm/` | Varianti senza LF e terminatore |

Il file [`cose_da_rivedere.md`](./ASM8086/primo/p2/cose_da_rivedere.md) contiene un Q&A dettagliato su:
- Perché un programma si blocca se non si reimpostano i registri dopo `INT 21h`
- Come funzionano AH e AL (8 bit ciascuno, non 4!)
- La corretta terminazione con `MOV AX, 4C00h`
- La posizione di CR/LF nelle stringhe

---

### Esercizio 2 — Hello personalizzato (`secondo/`)

**File:** [`ASM8086/secondo/secondo.asm`](./ASM8086/secondo/secondo.asm) e `secondo1.asm`

Variante del primo esercizio con messaggio personalizzato. La versione `secondo1.asm` è una riscrittura più compatta.

---

### Esercizio 3 — Operazioni aritmetiche e I/O (`terzo/`)

Esercizi sulle operazioni fondamentali:

#### Stampa stringa

**File:** [`ASM8086/terzo/stampa_stringa/stampa.asm`](./ASM8086/terzo/stampa_stringa/stampa.asm)

Stampa `"Ciao mondo!"` usando `INT 21h` funzione `09h`.

#### Moltiplicazione

| Cartella | Descrizione |
|----------|-------------|
| `moltiplicazione/8_bit/` | MUL a 8 bit: `06h × 07h` con `DB` → risultato in `AX` |
| `moltiplicazione/16_bit/MUL/` | MUL a 16 bit: `06h × 07h` con `DW` → risultato in `DX:AX` |
| `moltiplicazione/16_bit/MUL_OVER/` | MUL 16 bit con **overflow detection** (`JC`) e messaggio di errore |

Esempio di moltiplicazione con gestione overflow ([`mul_mem.asm`](./ASM8086/terzo/moltiplicazione/16_bit/MUL_OVER/mul_mem.asm)):

```asm
MOV ax, n1
MOV bx, n2
MUL bx              ; risultato a 32 bit in DX:AX

MOV WORD PTR [ris], ax
MOV WORD PTR [ris+2], dx

JC overflow_detected ; se CF=1, il risultato non sta in 16 bit
```

#### Scambio valori

**File:** [`ASM8086/terzo/scambio.asm`](./ASM8086/terzo/scambio.asm) — scambio di due valori DW (incompleto, solo dichiarazione dati).

#### Stampa numero

**File:** [`ASM8086/terzo/stampa_numero/stampa.asm`](./ASM8086/terzo/stampa_numero/stampa.asm) — stampa di un numero esadecimale (incompleto).

---

### Esercitazioni per gli studenti (`esercitazioni/`)

La cartella `esercitazioni/` contiene varianti dell'esercizio di stampa "Hello world!" create per la pratica in classe:

- **`asm/`**: contiene 10 file sorgente `.asm` con diverse varianti (`ese_1.asm` fino a `ese_test.asm`)
- **`obj_exe/`**: contiene le cartelle con i file compilati `.OBJ` e `.EXE` corrispondenti
- **`default/`**: copia dei tool MASM/LINK/debug per uso autonomo

---

### Prova (`prova/`)

**File:** [`ASM8086/prova/ese1.asm`](./ASM8086/prova/ese1.asm)

Stampa "Hello world!" su due righe separate usando due stringhe distinte (`str1` e `str2`). Include commenti sulle alternative `LEA` vs `OFFSET` e `MOV AX, 0900h` vs `MOV AH, 09h`.

---

## Riepilogo degli Strumenti

| Tool | Tipo | Posizione | Funzione |
|------|------|-----------|----------|
| `MASM.EXE` | Assemblatore | `pr_materiale/tools/` | Converte `.ASM` -> `.OBJ` |
| `LINK.EXE` | Linker | `pr_materiale/tools/` | Converte `.OBJ` -> `.EXE` |
| `debug.exe` | Debugger | `pr_materiale/tools/` | Ispeziona registri e memoria in esecuzione |
| `edit.com` | Editor | `pr_materiale/tools/` | Editor di testo DOS a 16 bit |
| `DOSBox` | Emulatore | `pr_materiale/` | Emula un PC DOS a 16 bit su Windows moderno |

---

## Attività di Valutazione

### Comprensione dei Segmenti di Memoria

File: [`doc_lezioni/segmentazione.md`](./doc_lezioni/segmentazione.md)

Attività con criteri di valutazione per verificare la comprensione del modello di memoria segmentato dell'8086:

- **Domanda 1 (40%)** — Teoria: definizione di segmento, registri di segmento (`CS`, `DS`, `SS`, `ES`) e meccanismo di shift a 4 bit
- **Domanda 2 (50%)** — Pratica: calcolo di indirizzi fisici a partire da coppie segmento:offset

---

## Risorse per Approfondire

- **Art of Assembly Language** — Randall Hyde (gratuito online)
- **PC Assembly Language** — Paul Carter (gratuito, versione NASM)
- **Intel 8086 Family User's Manual** — documento originale Intel (archivi online)
- **DOSBox Wiki:** [https://www.dosbox.com/wiki/](https://www.dosbox.com/wiki/)

---

*Laboratorio creato come percorso didattico introduttivo all'Assembly 8086 via DOSBox.*
