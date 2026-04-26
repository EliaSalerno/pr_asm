# Lettura da Tastiera e Ristampa in Assembly x86 (DOS)

## Indice
1. [Teoria: Come funziona la memoria in Assembly](#1-teoria-come-funziona-la-memoria-in-assembly)
2. [Il sistema degli Interrupt DOS](#2-il-sistema-degli-interrupt-dos)
3. [La struttura del buffer di input](#3-la-struttura-del-buffer-di-input)
4. [Il terminatore di stringa `$`](#4-il-terminatore-di-stringa-)
5. [I valori numerici e il loro significato contestuale](#5-i-valori-numerici-e-il-loro-significato-contestuale)
6. [La direttiva `dup`](#6-la-direttiva-dup)
7. [Codice completo commentato](#7-codice-completo-commentato)
8. [Errori comuni](#8-errori-comuni)

---

## 1. Teoria: Come funziona la memoria in Assembly

In Assembly, la memoria è una sequenza lineare di byte. Il compilatore **non assegna tipi** ai dati: un byte con valore `10` è semplicemente un byte con valore `10`. È il codice che lo usa a dargli un significato.

Questo è il principio fondamentale da tenere sempre a mente:

> Il compilatore non interpreta i dati. Li memorizza. Il significato dipende da chi li legge.

Quando si dichiara una variabile nella sezione `.DATA`:

```asm
msg1 DB 10, 0, 10 dup(0)
```

il compilatore alloca byte contigui in memoria e associa l'etichetta `msg1` all'indirizzo del primo byte. Nient'altro.

---

## 2. Il sistema degli Interrupt DOS

Il DOS espone le sue funzioni tramite l'interrupt `21h`. Si seleziona la funzione desiderata caricando un valore nel registro `AH` prima di chiamare `INT 21h`.

Le funzioni rilevanti per la gestione dell'input/output di testo sono:

| `AH` | Funzione | Descrizione |
|------|----------|-------------|
| `09h` | Stampa stringa | Stampa a schermo fino al carattere `$` |
| `0Ah` | Leggi stringa | Legge da tastiera nel buffer indicato da `DX` |
| `4Ch` | Termina programma | Chiude il programma e restituisce il controllo al DOS |

Il flusso tipico è:
1. Impostare `AH` con il codice della funzione
2. Impostare `DX` con l'indirizzo del dato (stringa o buffer)
3. Chiamare `INT 21h`

---

## 3. La struttura del buffer di input

La funzione `0Ah` richiede un buffer con una struttura precisa di **tre sezioni**:

```
INDIRIZZO     CONTENUTO         CHI LO SCRIVE
─────────────────────────────────────────────────────
buffer[0]   = dimensione max   ← TU, prima della chiamata
buffer[1]   = caratteri letti  ← DOS, dopo la chiamata
buffer[2..] = testo digitato   ← DOS, dopo la chiamata
```

### Dichiarazione corretta

```asm
msg1 DB 10, 0, 10 dup(0)
;        ↑   ↑   └──────┘
;        │   │   10 byte per i caratteri (inizializzati a 0)
;        │   └── lunghezza letta (DOS scrive qui)
;        └────── dimensione massima = 10 (tu lo scrivi)
```

### Cosa succede se `buffer[0]` vale `0`

La funzione `0Ah` legge `buffer[0]` **prima** di accettare qualsiasi input. Se trova `0`, interpreta il buffer come capace di contenere zero caratteri e termina immediatamente senza leggere nulla. Questo è il motivo per cui un buffer inizializzato con `10 dup(0)` non permette alcun inserimento.

---

## 4. Il terminatore di stringa `$`

La funzione `09h` non conosce la lunghezza della stringa. Stampa byte uno per uno finché non incontra il carattere `$` (valore ASCII 36).

Dopo la lettura con `0Ah`, la stringa in `buffer[2..]` **non ha** il terminatore. Bisogna aggiungerlo manualmente, usando la lunghezza fornita da DOS in `buffer[1]`:

```asm
MOV bl, msg1[1]      ; BL = numero di caratteri letti (es. 4 per "ciao")
XOR bh, bh           ; BH = 0, così BX = 4
MOV msg1[bx+2], '$'  ; scrive '$' subito dopo l'ultimo carattere
```

### Esempio con input "ciao"

```
PRIMA della stampa:
  msg1[0] = 10
  msg1[1] = 4      ← DOS ha scritto: 4 caratteri letti
  msg1[2] = 'c'
  msg1[3] = 'i'
  msg1[4] = 'a'
  msg1[5] = 'o'
  msg1[6] = 0      ← ancora 0, manca il terminatore!

DOPO msg1[bx+2] = '$':
  msg1[6] = '$'    ← ora la funzione 09h sa dove fermarsi
```

---

## 5. I valori numerici e il loro significato contestuale

Uno degli aspetti più importanti dell'Assembly è che lo stesso valore numerico può avere significati completamente diversi a seconda di chi lo usa.

### Il caso del valore `10`

```asm
msg1 DB 10, 0, 10 dup(0)   ; primo 10: dimensione buffer
msg3 DB 13, 10, 'Testo: $'  ; secondo 10: Line Feed (LF)
```

Entrambi i `10` producono un byte con valore `0x0A` in memoria. Il compilatore li tratta in modo identico. La differenza è:

| Contesto | Chi usa il byte | Come lo interpreta |
|----------|----------------|--------------------|
| `msg1[0]` | Funzione DOS `0Ah` | Limite massimo di caratteri accettati |
| `msg3[1]` | Funzione DOS `09h` → terminale | Carattere di controllo: va a capo (Line Feed) |

### La coppia CR + LF

Per andare a capo in DOS è necessario usare **due caratteri** in sequenza:

```asm
DB 13, 10
;  ↑   ↑
;  CR  LF
;  \r  \n
```

- `13` = `0Dh` = Carriage Return → riporta il cursore all'inizio della riga
- `10` = `0Ah` = Line Feed → sposta il cursore alla riga successiva

Sui terminali DOS entrambi sono necessari per ottenere un vero "a capo".

---

## 6. La direttiva `dup`

`dup` è una **direttiva del compilatore**, non un valore da memorizzare. La sua sintassi è:

```
N dup(VALORE)
```

Significa: *ripeti `VALORE` per `N` volte*.

```asm
10 dup(0)    ; equivale a: 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
3 dup('A')   ; equivale a: 'A', 'A', 'A'
2 dup(13,10) ; equivale a: 13, 10, 13, 10
```

Il compilatore riconosce `dup` come parola chiave riservata. Quando la incontra, sa che il numero che la precede è una **quantità di ripetizioni**, non un byte da memorizzare. Ecco perché non c'è ambiguità tra il primo `10` (valore) e il secondo `10` (ripetizioni) nella dichiarazione:

```asm
msg1 DB 10, 0, 10 dup(0)
;        ↑           ↑
;     valore      ripetizioni (parola chiave dup disambigua)
```

---

## 7. Codice completo commentato

```asm
DOSSEG
.MODEL SMALL
.STACK 100h

.DATA
  ; Buffer strutturato per la funzione 0Ah:
  ;   [0] = 10  → accetta fino a 10 caratteri
  ;   [1] = 0   → DOS scriverà qui la lunghezza letta
  ;   [2..11]   → DOS scriverà qui i caratteri digitati
  msg1 DB 10, 0, 10 dup(0)

  msg2 DB 'Inserire il testo: $'
  msg3 DB 13, 10, 'Hai inserito: $'   ; 13=CR, 10=LF per andare a capo

.CODE
main:
  ; --- Inizializzazione segmento dati ---
  MOV ax, @DATA
  MOV ds, ax

  ; --- Stampa il messaggio di richiesta ---
  MOV dx, OFFSET msg2
  MOV ah, 09h
  INT 21h

  ; --- Leggi la stringa da tastiera ---
  ; DX punta a msg1, la funzione legge msg1[0] per sapere il limite
  MOV ah, 0Ah
  MOV dx, OFFSET msg1
  INT 21h

  ; --- Aggiungi il terminatore '$' dopo l'ultimo carattere ---
  MOV bl, msg1[1]      ; BL = numero di caratteri effettivamente letti
  XOR bh, bh           ; BH = 0, così BX è l'indice corretto
  MOV msg1[bx+2], '$'  ; posiziona '$' subito dopo l'ultimo carattere

  ; --- Stampa "a capo" + etichetta ---
  MOV dx, OFFSET msg3
  MOV ah, 09h
  INT 21h

  ; --- Stampa la stringa inserita ---
  ; msg1+2 è l'indirizzo del primo carattere digitato
