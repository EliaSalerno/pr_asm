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
├── README.md                          <- questo file
├── Laboratorio_Assembly_8086.docx     <- documento originale del corso
├── Laboratorio_Assembly_8086.zip      <- archivio del documento
├── segmentazione.md                   <- attività di valutazione sulla memoria segmentata
│
├── Microsoft Macro Assembler 6.0 (3.5-720k)/
│   └── Microsoft Macro Assembler 6.0 (3.5-720k)/
│       └── (immagini .IMG dei 7 floppy disk originali MASM 6.0)
│
└── ASM8086/
    ├── Guida_Opzione1_File_Pronti.md  <- guida rapida con tool pre-estratti (consigliata)
    ├── Guida_Opzione2_Setup_Floppy.md <- guida installazione MASM dai floppy
    ├── Spiegazione_DOSSEG.md          <- spiegazione della direttiva DOSSEG
    │
    ├── tools/                         <- strumenti DOS pronti all'uso
    │   ├── MASM.EXE                   <- Assemblatore (versione 16-bit anni '90)
    │   ├── LINK.EXE                   <- Linker
    │   ├── DEBUG.EXE                  <- Debugger DOS
    │   └── edit.com                   <- Editor di testo DOS
    │
    ├── primo/                         <- Esercizio 1: Hello World
    │   ├── primo.asm                  <- sorgente Assembly
    │   ├── PRIMO.OBJ                  <- file oggetto (generato da MASM)
    │   └── PRIMO.EXE                  <- eseguibile finale (generato da LINK)
    │
    └── secondo/                       <- Esercizio 2: Hello personalizzato
        ├── secondo.asm
        ├── secondo1.asm
        ├── SECONDO.OBJ / SECONDO.EXE
        └── SECONDO1.OBJ / SECONDO1.EXE
```

---
<br><br><br><br><br><br>
## Setup dell'Ambiente

### Prerequisito: DOSBox

Scaricare e installare DOSBox dal sito ufficiale:
[https://www.dosbox.com/download.php?main=1](https://www.dosbox.com/download.php?main=1)

### Opzione 1 — File pronti (consigliata)

I file `MASM.EXE`, `LINK.EXE` e `DEBUG.EXE` nella versione originale a 16-bit degli anni '90 sono **già presenti** nella cartella `ASM8086/tools/`. Non è necessaria alcuna installazione aggiuntiva.

Vedere: [`ASM8086/Guida_Opzione1_File_Pronti.md`](./ASM8086/Guida_Opzione1_File_Pronti.md)

Una volta aperto DOSBox, eseguire questi comandi:

```dosbox
mount c "C:\Users\elias\Desktop\Assembly\ASM8086"
c:
set PATH=%PATH%;c:\tools
```

### Opzione 2 — Installazione dai Floppy Disk originali

Ricostruisce l'esperienza originale degli anni '90 usando le 7 immagini `.IMG` di MASM 6.0.

Vedere: [`ASM8086/Guida_Opzione2_Setup_Floppy.md`](./ASM8086/Guida_Opzione2_Setup_Floppy.md)

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

## Parte Teorica

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

#### Registri di Puntatore e Indice

| Registro | Funzione |
|----------|----------|
| `SP` | Stack Pointer — punta alla cima dello stack |
| `BP` | Base Pointer — indirizzamento dello stack frame |
| `SI` | Source Index — indice sorgente nelle operazioni su stringhe |
| `DI` | Destination Index — indice destinazione nelle operazioni su stringhe |
| `IP` | Instruction Pointer — punta alla prossima istruzione da eseguire |

#### Registro FLAGS

| Bit | Flag | Significato |
|-----|------|-------------|
| 0 | `CF` — Carry | Riporto nell'ultima operazione aritmetica |
| 6 | `ZF` — Zero | Il risultato dell'ultima operazione è zero |
| 7 | `SF` — Sign | Il risultato è negativo (bit più significativo = 1) |
| 11 | `OF` — Overflow | Overflow in operazioni con segno |

#### Modello di Memoria Segmentato

L'8086 usa un modello di memoria segmentato: la memoria è divisa in **segmenti da 64 KB** ciascuno. L'indirizzo fisico a 20 bit si calcola con la formula:

```
Indirizzo Fisico = (Registro di Segmento x 16) + Offset
```

> **Perché moltiplicare per 16?**
> Il registro di segmento viene shiftato a sinistra di 4 bit (= x16 = x10h in esadecimale).
> Questo permette a un registro a 16 bit di contribuire agli indirizzi a 20 bit.

**Esempio:**
- `DS = 1000h`, `BX = 0200h`
- Indirizzo fisico = `1000h x 10h + 0200h` = `10000h + 0200h` = `10200h`

---

### Sessione 2 — Struttura di un Programma Assembly per MASM

#### Formati Eseguibili in DOS

- **`.COM`** — semplice, tutto in 64 KB
- **`.EXE`** — strutturato, con segmenti separati *(usato in questo laboratorio)*

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

#### La Direttiva `DOSSEG`

La direttiva `DOSSEG` impone al linker un **ordinamento standard** dei segmenti nel file `.EXE`, che MS-DOS si aspetta al momento del caricamento in RAM:

1. **Segmenti di Codice** (classe `CODE`) — posizionati per primi
2. **Segmenti Extra / Altri segmenti** — non appartenenti a `DGROUP`
3. **`DGROUP`** — blocco dati, composto nell'ordine da:
   - `.DATA` — variabili inizializzate
   - `.BSS` — variabili non inizializzate
   - `.STACK` — obbligatoriamente alla fine del gruppo dati

> Garantisce compatibilità e previene bug di memoria, specialmente quando si linka Assembly con codice C.

Approfondimento: [`ASM8086/Spiegazione_DOSSEG.md`](./ASM8086/Spiegazione_DOSSEG.md)

---

### Sessione 3 — Operazioni Aritmetiche, Logiche e Flag

#### Aritmetica

| Istruzione | Descrizione | Esempio |
|------------|-------------|---------|
| `MOV dst, src` | Copia un valore | `MOV AX, 5` |
| `ADD dst, src` | Somma | `ADD AX, BX` |
| `SUB dst, src` | Sottrazione | `SUB AX, 3` |
| `MUL src` | Moltiplicazione senza segno (risultato in `AX` o `DX:AX`) | `MUL CX` |
| `DIV src` | Divisione senza segno | `DIV CX` |
| `INC dst` | Incrementa di 1 | `INC AX` |
| `DEC dst` | Decrementa di 1 | `DEC CX` |

#### Operazioni Logiche e Bit

| Istruzione | Descrizione |
|------------|-------------|
| `AND dst, src` | AND bit a bit — azzera i bit specificati |
| `OR dst, src` | OR bit a bit — mette a 1 i bit specificati |
| `XOR dst, src` | XOR bit a bit — inverte i bit / azzera il registro (`XOR AX, AX`) |
| `NOT dst` | Inverte tutti i bit |
| `TEST dst, src` | Come AND ma senza modificare i registri (imposta solo i flag) |

#### `CMP` e il Registro FLAGS

`CMP` esegue una sottrazione e scarta il risultato, conservando solo i flag. E' il modo standard per confrontare due valori prima di un salto condizionale.

```asm
CMP AX, BX
; Se AX == BX -> ZF = 1
; Se AX >  BX -> ZF = 0, CF = 0 (senza segno)
; Se AX <  BX -> CF = 1 (senza segno)
```

---

### Sessione 4 — Controllo del Flusso: Salti, Cicli e Procedure

#### Salto Incondizionale `JMP`

```asm
JMP fine        ; salta sempre all'etichetta 'fine'
fine:
MOV AX, 4C00h
INT 21h
```

#### Salti Condizionali

I salti condizionali si usano **dopo `CMP` o `TEST`** e saltano solo se la condizione è vera.

| Istruzione | Condizione | Salta se... |
|------------|-----------|-------------|
| `JE` / `JZ` | `ZF = 1` | Uguale / risultato zero |
| `JNE` / `JNZ` | `ZF = 0` | Diverso / risultato non zero |
| `JL` / `JNGE` | `SF != OF` | Minore (con segno) |
| `JG` / `JNLE` | `ZF=0, SF=OF` | Maggiore (con segno) |
| `JB` / `JC` | `CF = 1` | Minore (senza segno) |
| `JA` | `CF=0, ZF=0` | Maggiore (senza segno) |

#### Cicli con `LOOP`

`LOOP` decrementa `CX` di 1 e salta all'etichetta se `CX != 0`. E' il modo classico per implementare un ciclo `for`.

```asm
XOR AX, AX      ; AX = 0
MOV CX, 5       ; CX = 5 (contatore)
ciclo:
    INC AX      ; AX = AX + 1
    LOOP ciclo  ; CX--; se CX != 0 salta a 'ciclo'
; qui AX = 5, CX = 0
```

#### Procedure con `CALL` e `RET`

`CALL` salva l'indirizzo di ritorno sullo stack e salta alla procedura. `RET` recupera l'indirizzo dallo stack e torna al chiamante.

```asm
CALL raddoppia      ; chiama la procedura
; al ritorno, AX contiene il valore raddoppiato

raddoppia PROC
    ADD AX, AX      ; AX = AX + AX
    RET             ; torna al chiamante
raddoppia ENDP
```

---

### Sessione 5 — Interrupt DOS e I/O

#### Cos'è un Interrupt?

Un interrupt (`INT n`) è un meccanismo che permette al programma di richiedere servizi al sistema operativo o al BIOS.

| Vettore | Destinazione |
|---------|-------------|
| `INT 21h` | Servizi DOS (I/O, file, memoria) |
| `INT 10h` | Servizi video BIOS |
| `INT 16h` | Servizi tastiera BIOS |

Prima di chiamare `INT 21h` bisogna sempre impostare `AH` con il numero della funzione desiderata.

#### Principali Funzioni `INT 21h`

| `AH` | Funzione | Descrizione |
|------|----------|-------------|
| `01h` | Leggi carattere | Legge un carattere da tastiera con echo; restituisce il codice ASCII in `AL` |
| `02h` | Stampa carattere | Stampa il carattere il cui codice ASCII è in `DL` |
| `09h` | Stampa stringa | Stampa la stringa puntata da `DS:DX`, terminata da `'$'` |
| `0Ah` | Leggi stringa | Legge una linea da tastiera nel buffer puntato da `DS:DX` |
| `4Ch` | Termina programma | Esce dal programma; `AL` contiene il codice di uscita |

---

## Parte Pratica

### Esercizio 1 — Hello, World! (`primo/`)

**File:** [`ASM8086/primo/primo.asm`](./ASM8086/primo/primo.asm)

Stampa `Hello, World!` sullo schermo usando `INT 21h` funzione `09h`.

```asm
DOSSEG
.MODEL SMALL
.STACK 100h

.DATA
    msg DB 'Hello, World!', 13, 10, '$'

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    MOV DX, OFFSET msg    ; DX punta all'inizio della stringa
    MOV AH, 09h           ; Funzione 09h = stampa stringa terminata da '$'
    INT 21h               ; Chiama DOS
    MOV AX, 4C00h
    INT 21h
MAIN ENDP
END MAIN
```

**Compilazione e lancio in DOSBox:**

```dosbox
cd primo
masm primo.asm;
link primo.obj;
primo.exe
```

> Il `;` finale nei comandi `MASM` e `LINK` bypassa le domande interattive, accettando i valori predefiniti.

---

### Esercizio 2 — Hello personalizzato (`secondo/`)

**File:** [`ASM8086/secondo/secondo.asm`](./ASM8086/secondo/secondo.asm) e `secondo1.asm`

Variante del primo esercizio con messaggio personalizzato (`Hello, Elia!`). La versione `secondo1.asm` è una riscrittura più compatta dello stesso programma, utile per confrontare stili di codifica equivalenti.

**Compilazione:**

```dosbox
cd secondo
masm secondo.asm;
link secondo.obj;
secondo.exe
```

---

### Esercizi delle Sessioni (dal documento `Laboratorio_Assembly_8086.docx`)

#### Sessione 1 — Calcolo Indirizzi Fisici

**Esercizio 1A** *(carta e penna)*: Calcola l'indirizzo fisico per le seguenti coppie `segmento:offset`:

| Coppia | Risultato |
|--------|-----------|
| `DS = 2000h`, `SI = 0050h` | `20050h` |
| `CS = 1500h`, `IP = 0300h` | `15300h` |
| `SS = 3000h`, `SP = 0FFEh` | `30FFEh` |

**Esercizio 1B** *(riflessione)*: Quanti indirizzi fisici distinti possono essere generati con un bus indirizzi da 20 bit? → `2^20 = 1.048.576` indirizzi → **1 MB di RAM massima**.

---

#### Sessione 2 — Uso di DEBUG

Il debugger DOS permette di ispezionare i registri e la memoria dopo l'esecuzione.

```dosbox
debug primo.exe
```

Comandi DEBUG utili:

| Comando | Funzione |
|---------|----------|
| `R` | Mostra tutti i registri |
| `R AX` | Mostra e modifica `AX` |
| `D DS:0100` | Dump della memoria a partire da `DS:0100` |
| `T` | Esegue un'istruzione (step) |
| `G` | Esegue il programma |
| `Q` | Esce da DEBUG |

---

#### Sessione 3 — Operazioni Aritmetiche e Logiche

**Esercizio 3A — Calcolatrice**: Scrivi un programma che calcoli `(5 + 3) - 4 x 2` usando `ADD`, `MUL` e `SUB`. Salva il risultato in `BX` e termina. Verifica il valore con DEBUG.

**Esercizio 3B — Bitmask**: Dato `AX = 1010 1100 0011 0101b`, usa `AND`, `OR` e `XOR` per:
- (a) isolare i 4 bit bassi
- (b) impostare a 1 i bit 8-11
- (c) invertire i bit 0-7

**Esercizio 3C — Pari o Dispari**: Carica il numero `7` in `AL` e usa `TEST` per determinare se è pari o dispari (il risultato rimane in un registro, non è necessario stamparlo).

---

#### Sessione 4 — Controllo del Flusso

**Esercizio 4A — Ciclo con LOOP**: Scrivi un programma che calcoli la somma dei numeri da 1 a 10 con il ciclo `LOOP`. Salva il risultato in `AX` (deve essere `55`).

**Esercizio 4B — Valore assoluto**: Scrivi una procedura `valore_assoluto` che riceve un valore in `AX` (può essere negativo in complemento a 2) e restituisce il suo valore assoluto in `AX`.

**Esercizio 4C — Massimo tra due numeri**: Scrivi una procedura che riceve due valori in `AX` e `BX` e restituisce il valore maggiore in `AX`.

---

#### Sessione 5 — Progetto Finale: Mini Calcolatrice

Realizza un programma Assembly 8086 che:
1. Chiede all'utente di inserire due cifre singole (`0`-`9`) da tastiera
2. Chiede quale operazione eseguire (`+`, `-`, `x`)
3. Calcola il risultato
4. Stampa il risultato sullo schermo

Struttura il codice in procedure separate: `leggi_cifra`, `stampa_risultato`, `somma`, `sottrai`, `moltiplica`.

**Suggerimenti implementativi:**
- I caratteri `'0'`-`'9'` hanno codici ASCII `48`-`57`. Per ottenere il valore numerico: `SUB AL, 30h`
- Per stampare un numero a cifra singola: `ADD AL, 30h`, poi usa `INT 21h` funzione `02h`
- Usa `CMP` e salti condizionali per selezionare l'operazione

**Criteri di Valutazione:**

| Criterio | Punti |
|----------|-------|
| Il programma compila senza errori | 20 |
| Lettura corretta dell'input da tastiera | 20 |
| Calcolo corretto per almeno una operazione | 20 |
| Stampa corretta del risultato | 20 |
| Uso di procedure ben strutturate | 20 |

---

### Attività di Valutazione — Comprensione dei Segmenti di Memoria

File: [`segmentazione.md`](./segmentazione.md)

Attività con criteri di valutazione per verificare la comprensione del modello di memoria segmentato dell'8086:

- **Domanda 1 (40%)** — Teoria: definizione di segmento, registri di segmento (`CS`, `DS`, `SS`, `ES`) e meccanismo di shift a 4 bit
- **Domanda 2 (50%)** — Pratica: calcolo di indirizzi fisici a partire da coppie segmento:offset

---

## Riepilogo degli Strumenti

| Tool | Tipo | Funzione |
|------|------|----------|
| `MASM.EXE` | Assemblatore | Converte `.ASM` -> `.OBJ` |
| `LINK.EXE` | Linker | Converte `.OBJ` -> `.EXE` |
| `DEBUG.EXE` | Debugger | Ispeziona registri e memoria in esecuzione |
| `EDIT.COM` | Editor | Editor di testo DOS a 16 bit |
| `DOSBox` | Emulatore | Emula un PC DOS a 16 bit su Windows moderno |

---

## Risorse per Approfondire

- **Art of Assembly Language** — Randall Hyde (gratuito online)
- **PC Assembly Language** — Paul Carter (gratuito, versione NASM)
- **Intel 8086 Family User's Manual** — documento originale Intel (archivi online)

---

- **DOSBox Wiki:** [https://www.dosbox.com/wiki/](https://www.dosbox.com/wiki/)
*Laboratorio creato come percorso didattico introduttivo all'Assembly 8086 via DOSBox.*
