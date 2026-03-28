# Lezione 2 — I Registri del Processore x86

## 2.1 Cos'è un registro?

Un **registro** è una piccola area di memoria interna alla CPU, estremamente veloce.
A differenza della RAM (che può contenere miliardi di byte), un processore x86-32 ha
solo **8 registri general-purpose** da 32 bit ciascuno.

**Perché i registri sono importanti?**
- Sono le uniche locazioni su cui la CPU può eseguire operazioni aritmetiche
- Accedere a un registro richiede **0 cicli di attesa** (la RAM invece è lenta!)
- Tutte le istruzioni Assembly leggono e scrivono almeno un registro

---

## 2.2 I registri general-purpose

```
         31      16 15    8 7     0
         ┌────────────┬──────┬──────┐
    EAX  │            │  AH  │  AL  │   Accumulator (accumulatore)
         ├────────────┴──────┴──────┤
         │            AX            │
         └──────────────────────────┘

         ┌────────────┬──────┬──────┐
    EBX  │            │  BH  │  BL  │   Base register
         └──────────────────────────┘

         ┌────────────┬──────┬──────┐
    ECX  │            │  CH  │  CL  │   Counter (contatore per loop)
         └──────────────────────────┘

         ┌────────────┬──────┬──────┐
    EDX  │            │  DH  │  DL  │   Data (usato nella divisione)
         └──────────────────────────┘

         ┌──────────────────────────┐
    ESI  │                          │   Source Index (indice sorgente)
         └──────────────────────────┘

         ┌──────────────────────────┐
    EDI  │                          │   Destination Index (indice dest.)
         └──────────────────────────┘

         ┌──────────────────────────┐
    ESP  │                          │   Stack Pointer ⚠️ NON modificare!
         └──────────────────────────┘

         ┌──────────────────────────┐
    EBP  │                          │   Base Pointer (frame dello stack)
         └──────────────────────────┘
```

---

## 2.3 Sottoregistri: accedere a parti di un registro

Per EAX, EBX, ECX, EDX è possibile usare **nomi alternativi** per accedere alle parti più piccole dello stesso registro fisico.

```
EAX  (32 bit = 4 byte)
├── AX   (16 bit, parte bassa di EAX)
│   ├── AL   (8 bit, byte meno significativo di AX)
│   └── AH   (8 bit, byte più significativo di AX)
```

**Esempio pratico:**
```asm
mov eax, 0         ; EAX = 0x00000000
mov al, 0FFH       ; EAX = 0x000000FF  (solo il byte basso cambia)
mov ah, 0A0H       ; EAX = 0x0000A0FF  (solo il byte alto di AX cambia)
```

> **Attenzione:** modificare AL o AH modifica automaticamente anche EAX!
> Tutti i nomi si riferiscono allo **stesso registro fisico**.

### Tabella riassuntiva

| 32-bit | 16-bit (low) | 8-bit high | 8-bit low |
|--------|-------------|-----------|----------|
| EAX | AX | AH | AL |
| EBX | BX | BH | BL |
| ECX | CX | CH | CL |
| EDX | DX | DH | DL |
| ESI | SI | — | — |
| EDI | DI | — | — |
| ESP | SP | — | — |
| EBP | BP | — | — |

---

## 2.4 Registri speciali (non general-purpose)

### EIP — Instruction Pointer
Contiene l'**indirizzo della prossima istruzione** da eseguire. Non si può modificare direttamente (solo con istruzioni di salto: `jmp`, `call`, `ret`).

### EFLAGS — Registro dei flag
Un registro a 32 bit dove ogni singolo bit rappresenta uno **stato** della CPU. I più importanti:

| Flag | Nome | Significato |
|------|------|-------------|
| **ZF** | Zero Flag | Diventa 1 se il risultato dell'ultima operazione è zero |
| **SF** | Sign Flag | Diventa 1 se il risultato è negativo |
| **CF** | Carry Flag | Diventa 1 se c'è un riporto (overflow senza segno) |
| **OF** | Overflow Flag | Diventa 1 se c'è overflow (con segno) |

Questi flag vengono letti dalle istruzioni di salto condizionale (`je`, `jl`, `jg`, ecc.).

---

## 2.5 Convenzioni d'uso dei registri

Non tutti i registri sono "uguali" nella pratica. Per le funzioni chiamate da C/C#, esistono **regole precise** (calling convention) che vedremo nella lezione 6. 

In anticipo, le nozioni di base:

| Registro | Ruolo convenzionale |
|----------|-------------------|
| EAX | Valore di ritorno di una funzione |
| ECX, EDX | Argomenti aggiuntivi (o dati temporanei) |
| EBX, ESI, EDI | Devono essere preservati dalla funzione chiamata |
| ESP | Stack pointer — mai modificare direttamente (usa PUSH/POP) |
| EBP | Base pointer — gestisce il "frame" della funzione corrente |

---

## 2.6 Visualizzare i registri in un debugger

Quando si usa il debugger (WinDbg o il debugger di Visual Studio), si può vedere il contenuto di tutti i registri in tempo reale.

```
EAX = 0000002A   EBX = 00000000   ECX = 00000001
EDX = 00000000   ESI = 00408040   EDI = 00000000
EIP = 00401000   ESP = 0018FEF4   EBP = 0018FF00
EFLAGS = 00000206  (ZF=0, SF=0, CF=0, OF=0)
```

---

## 2.7 Esercizi di consolidamento

1. Dopo `mov eax, 0x12345678`, quals è il valore di AX? Di AH? Di AL?
2. Se `AH = 0xAB` e `AL = 0xCD`, qual è il valore di EAX in esadecimale?
3. In quale registro troviamo il valore di ritorno di una funzione Assembly?
4. Cosa succede a EIP quando la CPU esegue un'istruzione `jmp`?
5. Dopo l'istruzione `sub eax, eax`, che valore ha ZF? Perché?
