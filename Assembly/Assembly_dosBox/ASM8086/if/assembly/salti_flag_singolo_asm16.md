# Salti Condizionati su Flag Singolo — Assembly x86 16-bit

## Introduzione: il registro dei flag (FLAGS)

In architettura x86 16-bit, il registro **FLAGS** (16 bit) contiene bit di stato aggiornati
automaticamente dopo la maggior parte delle istruzioni aritmetiche e logiche (`ADD`, `SUB`,
`CMP`, `AND`, `OR`, `TEST`, ecc.).

I salti condizionati su **flag singolo** testano uno solo di questi bit e saltano all'etichetta
indicata se la condizione è vera, altrimenti eseguono l'istruzione successiva.

```
Bit:  15 14 13 12  11  10   9   8   7   6   5   4   3   2   1   0
      —  —  —  —  [OF][DF][IF][TF][SF][ZF] — [AF] — [PF] — [CF]
```

| Sigla | Nome completo      | Bit |
|-------|--------------------|-----|
| CF    | Carry Flag         |  0  |
| PF    | Parity Flag        |  2  |
| AF    | Auxiliary Flag     |  4  |
| ZF    | Zero Flag          |  6  |
| SF    | Sign Flag          |  7  |
| OF    | Overflow Flag      | 11  |

---

## 1. ZF — Zero Flag

### Quando viene impostato
ZF = 1 se il risultato dell'ultima operazione è **zero**.
ZF = 0 se il risultato è diverso da zero.

### Istruzioni di salto

| Istruzione | Alias | Condizione |
|------------|-------|------------|
| `JZ  etich` | `JE` | Salta se ZF = 1 (risultato zero / operandi uguali) |
| `JNZ etich` | `JNE` | Salta se ZF = 0 (risultato non zero / operandi diversi) |

### Esempi

```asm
; --- Esempio 1: JZ dopo SUB ---
; Controlla se AX è uguale a 10

    mov ax, 10
    sub ax, 10          ; AX = 0  →  ZF = 1
    jz  uguale_a_dieci  ; ZF=1: salta
    ; (non eseguito)
uguale_a_dieci:
    mov bx, 1           ; BX = 1 (flag "trovato")

; --- Esempio 2: JNZ — loop fino a zero ---
; Conta da 5 a 0 e si ferma

    mov cx, 5
conta:
    dec cx              ; CX--; se CX diventa 0 → ZF=1
    jnz conta          ; ZF=0: continua il loop
    ; qui CX = 0

; --- Esempio 3: JE (alias JZ) dopo CMP ---
; CMP non modifica i registri, esegue internamente una SUB

    mov al, 'A'
    cmp al, 'A'         ; 'A' - 'A' = 0  →  ZF = 1
    je  carattere_A
    jmp fine
carattere_A:
    mov bh, 1
fine:
```

> **Nota:** `CMP dest, src` esegue `dest - src` aggiornando i flag **senza** salvare il risultato.
> `JE` e `JZ` sono identici a livello macchina (stesso opcode), solo il nome cambia per leggibilità.

---

## 2. CF — Carry Flag

### Quando viene impostato
CF = 1 se si verifica un **riporto** (carry) o un **prestito** (borrow) uscente dal bit più
significativo, ovvero quando il risultato non entra nel tipo unsigned.

| Operazione | CF = 1 se… |
|------------|-----------|
| ADD / ADC  | somma > 0xFFFF (16-bit) |
| SUB / SBB / CMP | minuendo < sottraendo (unsigned) |
| SHL / SAL / SHR / SAR | bit uscente = 1 |
| STC / CLC  | impostato/azzerato manualmente |

### Istruzioni di salto

| Istruzione | Alias | Condizione |
|------------|-------|------------|
| `JC  etich` | `JB`, `JNAE` | Salta se CF = 1 |
| `JNC etich` | `JNB`, `JAE` | Salta se CF = 0 |

### Esempi

