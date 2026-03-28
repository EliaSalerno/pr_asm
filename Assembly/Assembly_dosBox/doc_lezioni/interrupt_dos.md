# Assembly x86 — Domande e Risposte

---

## 1. `mov ax, @data`

**D:** Cosa significa `mov ax, @data`?

**R:** Questa istruzione carica l'indirizzo del segmento dati (`@data`) nel registro `AX`.

`@data` è un simbolo predefinito dell'assembler che risolve all'indirizzo del segmento `.DATA` definito nel programma.

---

## 2. `mov ax, @data` + `mov ds, ax` — Perché si svolgono queste due istruzioni?

**D:** `mov ax, @data` → `mov ds, ax` — perché si svolgono queste due istruzioni?

**R:** Le due istruzioni insieme servono a **inizializzare il registro di segmento DS**.

Il registro `DS` (Data Segment) indica alla CPU dove si trovano in memoria i dati. Senza inizializzarlo correttamente, qualsiasi accesso a variabili in `.DATA` darebbe risultati sbagliati o un crash.

### Perché non si fa direttamente `mov ds, @data`?

L'architettura x86 **non permette di caricare un valore immediato direttamente in un registro di segmento**:

```asm
mov ds, @data   ; ERRORE - non si può fare!
```

Bisogna usare un registro generale come "trampolino":

```asm
mov ax, @data   ; prima carica l'indirizzo in AX
mov ds, ax      ; poi copia AX in DS
```

| Istruzione | Cosa fa |
|---|---|
| `mov ax, @data` | Mette l'indirizzo del segmento dati in `AX` |
| `mov ds, ax` | Copia quell'indirizzo in `DS`, così la CPU sa dove trovare i dati |

---

## 3. `mov ah, 09h` / `lea dx, msg1` / `int 21h`

**D:** Cosa fanno queste tre istruzioni?

**R:** Queste tre istruzioni insieme servono a **stampare una stringa a schermo** usando i servizi del DOS.

| Istruzione | Cosa fa |
|---|---|
| `mov ah, 09h` | Carica `09h` in `AH` — seleziona la funzione 9 dell'interrupt 21h (stampa stringa) |
| `lea dx, msg1` | Carica in `DX` l'indirizzo effettivo della variabile `msg1` |
| `int 21h` | Chiama l'interrupt del DOS, che esegue la funzione indicata in `AH` |

### Come funziona `int 21h`?

`int 21h` è la porta d'accesso ai servizi del DOS. La funzione eseguita dipende dal valore in `AH`:
- `AH = 09h` → stampa la stringa il cui indirizzo è in `DX`
- La stringa **deve terminare con `$`**, altrimenti il DOS continua a stampare oltre

### Esempio:

```asm
.DATA
    msg1 db "Ciao, mondo!", 13, 10, '$'
         ;                  ^    ^   ^
         ;               CR   LF  terminatore

.CODE
    mov ah, 09h
    lea dx, msg1
    int 21h
```

### Perché `LEA` e non `MOV`?

| | Significato |
|---|---|
| `mov dx, msg1` | copierebbe il **contenuto** (i byte della stringa) |
| `lea dx, msg1` | carica l'**indirizzo** di `msg1` — quello che serve a `int 21h` |

---

## 4. Tutti i valori di `AH` per `int 21h` con esempi

**D:** Quali altri valori possono essere messi in `AH` da eseguire con `int 21h`? Fai esempi semplici per ciascuno.

---

### Input / Output da tastiera e schermo

#### `01h` — Leggi carattere da tastiera (con echo)
```asm
mov ah, 01h
int 21h         ; attende un tasto
                ; il carattere premuto è ora in AL
```

#### `02h` — Stampa un carattere
```asm
mov ah, 02h
mov dl, 'A'     ; carattere da stampare in DL
int 21h         ; stampa 'A' a schermo
```

#### `07h` — Leggi carattere senza echo
```asm
mov ah, 07h
int 21h         ; attende un tasto, non lo mostra a schermo
                ; carattere in AL
```

#### `08h` — Leggi carattere senza echo (con Ctrl+Break)
```asm
mov ah, 08h
int 21h         ; come 07h ma risponde a Ctrl+Break
                ; carattere in AL
```

#### `09h` — Stampa stringa
```asm
.DATA
    msg db "Ciao!", 13, 10, '$'
.CODE
    mov ah, 09h
    lea dx, msg
    int 21h         ; stampa "Ciao!" e va a capo
```

#### `0Ah` — Leggi stringa da tastiera
```asm
.DATA
    buffer db 20        ; max 20 caratteri
            db 0        ; caratteri effettivamente letti
            db 20 dup(0); spazio per la stringa
.CODE
    mov ah, 0Ah
    lea dx, buffer
    int 21h             ; legge una stringa da tastiera
```

