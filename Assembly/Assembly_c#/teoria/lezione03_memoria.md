# Lezione 3 — Memoria e Modalità di Indirizzamento

## 3.1 La memoria RAM: un grande array

La memoria RAM può essere vista come un **enorme array di byte**, dove ogni byte ha un indirizzo univoco.

```
Indirizzo    Contenuto (byte)
──────────   ────────────────
0x00401000 │ 0xB8  ← inizio di un'istruzione Assembly
0x00401001 │ 0x2A
0x00401002 │ 0x00
0x00401003 │ 0x00
0x00401004 │ 0x00  ← fine dell'istruzione (mov eax, 42)
0x00401005 │ 0xC3  ← ret
   ...
```

In x86-32, gli indirizzi sono numeri a **32 bit** (4 byte), quindi lo spazio di indirizzamento va da `0x00000000` a `0xFFFFFFFF` (4 GB).

---

## 3.2 Little-Endian: come vengono salvati i valori multi-byte

Quando un valore di 32 bit (DWORD) viene scritto in memoria, i byte vengono salvati in ordine **inverso** (il byte meno significativo per primo). Questo si chiama **little-endian**.

**Esempio:** salvare il valore `0x12345678` a partire dall'indirizzo `0x1000`

```
Indirizzo  Byte salvato
─────────  ────────────
0x1000  →  0x78   ← byte MENO significativo (LSB)
0x1001  →  0x56
0x1002  →  0x34
0x1003  →  0x12   ← byte PIÙ significativo (MSB)
```

> L'architettura x86 è little-endian. Importante saperlo quando si legge la memoria con un debugger!

---

## 3.3 Dichiarazione di dati statici in MASM

In MASM, i dati statici (variabili globali) si dichiarano nella sezione `.DATA`:

```asm
.DATA
    ; Byte (1 byte)
    mioChar   BYTE    'A'          ; carattere ASCII
    
    ; Word (2 byte)
    mioWord   WORD    1000         ; intero 16-bit
    
    ; DWord (4 byte, il più comune)
    mioInt    DWORD   42           ; intero 32-bit
    mioHex    DWORD   0FFH         ; usando esadecimale
    
    ; Array di DWORD
    mieiNumeri DWORD  10, 20, 30, 40, 50
    
    ; Array con DUP (500 byte tutti a zero)
    buffer    BYTE    500 DUP(0)
    
    ; Stringa ASCII (terminata da zero come in C)
    messaggio BYTE    "Ciao mondo!", 0
```

---

## 3.4 Modalità di indirizzamento

Il termine **modalità di indirizzamento** indica **come viene specificato l'operando** di un'istruzione. x86 ne supporta diverse.

### 3.4.1 Indirizzamento immediato (Immediate)

Il valore è un **costante** scritta direttamente nell'istruzione:

```asm
mov eax, 42        ; EAX ← 42 (valore immediato decimale)
mov eax, 2AH       ; EAX ← 42 (stesso, in esadecimale)
mov al, 'A'        ; AL  ← 65 (codice ASCII di 'A')
```

### 3.4.2 Indirizzamento a registro (Register)

L'operando è un registro:

```asm
mov eax, ebx       ; EAX ← valore di EBX
add ecx, edx       ; ECX ← ECX + EDX
```

### 3.4.3 Indirizzamento diretto a memoria (Direct Memory)

Si usa il nome di una variabile (dichiarata in `.DATA`) come operando:

```asm
.DATA
    x DWORD 10

.CODE
    mov eax, [x]       ; EAX ← contenuto della variabile x (= 10)
    mov [x], ebx       ; scrive in x il valore di EBX
    mov eax, x         ; ERRORE COMUNE: senza [] carica l'INDIRIZZO, non il valore!
```

> `[x]` significa "vai all'indirizzo di x e leggi cosa c'è lì". Le parentesi quadre sono l'operatore di **dereferenziazione**.

### 3.4.4 Indirizzamento indiretto tramite registro

Il registro **contiene l'indirizzo** da cui leggere/scrivere:

```asm
mov eax, [ebx]     ; EAX ← valore all'indirizzo contenuto in EBX
mov [edi], ecx     ; scrive ECX all'indirizzo contenuto in EDI
```

### 3.4.5 Indirizzamento con base + displacement

Molto usato per accedere a strutture (struct) e parametri sullo stack:

```asm
mov eax, [ebx + 4]     ; EAX ← valore all'indirizzo EBX+4
mov eax, [ebp + 8]     ; legge il primo parametro della funzione (vedremo perché in lezione 6)
mov eax, [ebp - 4]     ; legge la prima variabile locale
```

### 3.4.6 Indirizzamento con base + indice + scala (per gli array)

Permette di accedere agli elementi di un array con un indice variabile:

```asm
; Sintassi: [base + indice * scala + displacement]
; scala può essere 1, 2, 4 oppure 8

mov eax, [esi + ecx*4]     ; EAX ← array[ECX] (array di DWORD: 4 byte per elemento)
lea edi, [ebx + ecx*4 + 8] ; EDI ← indirizzo di array[ECX] con offset aggiuntivo
```

---

## 3.5 Direttive di dimensione (Size Directives)

Quando si accede alla memoria, il processore deve sapere **quanti byte leggere/scrivere**.
Di solito il tipo del registro lo determina automaticamente (EAX → 4 byte, AX → 2 byte, AL → 1 byte).
Ma in alcuni casi è necessario specificarlo esplicitamente:

```asm
mov BYTE PTR [ebx], 5      ; scrivi 1 byte
mov WORD PTR [ebx], 5      ; scrivi 2 byte
mov DWORD PTR [ebx], 5     ; scrivi 4 byte

; Esempio di lettura:
movzx eax, BYTE PTR [ebx]  ; leggi 1 byte e zero-extend a 32 bit
movsx eax, BYTE PTR [ebx]  ; leggi 1 byte e sign-extend a 32 bit (preserva il segno)
```

---

## 3.6 Riepilogo visivo: differenza tra indirizzo e valore

```
                  MEMORIA
Indirizzo    ┌──────────────┐
0x1000       │     0x2A     │  ← variabile "x" vale 42 (0x2A)
0x1001       │     0x00     │
0x1002       │     0x00     │
0x1003       │     0x00     │
             └──────────────┘

mov eax, [0x1000]   → EAX = 0x0000002A    (valore)
mov eax, 0x1000     → EAX = 0x00001000    (indirizzo!)
```

---

## 3.7 Esercizi di consolidamento

1. Scrivi la dichiarazione MASM per:
   - Un intero `a` con valore 100
   - Un array `voti` di 30 byte tutti inizializzati a 0
   - Una stringa `nome` con il testo "Mario", 0

2. Data `mov eax, [ebp + 12]`, cosa si sta caricando? (suggerimento: vedi lezione 6)

3. Con il valore `0xAABBCCDD` salvato all'indirizzo `0x2000`, scrivi in ordine cosa trovi agli indirizzi `0x2000`, `0x2001`, `0x2002`, `0x2003` (ricorda: little-endian!)

4. Qual è la differenza tra `mov eax, x` e `mov eax, [x]`?

5. Scrivi un frammento Assembly che legge il terzo elemento (indice 2) di un array di DWORD puntato da ESI e lo carica in EAX.