```asm
; --- Esempio 1: JC — rileva overflow in addizione unsigned ---

    mov ax, 0FFFFh      ; valore massimo 16-bit
    add ax, 1           ; AX = 0000h, CF = 1 (carry out)
    jc  overflow_u
    jmp ok
overflow_u:
    mov bx, 0FFFFh      ; segnala errore

; --- Esempio 2: JNC — addizione multi-precisione (32-bit) ---
; Somma due numeri a 32 bit memorizzati in DX:AX e BX:CX

    add ax, cx          ; somma parte bassa
    jnc no_carry        ; nessun riporto
    inc dx              ; propaga il carry nella parte alta
no_carry:
    add dx, bx          ; somma parte alta

; --- Esempio 3: JC dopo shift ---
; Controlla se il bit più alto di AL era 1

    mov al, 10000000b   ; bit 7 = 1
    shl al, 1           ; bit 7 esce → CF = 1
    jc  bit_alto_set
    jmp fine
bit_alto_set:
    mov bl, 1
fine:

; --- Esempio 4: JC / JB in confronto unsigned ---
; AX < BX (senza segno)?

    mov ax, 3
    mov bx, 10
    cmp ax, bx          ; 3 - 10 = borrow → CF = 1
    jc  ax_minore       ; CF=1: ax < bx (unsigned)
ax_minore:
    ; AX è il minore
```

> **Memoria:** `JB` = "Jump if Below" e `JC` = "Jump if Carry" hanno lo stesso opcode.
> Usa `JB`/`JNB` quando il confronto è semanticamente tra valori; `JC`/`JNC` quando interessa
> il carry fisico (shift, aritmetica multi-precisione).

---

## 3. SF — Sign Flag

### Quando viene impostato
SF riflette il **bit più significativo** del risultato (bit 7 per byte, bit 15 per word).
SF = 1 → risultato negativo (in complemento a due).
SF = 0 → risultato zero o positivo.

### Istruzioni di salto

| Istruzione | Condizione |
|------------|------------|
| `JS  etich` | Salta se SF = 1 (risultato negativo) |
| `JNS etich` | Salta se SF = 0 (risultato ≥ 0) |

### Esempi

```asm
; --- Esempio 1: JS — rileva risultato negativo ---

    mov ax, 5
    sub ax, 10          ; AX = -5 (FFFBh), SF = 1
    js  negativo
    jmp positivo
negativo:
    neg ax              ; prendi il valore assoluto (AX = 5)
positivo:
    ; AX contiene |valore|

; --- Esempio 2: JNS — ciclo che sale finché il risultato non diventa negativo ---

    mov al, 100
ciclo:
    add al, 10          ; incrementa
    jns ciclo           ; SF=0: continua finché al ≥ 0
    ; al è "traboccato" in negativo (> 127 signed)

; --- Esempio 3: SF dopo AND (maschera bit di segno) ---
; Verifica se il valore in BX ha il bit 15 alzato

    mov bx, 8000h       ; bit 15 = 1
    and bx, bx          ; AND con se stesso: non cambia BX, aggiorna SF
    js  bit15_set
bit15_set:
    mov cx, 1
```

> **Attenzione:** SF è affidabile per il segno **solo** se non c'è stato overflow (OF=0).
> Per confronti signed completi usa `JL`/`JG` che combinano SF e OF.

---

## 4. OF — Overflow Flag

### Quando viene impostato
OF = 1 se si verifica un **overflow con segno**: il risultato di un'operazione signed non
entra nel range del tipo (`-128..127` per byte, `-32768..32767` per word).

| Caso | Esempio (8-bit) | Risultato |
|------|-----------------|-----------|
| Pos + Pos → Neg | 127 + 1 = -128 | OF=1 |
| Neg + Neg → Pos | -128 + (-1) = 127 | OF=1 |
| Pos - Neg → Neg | 32767 - (-1) = -32768 | OF=1 |

### Istruzioni di salto

| Istruzione | Condizione |
|------------|------------|
| `JO  etich` | Salta se OF = 1 (overflow signed) |
| `JNO etich` | Salta se OF = 0 (nessun overflow) |

### Esempi

```asm
; --- Esempio 1: JO — rileva overflow in addizione signed ---

    mov al, 127         ; valore massimo signed 8-bit
    add al, 1           ; 127 + 1 = -128 signed → OF = 1
    jo  overflow_s
    jmp ok
overflow_s:
    mov bh, 0FFh        ; segnala errore overflow

; --- Esempio 2: JNO — addizione sicura ---

    mov ax, 1000
    add ax, 2000        ; 3000: dentro il range 16-bit signed → OF = 0
    jno risultato_ok
    ; gestione errore (non raggiunto)
risultato_ok:
    mov bx, ax

; --- Esempio 3: overflow in sottrazione signed ---

    mov al, -128        ; 80h
    sub al, 1           ; -128 - 1 = 127 (overflow!) → OF = 1
    jo  overflow_sub
overflow_sub:
    ; gestione
```

