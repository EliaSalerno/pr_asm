# Lezione 1 — Architettura del Computer e Introduzione all'Assembly

## 1.1 Perché studiare Assembly?

Prima di scrivere codice Assembly, è importante capire **perché** esiste e quando ha senso usarlo.

I linguaggi di programmazione moderni come C#, Python o Java si trovano a livelli di astrazione molto alti: il programmatore non sa (e non deve sapere) come vengono gestiti i registri del processore, dove finiscono le variabili in memoria, o quanti clock cicli impiega un'operazione.

L'Assembly rompe questa astrazione. Programmare in Assembly significa **dialogare direttamente con la CPU**, senza intermediari.

**Perché è utile conoscerlo?**
- Capire come funziona davvero un computer (non solo "a scatola chiusa")
- Leggere e analizzare codice compilato (debugging, reverse engineering)
- Ottimizzare parti critiche di un programma (es. codec audio/video, crittografia)
- Comprendere vulnerabilità di sicurezza (buffer overflow, stack smashing)
- Base fondamentale per sistemi operativi, driver e firmware

---

## 1.2 Il modello di von Neumann

Tutti i computer moderni si basano sull'**architettura di von Neumann** (1945), che prevede:

```
┌─────────────────────────────────────────────────────────┐
│                    COMPUTER                             │
│                                                         │
│   ┌──────────┐     Bus dati/indirizzi     ┌──────────┐  │
│   │   CPU    │ ←────────────────────────→ │ MEMORIA  │  │
│   │          │                            │  (RAM)   │  │
│   │ - ALU    │                            │          │  │
│   │ - CU     │                            │ Programma│  │
│   │ - Reg.   │                            │  + Dati  │  │
│   └──────────┘                            └──────────┘  │
│        ↑                                                │
│        │ Bus I/O                                        │
│        ↓                                                │
│   ┌───────────┐                                         │
│   │Periferiche│ (tastiera, schermo, disco...)           │
│   └───────────┘                                         │
└─────────────────────────────────────────────────────────┘
```

Il punto chiave: **programma e dati sono entrambi in memoria** e la CPU li legge dalla stessa RAM (a differenza dell'architettura Harvard, usata in alcuni microcontrollori).

---

## 1.3 Il processore x86

L'architettura **x86** nasce con l'Intel 8086 nel 1978. Con il termine "x86" si indica tutta la famiglia di processori Intel/AMD a 16, 32 e 64 bit che mantengono **compatibilità all'indietro** con quell'architettura originale.

In questo corso lavoriamo con la versione **32-bit (IA-32)**, chiamata anche **x86-32**, perché:
- È più semplice da comprendere rispetto al 64-bit
- Usa MASM (Microsoft Macro Assembler) con sintassi Intel
- Permette di capire i concetti fondamentali applicabili anche al 64-bit

### Versioni storiche (panoramica)

| Anno | Processore | Bit | Novità principale |
|------|-----------|-----|------------------|
| 1978 | Intel 8086 | **16-bit** | Nascita dell'architettura x86, memoria segmentata (1 MB) |
| 1982 | Intel 80286 | 16-bit | Modalità protetta, indirizza fino a 16 MB |
| 1985 | Intel 80386 | **32-bit** | IA-32, flat memory model, 4 GB di RAM indirizzabili |
| 1989 | Intel 80486 | 32-bit | FPU integrata, cache L1, pipeline a 5 stadi |
| 1993 | Intel Pentium | 32-bit | Superpipeline dual, bus dati a 64 bit |
| 1997 | Intel Pentium II/III | 32-bit | Estensioni MMX e SSE (SIMD) |
| 2003 | AMD Athlon 64 | **64-bit** | Nasce x86-64 (AMD64): 64-bit mantenendo compatibilità IA-32 |
| oggi | Intel Core, AMD Ryzen | 64-bit | Multicore, cache L1/L2/L3, AVX-512 |

> **Approfondimento:** per una trattazione completa delle differenze tra le generazioni,
> le modalità operative (Real/Protected/Long Mode) e il glossario delle sigle
> (IA-32, x86-64, AMD64, EM64T, IA-64…) consulta il file dedicato:
> [`approfondimento_architetture_x86.md`](approfondimento_architetture_x86.md)

---

## 1.4 Il ciclo Fetch-Decode-Execute

La CPU esegue il programma seguendo un ciclo continuo:

```
     ┌────────────────────────────────────────────┐
     │                                            │
     ▼                                            │
┌─────────┐      ┌─────────┐      ┌─────────┐     │
│  FETCH  │ ───→ │ DECODE  │ ───→ │EXECUTE  │ ────┘
│         │      │         │      │         │
│ Legge   │      │ Capisce │      │ Esegue  │
│l'istruz.│      │cosa fare│      │l'operaz.│
│dalla RAM│      │         │      │         │
└─────────┘      └─────────┘      └─────────┘
     ↑
     │
  EIP (Instruction Pointer) punta all'istruzione successiva
```

1. **FETCH**: la CPU legge dalla RAM l'istruzione all'indirizzo contenuto in EIP  
2. **DECODE**: la CPU decodifica i byte letti e capisce l'operazione da fare  
3. **EXECUTE**: la CPU esegue l'operazione (somma, copia, salto, ecc.)  
4. **EIP** viene aggiornato → si ricomincia dal punto 1

---

## 1.5 Rappresentazione dei dati

Tutto in un computer è rappresentato in **binario** (0 e 1). Conoscere le basi numeriche è essenziale per leggere e scrivere codice Assembly.

### Sistemi numerici fondamentali

| Sistema | Base | Cifre usate | Prefisso MASM |
|---------|------|-------------|---------------|
| Decimale | 10 | 0-9 | nessuno (es. `42`) |
| Binario | 2 | 0, 1 | `B` finale (es. `101010B`) |
| Esadecimale | 16 | 0-9, A-F | `0x` o `H` finale (es. `0x2A` o `2AH`) |

### Conversione rapida

```
Decimale 42:
  42 ÷ 2 = 21 resto 0
  21 ÷ 2 = 10 resto 1
  10 ÷ 2 =  5 resto 0
   5 ÷ 2 =  2 resto 1
   2 ÷ 2 =  1 resto 0
   1 ÷ 2 =  0 resto 1
   → Binario: 101010B
   → Esadecimale: 2AH (2×16 + 10 = 42) ✓
```

### Unità di misura della memoria

| Unità | Abbreviazione | Dimensione |
|-------|--------------|------------|
| Bit | b | 1 cifra binaria (0 o 1) |
| Nibble | - | 4 bit = 1 cifra esadecimale |
| **Byte** | B | **8 bit** → valori 0-255 |
| Word | W | 16 bit = 2 byte |
| **Double Word** | **DWORD** | **32 bit = 4 byte** ← la più usata in x86-32 |
| Quad Word | QWORD | 64 bit = 8 byte |

> In x86-32, la dimensione nativa è la **DWORD (32 bit)**. La maggior parte delle operazioni lavora su valori a 32 bit.

---

## 1.6 Esercizi di consolidamento

1. Converti in esadecimale e binario: 255, 128, 16, 1024
2. Converti da esadecimale a decimale: `FFH`, `1AH`, `80H`, `100H`
3. Quanti valori distinti può rappresentare un byte? E una DWORD?
4. Se un processore ha un bus indirizzi a 32 bit, quanta RAM può indirizzare al massimo? (esprimi in GB)
