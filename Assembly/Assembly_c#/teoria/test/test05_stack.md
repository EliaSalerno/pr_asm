# Test — Lezione 5: Lo Stack e la Gestione delle Chiamate

> **Istruzioni:** Il test include domande a risposta multipla, disegni del layout dello stack
> e domande di analisi. Tempo consigliato: 35 minuti.

---

## Parte A — Domande a risposta multipla

**1.** Lo stack segue la politica:

- a) FIFO — First In, First Out
- b) LIFO — Last In, First Out
- c) Random Access
- d) Round Robin

---

**2.** In quale direzione cresce lo stack nell'architettura x86?

- a) Verso l'alto (gli indirizzi aumentano)
- b) Verso il basso (gli indirizzi diminuiscono)
- c) In entrambe le direzioni a seconda del sistema operativo
- d) Non ha una direzione fissa

---

**3.** Quale registro punta sempre alla **cima corrente** dello stack?

- a) EBP
- b) EDI
- c) ESP
- d) EIP

---

**4.** Dopo `push eax`, cosa succede al valore di ESP (assumendo ESP inizialmente = `0x1000`)?

- a) ESP = `0x1004`
- b) ESP = `0x1000` (invariato)
- c) ESP = `0x0FFC`
- d) ESP = `0x0FF8`

---

**5.** L'istruzione `pop ebx` è equivalente a:

- a) `mov ebx, [esp]; add esp, 4`
- b) `sub esp, 4; mov ebx, [esp]`
- c) `mov ebx, esp; add esp, 4`
- d) `mov [esp], ebx; add esp, 4`

---

**6.** All'interno di una funzione, dopo il prologo `push ebp; mov ebp, esp`, a quale offset rispetto a EBP si trova il **primo parametro**?

- a) `[ebp - 4]`
- b) `[ebp + 4]`
- c) `[ebp + 8]`
- d) `[ebp + 12]`

---

**7.** Cosa viene scritto sullo stack quando la CPU esegue l'istruzione `call mia_funzione`?

- a) Il valore di EBP
- b) Il valore di EAX
- c) L'indirizzo dell'istruzione successiva a `call` (indirizzo di ritorno)
- d) Il valore di tutti i registri

---

**8.** Cosa fa `ret` nella funzione chiamata?

- a) Azzera ESP e torna al main
- b) Legge l'indirizzo di ritorno dallo stack e ci salta (e incrementa ESP di 4)
- c) Ripristina EBP e poi salta al chiamante
- d) Salva EAX e termina la funzione

---

**9.** Considera questa funzione con prologo e corpo. Quanti byte deve sottrarre `sub esp, N` per allocare **3 variabili locali** da 4 byte?

- a) 3
- b) 8
- c) 12
- d) 16

---

**10.** Guardando il layout dello stack standard, in quale regione della memoria si trovano i **dati globali** (sezione `.DATA`)?

- a) Nella stessa area dello stack
- b) Nell'heap, sopra lo stack
- c) In una sezione separata con indirizzi bassi, sotto l'heap
- d) All'interno di ogni stack frame

---

**11.** In quale ordine devono essere pushati i parametri quando si chiama una funzione con calling convention cdecl?

- a) Dal primo all'ultimo (ordine normale)
- b) Dall'ultimo al primo (ordine inverso)
- c) In ordine alfabetico
- d) Non importa l'ordine

---

**12.** Cosa succede se ci si dimentica di eseguire `add esp, 8` dopo una `call` a una funzione con 2 parametri interi (cdecl)?

- a) Non succede nulla, ESP si ripristina automaticamente
- b) Lo stack rimane "sporco": il puntatore punta alla posizione sbagliata, causando comportamenti errati alle chiamate successive
- c) Si genera un'eccezione immediata
- d) La funzione viene rieseguita

---

## Parte B — Disegno e analisi dello stack

**13.** Supponiamo di chiamare `somma(3, 7)`. Lo stack prima della chiamata ha ESP = `0x1020`.

Completa il diagramma indicando cosa si trova a ciascun indirizzo DOPO il prologo della funzione (`push ebp; mov ebp, esp`), assumendo che il chiamante abbia pushato i parametri e poi eseguito `call`:

```
Indirizzo  | Contenuto          | Descrizione
-----------|--------------------|------------------------------------------
0x1010     | ___                | ___ (EBP-4 della funzione, allocato dopo)
           |                    |
0x1014     | ← EBP punta qui   | ___
           |                    |
0x1018     | ___                | ___
           |                    |
0x101C     | ___                | ___
           |                    |
0x1020     | (frame chiamante)  |
```

*(Suggerimento: pensa all'ordine — parametri, indirizzo di ritorno, EBP salvato)*

---

**14.** Il seguente codice implementa la funzione `moltiplica(a, b)` ma ha un **bug nel prologo/epilogo**. Individua e correggi l'errore:

```asm
moltiplica PROC
    ; prologo
    push ebp
    mov  ebp, esp

    ; corpo
    mov  eax, [ebp + 8]   ; a
    imul eax, [ebp + 12]  ; a * b → EAX

    ; epilogo (con bug!)
    pop  ebp
    mov  esp, ebp         ; ← BUG: questo è nell'ordine sbagliato!
    ret
moltiplica ENDP
```

> *Spiega il bug e scrivi la versione corretta dell'epilogo:*
>
>
>

---

**15.** Considera una funzione ricorsiva `fattoriale(n)` chiamata inizialmente con `n = 3`.  
Quanti **stack frame** vengono creati in totale? Elenca per ciascuno i parametri presenti.

> *Risposta:*
>
>
>

---

## Parte C — Domande a risposta aperta

**16.** *(4 punti)* Spiega perché nelle funzioni Assembly si usa **EBP** come punto di riferimento fisso per accedere ai parametri e alle variabili locali, invece di usare direttamente ESP.

> *Risposta:*
>
>
>

---

**17.** *(3 punti)* Spiega perché lo stack cresce verso il basso (verso indirizzi più bassi) e non verso l'alto. Che problema si eviterebbe così?

> *Risposta:*
>
>
>

---

**18.** *(3 punti)* Descrivi passo per passo cosa succede nello stack durante la sequenza:
```asm
push 10
push 20
call somma
add esp, 8
```
*(Considera: prima del `call`, durante il `call`, dopo il `ret`)*

> *Risposta:*
>
>
>

---

## Griglia di valutazione

| Sezione | Punti disponibili |
|---------|-----------------|
| Parte A (12 domande × 1 punto) | 12 |
| Parte B (3 esercizi / analisi × 2.5 punti) | ~8 |
| Parte C (3 domande aperte) | 10 |
| **Totale** | **30** |

> Sufficienza: 18/30