---

## 5. PF — Parity Flag

### Quando viene impostato
PF = 1 se il **byte meno significativo** del risultato contiene un numero **pari** di bit a 1
(parità pari). PF = 0 se i bit a 1 sono in numero dispari.

> PF è usato raramente nella programmazione moderna; era comune nelle comunicazioni seriali
> per il controllo degli errori.

### Istruzioni di salto

| Istruzione | Alias | Condizione |
|------------|-------|------------|
| `JP  etich` | `JPE` | Salta se PF = 1 (parità pari) |
| `JNP etich` | `JPO` | Salta se PF = 0 (parità dispari) |

### Esempi

```asm
; --- Esempio 1: JP — controlla parità di un byte ricevuto ---

    mov al, 10110011b   ; bit a 1: 5 → parità dispari → PF = 0
    and al, al          ; aggiorna PF senza modificare AL
    jp  parita_pari
    ; parità dispari: errore di trasmissione?
    mov bx, 1           ; segnala errore
    jmp fine
parita_pari:
    mov bx, 0
fine:

; --- Esempio 2: valore con parità pari ---

    mov al, 11001100b   ; bit a 1: 4 → parità pari → PF = 1
    test al, al         ; TEST: AND logico, aggiorna solo flag
    jp  ok_pari
ok_pari:
    ; trasmissione corretta
```

> `TEST dest, src` calcola `dest AND src` e aggiorna i flag **senza** salvare il risultato,
> analogo a `CMP` ma con AND invece di SUB.

---

## Riepilogo visivo dei salti su flag singolo

```
Istruzione   Alias       Flag testato   Condizione
─────────────────────────────────────────────────────
JZ           JE          ZF             ZF = 1
JNZ          JNE         ZF             ZF = 0
JC           JB, JNAE    CF             CF = 1
JNC          JNB, JAE    CF             CF = 0
JS           —           SF             SF = 1
JNS          —           SF             SF = 0
JO           —           OF             OF = 1
JNO          —           OF             OF = 0
JP           JPE         PF             PF = 1
JNP          JPO         PF             PF = 0
```

---

## Esempio completo: classificazione di un intero signed 16-bit

```asm
; Input:  AX = numero signed da classificare
; Output: BX = 0 (negativo), 1 (zero), 2 (positivo)

classifica:
    cmp ax, 0

    jz  e_zero          ; ZF=1 → AX è zero
    js  e_negativo      ; SF=1 → AX < 0 (assumendo OF=0)

e_positivo:
    mov bx, 2
    jmp fine

e_negativo:
    mov bx, 0
    jmp fine

e_zero:
    mov bx, 1

fine:
    ret
```

---

## Esempio completo: addizione sicura con controllo CF e OF

```asm
; Somma AX + BX in modo "safe" (controlla sia overflow unsigned che signed)
; Risultato in CX
; DL = 0 ok, 1 = carry (overflow unsigned), 2 = overflow signed

somma_safe:
    mov dl, 0
    add ax, bx

    jno no_of           ; OF=0: nessun overflow signed
    mov dl, 2           ; segnala overflow signed
    jmp fine_s
no_of:
    jnc no_cf           ; CF=0: nessun carry
    mov dl, 1           ; segnala overflow unsigned
no_cf:
    mov cx, ax          ; salva risultato
fine_s:
    ret
```

---

## Note finali

- I salti condizionali in 16-bit sono **sempre SHORT**: l'offset è un valore **signed a 8 bit**,
  quindi il salto è limitato a **-128 / +127 byte** dall'istruzione successiva.
- Per saltare più lontano usa un JMP incondizionato come trampolino:
  ```asm
      jz  vicino
      jmp lontano_altrove
  vicino:
  ```
- L'istruzione `CMP` è la più usata per impostare i flag prima di un salto condizionato;
  non modifica gli operandi.
- `TEST` è la versione AND di `CMP`: utile per testare singoli bit senza modificare il registro.
