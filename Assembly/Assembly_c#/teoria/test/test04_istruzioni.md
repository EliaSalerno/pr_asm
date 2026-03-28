# Test — Lezione 4: Il Set di Istruzioni x86

> **Istruzioni:** Il test include domande a risposta multipla, predizione del comportamento
> di codice Assembly e scrittura di frammenti. Tempo consigliato: 35 minuti.

---

## Parte A — Domande a risposta multipla

**1.** Quale delle seguenti istruzioni `mov` è **NON valida** in x86-32?

- a) `mov eax, ebx`
- b) `mov eax, 42`
- c) `mov [var1], [var2]`
- d) `mov DWORD PTR [eax], 0`

---

**2.** Cosa fa esattamente l'istruzione `push eax`?

- a) Copia EAX in EBX
- b) Decrementa ESP di 4 e poi scrive EAX all'indirizzo puntato da ESP
- c) Incrementa ESP di 4 e poi scrive EAX all'indirizzo puntato da ESP
- d) Salva EAX direttamente in EBP

---

**3.** Dopo `pop ebx`, cosa succede a ESP?

- a) Diminuisce di 4
- b) Rimane invariato
- c) Aumenta di 4
- d) Viene azzerato

---

**4.** Qual è la differenza principale tra `mov eax, [ebx]` e `lea eax, [ebx]`?

- a) Non c'è nessuna differenza
- b) `mov` carica il **valore** all'indirizzo EBX, `lea` carica l'**indirizzo** stesso (EBX)
- c) `lea` è più lenta di `mov`
- d) `mov` carica l'indirizzo, `lea` carica il valore

---

**5.** Dopo `mov eax, 17; cdq; mov ecx, 3; idiv ecx`, cosa contiene **EAX**?

- a) 17
- b) 5
- c) 3
- d) 2

---

**6.** Dopo le stesse istruzioni del punto 5, cosa contiene **EDX**?

- a) 0
- b) 2
- c) 5
- d) 17

---

**7.** Quale istruzione è l'**idioma standard** per azzerare un registro in Assembly x86?

- a) `mov eax, 0`
- b) `sub eax, eax`
- c) `xor eax, eax`
- d) `and eax, 0`

---

**8.** L'istruzione `shl eax, 3` equivale a:

- a) EAX ← EAX + 3
- b) EAX ← EAX × 3
- c) EAX ← EAX × 8
- d) EAX ← EAX ÷ 8

---

**9.** Cosa fa `cmp eax, ebx`?

- a) Copia il valore di EBX in EAX
- b) Calcola EAX - EBX e salva il risultato in EAX
- c) Calcola EAX - EBX, aggiorna i flag ma **non** salva il risultato
- d) Confronta EAX ed EBX e mette 1 in EAX se sono uguali

---

**10.** Dopo `cmp eax, ebx` con EAX = EBX, quale istruzione di salto verrà eseguita?

- a) `jg` (Jump if Greater)
- b) `jl` (Jump if Less)
- c) `je` (Jump if Equal)
- d) `jne` (Jump if Not Equal)

---

**11.** Cosa fa `call mia_funzione`?

- a) Salta a `mia_funzione` senza salvare nulla
- b) Salva il valore di EBP e poi salta a `mia_funzione`
- c) Salva l'indirizzo dell'istruzione successiva sullo stack e poi salta a `mia_funzione`
- d) Copia il contenuto di EAX e poi chiama `mia_funzione`

---

**12.** L'istruzione `neg eax` con `EAX = 5` produce:

- a) EAX = 0
- b) EAX = -5 (complemento a due)
- c) EAX = 5 (nessun effetto)
- d) EAX = 0xFFFFFFFB

---

## Parte B — Predizione e traccia del codice

**13.** Traccia il valore di EAX dopo ogni istruzione:

```asm
mov eax, 10        ; EAX = ___
add eax, 5         ; EAX = ___
sub eax, 3         ; EAX = ___
shl eax, 1         ; EAX = ___
inc eax            ; EAX = ___
```

---

**14.** Il seguente codice implementa un costrutto `if/else`. Aggiungi un commento a fianco di ogni istruzione spiegando cosa fa e a quale riga del codice C# corrisponde:

```c
// C# originale:
// if (a > 10) { b = 1; } else { b = 0; }
// EAX = a, EBX = b
```

```asm
    cmp eax, 10        ; ___________________________________
    jle ramo_else      ; ___________________________________
    mov ebx, 1         ; ___________________________________
    jmp fine           ; ___________________________________
ramo_else:
    mov ebx, 0         ; ___________________________________
fine:
```

---

**15.** Scrivi il codice Assembly equivalente al seguente ciclo C#.  
Usa EAX per la somma e ECX come contatore.

```csharp
// C# originale:
int somma = 0;
for (int i = 1; i <= 5; i++) {
    somma += i;
}
// somma = 15
```

```asm
; Scrivi il codice Assembly qui:


```

---

**16.** Scrivi il codice Assembly per calcolare `(a + b) * 2 - c` dove:
- `a` è in EAX, `b` è in EBX, `c` è in ECX
- Il risultato finale deve finire in EDX

```asm
; Scrivi il codice Assembly qui:


```

---

## Parte C — Domande a risposta aperta

**17.** *(3 punti)* Perché `xor eax, eax` è preferibile a `mov eax, 0` per azzerare un registro? Pensa alla dimensione dell'istruzione in byte.

> *Risposta:*
>
>
>

---

**18.** *(4 punti)* Spiega come funziona la **divisione in Assembly** (`idiv`). Perché è necessaria l'istruzione `cdq` prima di `idiv`? Cosa contengono EAX e EDX dopo la divisione?

> *Risposta:*
>
>
>

---

**19.** *(3 punti)* Descrivi un caso in cui `shl` (shift a sinistra) può essere usato **al posto di una moltiplicazione** in modo più efficiente. Fai un esempio concreto.

> *Risposta:*
>
>
>

---

## Griglia di valutazione

| Sezione | Punti disponibili |
|---------|-----------------|
| Parte A (12 domande × 1 punto) | 12 |
| Parte B (4 esercizi × 2 punti) | 8 |
| Parte C (3 domande aperte) | 10 |
| **Totale** | **30** |

> Sufficienza: 18/30
