# Test — Lezione 3: Memoria e Modalità di Indirizzamento

> **Istruzioni:** Il test include domande a risposta multipla, analisi di codice Assembly
> e domande a risposta aperta. Tempo consigliato: 30 minuti.

---

## Parte A — Domande a risposta multipla

**1.** In x86-32, gli indirizzi di memoria sono numeri a quanti bit?

- a) 8
- b) 16
- c) 32
- d) 64

---

**2.** L'architettura x86 memorizza i valori multi-byte secondo la convenzione:

- a) Big-endian (byte più significativo al primo indirizzo)
- b) Little-endian (byte meno significativo al primo indirizzo)
- c) Middle-endian (byte centrale per primo)
- d) Dipende dall'istruzione usata

---

**3.** Il valore `0xAABBCCDD` viene salvato a partire dall'indirizzo `0x1000`. Cosa trovi all'indirizzo `0x1000`?

- a) `0xAA`
- b) `0xBB`
- c) `0xCC`
- d) `0xDD`

---

**4.** In MASM, quale direttiva si usa per dichiarare un intero 32-bit?

- a) `BYTE`
- b) `WORD`
- c) `DWORD`
- d) `QWORD`

---

**5.** Consideriamo il seguente codice MASM. Cosa fa `buffer BYTE 100 DUP(0)`?

- a) Dichiara una variabile da 100 DWORD tutte a zero
- b) Dichiara un array di 100 byte tutti inizializzati a 0
- c) Dichiara un buffer di 100 bit
- d) Dichiara 100 variabili indipendenti

---

**6.** Quale delle seguenti istruzioni carica il **valore** della variabile `x` in EAX?

```asm
.DATA
    x DWORD 42
```

- a) `mov eax, x`
- b) `mov eax, [x]`
- c) `mov eax, &x`
- d) `lea eax, x`

---

**7.** Cosa carica nel registro EAX l'istruzione `mov eax, x` (senza parentesi quadre)?

- a) Il valore contenuto in `x`
- b) L'indirizzo di memoria della variabile `x`
- c) Il tipo di dato di `x`
- d) Genera un errore di sintassi

---

**8.** Quale modalità di indirizzamento usa l'istruzione `mov eax, [ebx + ecx*4]`?

- a) Immediata
- b) A registro
- c) Diretta a memoria
- d) Base + indice con scala

---

**9.** Cosa fa `BYTE PTR` nell'istruzione `mov BYTE PTR [ebx], 5`?

- a) Specifica che si scrivono 4 byte
- b) Converte il 5 in un carattere ASCII
- c) Specifica che si scrive solo 1 byte all'indirizzo in EBX
- d) Indica che EBX punta a una stringa ASCII

---

**10.** Qual è la differenza tra `movzx eax, BYTE PTR [ebx]` e `movsx eax, BYTE PTR [ebx]`?

- a) `movzx` è per numeri senza segno (estende con zeri), `movsx` per numeri con segno (preserve il segno)
- b) `movzx` legge dalla memoria, `movsx` legge dai registri
- c) Non c'è nessuna differenza, sono alias
- d) `movzx` legge 2 byte, `movsx` legge 1 byte

---

## Parte B — Analisi e scrittura di codice

**11.** Scrivi le dichiarazioni MASM per i seguenti dati nella sezione `.DATA`:

- Un intero `eta` con valore `18`
- Un array `voti` di 10 DWORD tutti inizializzati a 0
- Una stringa `nome` con il testo `"Mario"` terminata da zero

```asm
.DATA
    ; scrivi qui le dichiarazioni



```

---

**12.** Il valore `0x12345678` viene salvato in memoria all'indirizzo `0x2000`.  
Completa la tabella indicando il byte presente a ciascun indirizzo (litte-endian!):

| Indirizzo | Contenuto |
|-----------|-----------|
| 0x2000    | ___       |
| 0x2001    | ___       |
| 0x2002    | ___       |
| 0x2003    | ___       |

---

**13.** Scrivi una singola istruzione Assembly che legge il **quarto elemento** (indice 3) di un array di DWORD puntato da ESI e lo carica in EAX.

```asm
; Scrivi l'istruzione:

```

---

**14.** Indica per ciascuna istruzione il tipo di indirizzamento usato:

| Istruzione | Tipo di indirizzamento |
|-----------|----------------------|
| `mov eax, 100` | ___ |
| `mov eax, ebx` | ___ |
| `mov eax, [var]` | ___ |
| `mov eax, [esi]` | ___ |
| `mov eax, [ebp + 8]` | ___ |
| `mov eax, [esi + ecx*4]` | ___ |

---

## Parte C — Domande a risposta aperta

**15.** *(4 punti)* Spiega con parole tue cosa significa che l'architettura x86 è **little-endian**. Fai un esempio concreto con un valore a tua scelta.

> *Risposta:*
>
>
>

---

**16.** *(3 punti)* Un tuo collega scrive:
```asm
.DATA
    x DWORD 10
.CODE
    mov eax, x    ; vuole caricare 10 in EAX
```
Spiega qual è l'errore e come correggerlo.

> *Risposta:*
>
>
>

---

**17.** *(3 punti)* Spiega quando è necessario usare le **direttive di dimensione** (`BYTE PTR`, `WORD PTR`, `DWORD PTR`) e fai un esempio concreto.

> *Risposta:*
>
>
>

---

## Griglia di valutazione

| Sezione | Punti disponibili |
|---------|-----------------|
| Parte A (10 domande × 1 punto) | 10 |
| Parte B (4 esercizi × 2 punti) | 8 |
| Parte C (3 domande aperte) | 10 |
| **Totale** | **28** |

> Sufficienza: 17/28
