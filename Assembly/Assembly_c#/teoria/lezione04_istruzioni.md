# Lezione 4 — Il Set di Istruzioni x86

## 4.1 Panoramica

Le istruzioni Assembly sono le operazioni elementari che la CPU sa eseguire.
Le classifichiamo in tre grandi gruppi:

1. **Istruzioni di trasferimento dati** — spostano dati tra registri e memoria
2. **Istruzioni aritmetiche e logiche** — eseguono operazioni sui dati
3. **Istruzioni di controllo del flusso** — decidono quale istruzione eseguire dopo

---

## 4.2 Istruzioni di trasferimento dati

### MOV — Move (copia)

La più usata in assoluto. Copia il valore dell'operando sorgente nella destinazione.

```asm
mov dst, src     ; dst ← src
```

Forme valide:
```asm
mov eax, ebx           ; registro ← registro
mov eax, 42            ; registro ← costante
mov eax, [var]         ; registro ← memoria
mov [var], ebx         ; memoria ← registro
mov DWORD PTR [ebx], 0 ; memoria (tramite puntatore) ← costante
```

> **Non esiste** `mov [mem1], [mem2]` — NON si può copiare direttamente da memoria a memoria!

---

### PUSH e POP — Operazioni sullo stack

Lo **stack** è una struttura LIFO (Last In, First Out) in memoria.
ESP (Stack Pointer) punta sempre alla cima dello stack.

```asm
push eax        ; ESP ← ESP - 4
                ; [ESP] ← EAX   (salva EAX sullo stack)

pop  ebx        ; EBX ← [ESP]
                ; ESP ← ESP + 4  (recupera il valore cima)
```

```
Prima di push:          Dopo push eax (EAX=42):

ESP →  [ ... ]          ESP →  [  42  ]   ← nuova cima
       [ ... ]                 [ ... ]
       [ ... ]                 [ ... ]
```

---

### LEA — Load Effective Address

Carica un **indirizzo** (non il valore!) in un registro. Molto usata per calcolare indirizzi di array o strutture.

```asm
lea eax, [ebx + ecx*4]    ; EAX ← EBX + ECX*4  (calcolo senza accedere alla memoria)
lea edi, [var]            ; EDI ← indirizzo di 'var'
```

> Trucco: `lea` viene usata anche come istruzione aritmetica, perché permette
> di fare `base + indice*scala + offset` in **un solo ciclo**.

---

## 4.3 Istruzioni aritmetiche

### ADD e SUB

```asm
add eax, ebx       ; EAX ← EAX + EBX
add eax, 10        ; EAX ← EAX + 10
sub ecx, 1         ; ECX ← ECX - 1
sub [var], eax     ; [var] ← [var] - EAX
```

### INC e DEC — Increment / Decrement

```asm
inc eax            ; EAX ← EAX + 1  (come add eax, 1 ma più breve)
dec ecx            ; ECX ← ECX - 1
inc DWORD PTR [var]; incrementa il valore in memoria
```

### MUL e IMUL — Moltiplicazione (unsigned / signed)

```asm
; MUL: moltiplicazione senza segno
; EAX * operando → risultato in EDX:EAX (64 bit!)
mul ebx            ; EDX:EAX ← EAX × EBX

; IMUL: moltiplicazione con segno (forme varianti)
imul eax, ebx      ; EAX ← EAX × EBX  (risultato a 32 bit)
imul eax, ebx, 5   ; EAX ← EBX × 5
```

### IDIV — Divisione con segno

La divisione è l'operazione più "scomoda" in Assembly:

```asm
; Prima della divisione: EDX:EAX contiene il dividendo a 64 bit
; IDIV divide EDX:EAX per l'operando
cdq                ; sign-extend EAX in EDX:EAX (preparazione)
idiv ecx           ; EAX ← quoziente,  EDX ← resto
```

**Esempio:** calcola 17 / 5

```asm
mov eax, 17        ; dividendo
cdq                ; prepara EDX (EDX = 0 se EAX ≥ 0)
mov ecx, 5         ; divisore
idiv ecx           ; EAX = 3 (quoziente), EDX = 2 (resto)
```

---

## 4.4 Istruzioni logiche

### AND, OR, XOR, NOT

Lavorano **bit per bit** sui valori.

```asm
and eax, 0FH       ; EAX ← EAX AND 0x0F  → azzera i bit alti, conserva i 4 bassi
or  eax, 0F0H      ; EAX ← EAX OR 0xF0   → imposta i bit 4-7
xor eax, eax       ; EAX ← EAX XOR EAX   → modo veloce per azzerare EAX!
not eax            ; EAX ← complemento a uno di EAX
```

**Usi comuni:**
- `and` → mascherare (isolare) bit specifici
- `or`  → impostare bit specifici
- `xor` → invertire bit o azzerare un registro
- `xor reg, reg` è l'idioma standard per mettere un registro a zero

### SHL e SHR — Shift logico a sinistra/destra

