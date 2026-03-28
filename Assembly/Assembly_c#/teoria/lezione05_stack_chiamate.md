# Lezione 5 — Lo Stack e la Gestione delle Chiamate

## 5.1 Cos'è lo stack?

Lo **stack** (pila) è una regione speciale della memoria che funziona come una pila di piatti: si può aggiungere o rimuovere solo dalla cima.

**Caratteristiche fondamentali:**
- Struttura **LIFO** — Last In, First Out (l'ultimo inserito è il primo estratto)
- **Cresce verso il basso** — ogni `push` fa diminuire l'indirizzo (ESP si decrementa)
- ESP (**Stack Pointer**) punta **sempre alla cima** dello stack (l'indirizzo più basso occupato)

---

## 5.2 Funzionamento di PUSH e POP

### PUSH

```asm
push eax       ; equivale a:
               ;   sub esp, 4      ; fai spazio (diminuisci ESP di 4)
               ;   mov [esp], eax  ; scrivi EAX in cima allo stack
```

```
Prima:                    Dopo push eax (EAX = 0x42):

     ┌───────────┐             ┌───────────┐
0xFC │  0x0A     │        0xF8 │  0x42     │ ← ESP (nuova cima)
     ├───────────┤             ├───────────┤
0xF8 │ (libero)  │        0xFC │  0x0A     │
     └───────────┘             └───────────┘
          ↑
         ESP
```

### POP

```asm
pop ebx        ; equivale a:
               ;   mov ebx, [esp]  ; leggi dalla cima
               ;   add esp, 4      ; rimuovi dalla cima (aumenta ESP)
```

---

## 5.3 Perché lo stack cresce verso il basso?

È una convenzione storica che permette a stack e heap (allocazione dinamica) di crescere verso l'altro senza collidere:

```
Indirizzo alto  0xFFFFFFFF
                ┌───────────────────────┐
                │   Stack               │ ↓ cresce verso il basso
                │   (call frames)       │
                ├───────────────────────┤ ← ESP (stack pointer)
                │                       │
                │   (spazio libero)     │
                │                       │
                ├───────────────────────┤ ← top dell'heap
                │   Heap                │ ↑ cresce verso l'alto
                │   (malloc/new)        │
                ├───────────────────────┤
                │   Dati globali (.DATA)│
                ├───────────────────────┤
                │   Codice (.CODE)      │
Indirizzo basso 0x00000000
```

---

## 5.4 Il frame dello stack di una funzione

Quando una funzione viene chiamata, viene creato un **frame** (fotogramma) nello stack.
Il frame contiene:
1. I **parametri** passati alla funzione (scritti dal chiamante)
2. L'**indirizzo di ritorno** (scritto automaticamente da `call`)
3. L'**EBP precedente** (salvato dalla funzione all'inizio)
4. Le **variabili locali** (allocate dalla funzione)

```
             ┌─────────────────────────┐  ← indirizzo alto
             │   ...frame chiamante... │
             ├─────────────────────────┤
EBP+12 →     │   parametro 2           │
EBP+8  →     │   parametro 1           │
EBP+4  →     │   indirizzo di ritorno  │  ← messo da CALL
EBP    →     │   EBP precedente        │  ← messo dal prologo
EBP-4  →     │   variabile locale 1    │
EBP-8  →     │   variabile locale 2    │
ESP    →     │   (cima corrente)       │  ← indirizzo basso
             └─────────────────────────┘
```

---

## 5.5 Prologo e Epilogo di una funzione

Ogni funzione Assembly segue una struttura standard chiamata **prologo** (inizio) ed **epilogo** (fine).

### Prologo

```asm
mia_funzione:
    push ebp          ; salva l'EBP del chiamante
    mov  ebp, esp     ; imposta EBP = ESP (base del frame corrente)
    sub  esp, 8       ; alloca 2 variabili locali (2 × 4 byte)
    ; ora EBP punta in modo stabile al frame
    ; ESP può muoversi (push/pop), EBP resta fisso
```

### Epilogo

```asm
    mov  esp, ebp     ; dealloca le variabili locali (ripristina ESP)
    pop  ebp          ; ripristina EBP del chiamante
    ret               ; legge l'indirizzo di ritorno dallo stack e ci salta
```

---

## 5.6 Esempio completo: chiamata a una funzione

Supponiamo di voler chiamare una funzione `somma(a, b)` che restituisce `a + b`.

### Codice del chiamante

```asm
    ; 1. Salva EAX/ECX/EDX se li stai usando (caller-saved)
    push ecx

    ; 2. Spingi i parametri in ordine INVERSO (ultimo prima)
    push 5          ; secondo parametro: b = 5
    push 3          ; primo parametro:  a = 3

    ; 3. Chiama la funzione
    call somma      ; EIP viene salvato sullo stack, poi si salta a 'somma'

    ; 4. Ripristina lo stack (rimuove i 2 parametri = 8 byte)
    add esp, 8

    ; 5. Il risultato è in EAX  (8 in questo caso)
    ; 6. Ripristina i registri salvati
    pop ecx
```

### Codice della funzione somma

```asm
somma:
    ; === PROLOGO ===
    push ebp
    mov  ebp, esp

    ; === CORPO ===
    mov eax, [ebp + 8]   ; EAX = primo parametro  (a = 3)
    mov ecx, [ebp + 12]  ; ECX = secondo parametro (b = 5)
    add eax, ecx         ; EAX = a + b = 8

    ; === EPILOGO ===
    mov  esp, ebp
    pop  ebp
    ret                  ; ritorna al chiamante, EAX = 8
```

### Traccia dello stack durante l'esecuzione

```
Stato   │  ESP punta a  │  Cosa c'è allo stack (crescente dall'alto verso il basso)
────────┼───────────────┼──────────────────────────────────────────────────────────
start   │ 0x1010        │ (frame del main)
push 5  │ 0x100C        │ [0x100C] = 5
push 3  │ 0x1008        │ [0x1008] = 3
call    │ 0x1004        │ [0x1004] = indirizzo di ritorno, [0x1008]=3, [0x100C]=5
push ebp│ 0x1000        │ [0x1000] = EBP vecchio
(body)  │
EBP+8   =  0x1008       = primo parametro (3)
EBP+12  =  0x100C       = secondo parametro (5)
```

---

## 5.7 Esercizi di consolidamento

1. Disegna il layout dello stack durante la chiamata `fattoriale(4)` (funzione ricorsiva). Quanti frame si creano?

2. Perché la funzione usa EBP come punto di riferimento invece di ESP per accedere ai parametri?

3. Dopo `push eax; push ebx; push ecx`, cosa deve fare la funzione per tornare allo stato originale dello stack?

4. Se una funzione ha 3 parametri da 4 byte e 2 variabili locali da 4 byte, di quanto viene decrementato ESP nel prologo?

5. Cosa succede se ci si dimentica di fare `add esp, N` dopo una `call` con N byte di parametri? (Pensa a cosa succede alla prossima `call` o `ret`...)
