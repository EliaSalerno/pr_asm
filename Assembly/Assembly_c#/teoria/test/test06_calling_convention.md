# Test — Lezione 6: Calling Convention e Interfacciamento con C#

> **Istruzioni:** Il test include domande a risposta multipla, scrittura di codice Assembly
> e C# (P/Invoke), e domande di analisi. Tempo consigliato: 35 minuti.

---

## Parte A — Domande a risposta multipla

**1.** Il termine "calling convention" indica:

- a) La sintassi per scrivere commenti in Assembly
- b) L'accordo su come caller e callee si passano parametri, gestiscono lo stack e il valore di ritorno
- c) Il nome che deve avere una funzione Assembly esportata
- d) Il tipo di compilatore da usare per l'Assembly

---

**2.** Nella calling convention **cdecl** (quella usata in questo corso), chi è responsabile di ripulire lo stack dopo una chiamata?

- a) La funzione chiamata (callee) con un `ret N`
- b) Il sistema operativo
- c) Il compilatore automaticamente
- d) Il chiamante (caller) con `add esp, N`

---

**3.** Dove viene restituito il valore di ritorno di una funzione Assembly (interi 32-bit)?

- a) In EBX
- b) In ECX
- c) In EAX
- d) Sullo stack

---

**4.** Quale dei seguenti registri deve essere **preservato** dalla funzione chiamata (callee-saved)?

- a) EAX
- b) ECX
- c) EDX
- d) ESI

---

**5.** In quale ordine vengono pushati i parametri sullo stack con la cdecl?

- a) Dal primo all'ultimo
- b) Dall'ultimo al primo (ordine inverso)
- c) In ordine casuale
- d) Non vengono passati sullo stack, ma nei registri

---

**6.** In MASM, quale parola chiave rende una funzione **visibile all'esterno** della DLL?

- a) `EXPORT`
- b) `EXTERN`
- c) `PUBLIC`
- d) `GLOBAL`

---

**7.** Perché i nomi delle funzioni Assembly esportate in Win32 a 32 bit devono avere il **prefisso `_`** (underscore)?

- a) È un requisito del linker MASM
- b) È la convenzione cdecl su Windows a 32 bit che aggiunge questo prefisso ai simboli C
- c) Il prefisso `_` indica che la funzione è privata
- d) Senza `_` la funzione non compila

---

**8.** Il parametro corrispondente a `[ebp + 12]` è:

- a) Il primo parametro
- b) Il secondo parametro
- c) Una variabile locale
- d) L'indirizzo di ritorno

---

**9.** In C#, quale meccanismo permette di chiamare funzioni native (Assembly/C) da una DLL?

- a) COM Interop
- b) P/Invoke (Platform Invocation Services)
- c) Reflection
- d) Unsafe code con puntatori

---

**10.** Quale attributo C# si usa per dichiarare una funzione importata da una DLL?

- a) `[Import("dll")]`
- b) `[NativeFunction("dll")]`
- c) `[DllImport("dll")]`
- d) `[ExternalFunction("dll")]`

---

**11.** In una dichiarazione `[DllImport]` per una funzione Assembly cdecl, quale `CallingConvention` va specificata?

- a) `CallingConvention.StdCall`
- b) `CallingConvention.Cdecl`
- c) `CallingConvention.ThisCall`
- d) `CallingConvention.WinAPI`

---

**12.** Una funzione Assembly con **2 parametri interi da 4 byte** viene chiamata in cdecl. Quanti byte deve rimuovere il chiamante dallo stack con `add esp`?

- a) 2
- b) 4
- c) 8
- d) 16

---

## Parte B — Scrittura di codice

**13.** Scrivi lo **scheletro completo** di una funzione Assembly `_Prodotto` che:
- Riceve due parametri interi `a` e `b`
- Calcola `a * b`
- Ritorna il risultato in EAX
- Segue la calling convention cdecl

```asm
.486
.MODEL FLAT, C
.CODE

PUBLIC _Prodotto

_Prodotto PROC
    ; Scrivi il codice completo:
    ; Prologo


    ; Corpo


    ; Epilogo


_Prodotto ENDP

END
```

---

**14.** Scrivi la **dichiarazione C# completa** per importare la funzione Assembly `_Massimo` dalla DLL `utilita.dll`. La funzione prende due `int` e restituisce un `int`.

```csharp
// Scrivi qui la dichiarazione:

```

---

**15.** Considera questa funzione Assembly con **un errore**. Identificalo e spiega cosa succede a runtime:

```asm
.486
.MODEL FLAT, C
.CODE

PUBLIC _Raddoppia

; int Raddoppia(int x) → ritorna x * 2
_Raddoppia PROC
    push ebp
    mov  ebp, esp

    mov  eax, [ebp + 8]   ; carica x
    add  eax, eax          ; x * 2

    pop  ebp
    ret
_Raddoppia ENDP

END
```

Correzione lato C# — il chiamante usa:
```csharp
[DllImport("calcola.dll", CallingConvention = CallingConvention.StdCall)]
static extern int Raddoppia(int x);
```

> *Qual è l'errore? Come si corregge?*
>
>
>

---

**16.** Completa la tabella di corrispondenza tra tipi C# e Assembly:

| Tipo C# | Tipo Assembly | Dimensione |
|---------|--------------|-----------|
| `int`   | ___          | ___ byte  |
| `short` | ___          | ___ byte  |
| `byte`  | ___          | ___ byte  |
| `uint`  | ___          | ___ byte  |

---

## Parte C — Domande a risposta aperta

**17.** *(4 punti)* Spiega cosa fa il **prologo** di una funzione Assembly e perché è necessario. Poi descrivi le operazioni simmetriche dell'**epilogo**.

> *Risposta:*
>
>
>

---

**18.** *(3 punti)* La differenza tra `cdecl` e `stdcall` è chi pulisce lo stack. Descrivi i **vantaggi** del lasciare la pulizia al chiamante (cdecl) — pensa ad esempio alle funzioni con numero variabile di argomenti come `printf`.

> *Risposta:*
>
>
>

---

**19.** *(3 punti)* Immagina di avere una funzione Assembly con **3 parametri** e **2 variabili locali** (tutte DWORD).
- A quali offset da EBP si trovano i parametri?
- A quali offset si trovano le variabili locali?
- Di quanto viene decrementato ESP nel prologo per le variabili locali?

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