---

### Gestione File

#### `3Ch` — Crea un file
```asm
.DATA
    nomefile db "test.txt", 0
.CODE
    mov ah, 3Ch
    mov cx, 0           ; attributo normale
    lea dx, nomefile
    int 21h             ; crea "test.txt", handle in AX
```

#### `3Dh` — Apri un file
```asm
.DATA
    nomefile db "test.txt", 0
.CODE
    mov ah, 3Dh
    mov al, 0           ; 0=lettura, 1=scrittura, 2=entrambi
    lea dx, nomefile
    int 21h             ; apre il file, handle in AX
```

#### `3Eh` — Chiudi un file
```asm
    mov ah, 3Eh
    mov bx, ax          ; handle del file aperto in precedenza
    int 21h             ; chiude il file
```
```asm

#### `3Fh` — Leggi da file
.DATA
    buffer db 100 dup(0)
.CODE
    mov ah, 3Fh
    mov bx, ax          ; handle del file
    mov cx, 100         ; numero di byte da leggere
    lea dx, buffer
    int 21h             ; legge 100 byte nel buffer
```

#### `40h` — Scrivi su file
```asm
.DATA
    testo db "Riga di testo"
.CODE
    mov ah, 40h
    mov bx, ax          ; handle del file
    mov cx, 13          ; numero di byte da scrivere
    lea dx, testo
    int 21h             ; scrive nel file
```

#### `41h` — Elimina un file
```asm
.DATA
    nomefile db "test.txt", 0
.CODE
    mov ah, 41h
    lea dx, nomefile
    int 21h             ; elimina "test.txt"
```

---

### Gestione Directory

#### `39h` — Crea directory
```asm
.DATA
    cartella db "nuovacartella", 0
.CODE
    mov ah, 39h
    lea dx, cartella
    int 21h             ; crea la cartella
```

#### `3Ah` — Elimina directory
```asm
.DATA
    cartella db "nuovacartella", 0
.CODE
    mov ah, 3Ah
    lea dx, cartella
    int 21h             ; elimina la cartella (deve essere vuota)
```

#### `3Bh` — Cambia directory
```asm
.DATA
    percorso db "C:\DOS", 0
.CODE
    mov ah, 3Bh
    lea dx, percorso
    int 21h             ; si sposta in C:\DOS
```

#### `47h` — Ottieni directory corrente
```asm
.DATA
    buffer db 64 dup(0)
.CODE
    mov ah, 47h
    mov dl, 0           ; 0 = drive corrente
    lea si, buffer
    int 21h             ; buffer contiene il percorso corrente
```

---

### Data e Ora

#### `2Ah` — Leggi data
```asm
mov ah, 2Ah
int 21h
; dopo l'interrupt:
; CX = anno (es. 2024)
; DH = mese (1-12)
; DL = giorno (1-31)
```

#### `2Bh` — Imposta data
```asm
mov ah, 2Bh
mov cx, 2024    ; anno
mov dh, 12      ; mese (dicembre)
mov dl, 25      ; giorno
int 21h         ; imposta la data
```

#### `2Ch` — Leggi ora
```asm
mov ah, 2Ch
int 21h
; dopo l'interrupt:
; CH = ore (0-23)
; CL = minuti (0-59)
; DH = secondi (0-59)
```

#### `2Dh` — Imposta ora
```asm
mov ah, 2Dh
mov ch, 10      ; ore
mov cl, 30      ; minuti
mov dh, 0       ; secondi
int 21h         ; imposta l'ora a 10:30:00
```

---

### Controllo Programma

#### `4Ch` — Termina programma
```asm
mov ah, 4Ch
mov al, 0       ; 0 = nessun errore
int 21h         ; termina il programma
```

#### `4Bh` — Esegui un altro programma
```asm
.DATA
    programma db "altro.exe", 0
.CODE
    mov ah, 4Bh
    mov al, 0           ; 0 = carica ed esegui
    lea dx, programma
    int 21h             ; esegue "altro.exe"
```

#### `62h` — Ottieni PSP
```asm
mov ah, 62h
int 21h
; BX contiene il segmento del PSP del programma corrente
```

---

## Struttura completa tipica di un programma

```asm
.MODEL SMALL
.STACK 100h
.DATA
    msg db "Ciao mondo!", 13, 10, '$'
.CODE
main:
    mov ax, @data       ; inizializza DS
    mov ds, ax

    mov ah, 09h         ; stampa messaggio
    lea dx, msg
    int 21h

    mov ah, 4Ch         ; termina
    mov al, 0
    int 21h
END main
```