```asm
shl eax, 1         ; EAX ← EAX × 2       (shift di 1 a sinistra)
shl eax, 4         ; EAX ← EAX × 16      (shift di 4)
shr eax, 2         ; EAX ← EAX ÷ 4       (shift di 2 a destra, unsigned)
shl eax, cl        ; shift di CL posizioni (CL è il registro contatore)
```

> `shl` by N equivale a moltiplicare per 2^N. Usato per ottimizzazioni!

---

## 4.5 Istruzioni di controllo del flusso

### CMP — Compare

Non salva il risultato, **aggiorna solo i flag** (EFLAGS):

```asm
cmp eax, ebx       ; calcola eax - ebx, aggiorna ZF/SF/CF/OF ma non salva il risultato
cmp eax, 0         ; confronta eax con zero
```

### JMP — Salto incondizionato

```asm
jmp etichetta      ; salta sempre all'etichetta
jmp eax            ; salta all'indirizzo contenuto in EAX (salto indiretto)
```

### Salti condizionali

Dopo un `cmp a, b`, usare uno di questi jump:

| Istruzione | Significato | Condizione |
|-----------|-------------|-----------|
| `je` / `jz` | Jump if Equal / Zero | ZF = 1 |
| `jne` / `jnz` | Jump if Not Equal | ZF = 0 |
| `jg` | Jump if Greater (signed) | ZF=0 e SF=OF |
| `jge` | Jump if Greater or Equal | SF = OF |
| `jl` | Jump if Less (signed) | SF ≠ OF |
| `jle` | Jump if Less or Equal | ZF=1 o SF≠OF |
| `ja` | Jump if Above (unsigned) | CF=0 e ZF=0 |
| `jb` | Jump if Below (unsigned) | CF = 1 |

**Esempio — if/else in Assembly:**

```c
// C#/C originale:
if (a > b) { x = 1; } else { x = 2; }
```

```asm
; Assembly equivalente:
    cmp eax, ebx       ; confronta a (EAX) con b (EBX)
    jle else_branch    ; se a <= b, vai all'else
    mov ecx, 1         ; a > b → x = 1
    jmp fine
else_branch:
    mov ecx, 2         ; x = 2
fine:
```

**Esempio — ciclo for in Assembly:**

```c
// C# originale:
for (int i = 0; i < 10; i++) { somma += i; }
```

```asm
    mov ecx, 0         ; i = 0
    mov eax, 0         ; somma = 0
loop_start:
    cmp ecx, 10        ; if i >= 10...
    jge loop_end       ;   ...esci dal ciclo
    add eax, ecx       ; somma += i
    inc ecx            ; i++
    jmp loop_start
loop_end:
    ; EAX = 45 (somma di 0..9)
```

### CALL e RET — Chiamata a subroutine e ritorno

```asm
call mia_funzione   ; salva EIP sullo stack, poi salta a mia_funzione
; ...il codice da qui in poi viene eseguito dopo il ret...

mia_funzione:
    ; corpo della funzione
    ret             ; riprende l'indirizzo dallo stack e ci salta
```

---

## 4.6 NEG — Negazione (complemento a due)

```asm
neg eax            ; EAX ← -EAX  (complemento a due)
```

---

## 4.7 Tabella riassuntiva

| Istruzione | Effetto |
|-----------|---------|
| `mov dst, src` | dst ← src |
| `push src` | stack ← src, ESP -= 4 |
| `pop dst` | dst ← stack, ESP += 4 |
| `lea dst, [expr]` | dst ← indirizzo di expr |
| `add dst, src` | dst ← dst + src |
| `sub dst, src` | dst ← dst - src |
| `inc dst` | dst ← dst + 1 |
| `dec dst` | dst ← dst - 1 |
| `imul dst, src` | dst ← dst × src |
| `idiv src` | EAX ← EAX÷src, EDX ← EAX mod src |
| `and/or/xor dst, src` | operazione bit-a-bit |
| `shl/shr dst, n` | shift a sinistra/destra di n bit |
| `cmp a, b` | aggiorna flag su (a - b) |
| `jmp lbl` | salta senza condizione |
| `je/jne/jg/jl ... lbl` | salta se condizione vera |
| `call lbl` | chiama subroutine |
| `ret` | ritorna dalla subroutine |

---

## 4.8 Esercizi di consolidamento

1. Scrivi il codice Assembly per calcolare `(a + b) * 2 - c` con `a=EAX`, `b=EBX`, `c=ECX`, risultato in EDX.

2. Usa `xor` per azzerare EBX in un'istruzione sola. Perché è preferibile a `mov ebx, 0`?

3. Converti in Assembly:
   ```
   se (x != 0 && x < 100) allora y = x * 4
   ```

4. Scrivi un ciclo che conta da 10 a 1 usando LOOP (cerca la descrizione dell'istruzione `loop` nel manuale x86).

5. Cosa contengono EAX e EDX dopo: `mov eax, 17; cdq; mov ecx, 3; idiv ecx`?
