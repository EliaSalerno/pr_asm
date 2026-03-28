# Approfondimento — La sigla x86: storia e architetture a confronto

## Perché si chiama "x86"?

La sigla **x86** è nata per convenzione: i primi processori Intel della famiglia si chiamavano
**8086, 80186, 80286, 80386, 80486**. Tutti finivano in "86", e il prefisso diventò
il nome collettivo dell'intera famiglia. Oggi con "x86" si indica qualsiasi processore
che esegue quel set di istruzioni, compresi quelli a 64 bit.

> La "x" è semplicemente un jolly: sta per "qualunque prefisso della famiglia" (8, 80, i, AMD…)

---

## Le generazioni storiche

### 1 Intel 8086 / 8088 (1978–1979) — 16 bit

| Caratteristica | Valore |
|----------------|--------|
| Architettura | **16-bit** |
| Bus dati | 16 bit (8088: solo 8 bit esternamente) |
| Bus indirizzi | 20 bit |
| RAM indirizzabile | 1 MB (2²⁰) |
| Registri GP | AX, BX, CX, DX, SI, DI, SP, BP (tutti a 16 bit) |
| Segmentazione | Sì — CS, DS, SS, ES |
| Usato in | IBM PC originale (1981) |

```
Registro AX a 16 bit:
┌────────┬────────┐
│   AH   │   AL   │
│ 8 bit  │ 8 bit  │
└────────┴────────┘
```

**La segmentazione:** il bus degli indirizzi era a 20 bit, ma i registri erano a 16 bit.
Per risolvere questo problema, l'indirizzo fisico veniva calcolato come:

```
Indirizzo fisico = Segmento × 16 + Offset
Esempio: CS = 0x1000, IP = 0x0200
→ 0x1000 × 16 = 0x10000
   0x10000 + 0x0200 = 0x10200
```

Questo modello di memoria segmentato era complesso e limitante.

---

### 2 Intel 80286 (1982) — 16 bit con modalità protetta

| Caratteristica | Valore |
|----------------|--------|
| Architettura | 16-bit |
| Bus indirizzi | 24 bit |
| RAM indirizzabile | 16 MB (2²⁴) |
| Novità principale | **Protected Mode** (modalità protetta) |
| Usato in | IBM PC/AT |

Il 286 introduceva la **modalità protetta**: i programmi non potevano più accedere
direttamente a tutta la memoria, e il processore poteva proteggere le aree del sistema
operativo dagli accessi non autorizzati. Base dei moderni sistemi multitasking.

**Problema:** era impossibile tornare dalla modalità protetta a quella reale senza riavviare il PC!

---

### 3 Intel 80386 (1985) — ⭐ Nascita del x86-32 (IA-32)

| Caratteristica | Valore |
|----------------|--------|
| Architettura | **32-bit** ← rivoluzione! |
| Bus indirizzi | 32 bit |
| RAM indirizzabile | **4 GB** (2³²) |
| Nuovi registri | EAX, EBX, ECX, EDX, ESI, EDI, ESP, EBP (tutti a 32 bit) |
| Modalità | Real mode, Protected mode, **Virtual 8086 mode** |
| Segmentazione | Mantenuta ma facoltativa (flat memory model) |
| Usato in | Prime workstation UNIX, Windows 3.x |

```
Registro EAX a 32 bit (novità del 386!):
┌──────────────┬────────┬────────┐
│   parte alta │   AH   │   AL   │
│    16 bit    │  8 bit │  8 bit │
└──────────────┴────────┴────────┘
│◄────────────── EAX = 32 bit ──────────────────►│
                │◄───── AX = 16 bit ─────►│
```

**Flat Memory Model:** il 386 permetteva di usare un unico segmento da 4 GB,
eliminando di fatto la complessità della segmentazione. Questo è il modello che usiamo
in questo corso (`.MODEL FLAT` in MASM).

---

### 4 Intel 80486 (1989) — x86-32 maturo

| Caratteristica | Valore |
|----------------|--------|
| Architettura | 32-bit |
| Novità | **FPU integrata** (virgola mobile), cache L1 integrata, pipeline a 5 stadi |
| Clock | 25–100 MHz |

Prima del 486, la FPU (Floating Point Unit, per i calcoli con virgola mobile) era
un chip separato opzionale (il coprocessore 80387). Il 486 la integra direttamente nel die.

---

### 5 Intel Pentium e famiglia (1993–2000) — x86-32 ad alte prestazioni

| Processore | Anno | Novità principale |
|-----------|------|------------------|
| Pentium | 1993 | Bus dati a 64 bit (internamente), superpipeline, due pipeline parallele |
| Pentium Pro | 1995 | Architettura P6, esecuzione fuori ordine |
| Pentium II/III | 1997–1999 | Istruzioni **MMX** e **SSE** (SIMD per multimedia) |
| Pentium 4 | 2000 | Hyper-threading, NetBurst (pipeline lunghissima) |

**SIMD (Single Instruction, Multiple Data):** istruzioni speciali che elaborano
più dati contemporaneamente (es. sommare 4 float in parallelo con una sola istruzione SSE).
Non sono nel programma standard, ma utili da conoscere.

---

### 6 AMD Athlon 64 / Intel EM64T (2003) — ⭐ Nascita di x86-64 (AMD64)

| Caratteristica | Valore |
|----------------|--------|
| Architettura | **64-bit** |
| Estensione proposta da | **AMD** (non Intel questa volta!) |
| Nomi alternativi | **x86-64**, **AMD64**, **Intel 64**, **EM64T** |
| Bus indirizzi | 48 bit effettivi (teorico: 64) |
| RAM indirizzabile | Attualmente ~256 TB |
| Nuovi registri | RAX, RBX…(64 bit), + R8..R15 (8 nuovi registri) |
| Compatibilità | Esegue anche codice x86-32! |

```
Registro RAX a 64 bit (x86-64):
┌────────────────────────────────┬──────────────┬────────┬────────┐
│         parte alta             │              │   AH   │   AL   │
│            32 bit              │   16 bit     │  8 bit │  8 bit │
└────────────────────────────────┴──────────────┴────────┴────────┘
│◄──────────────────── RAX = 64 bit ─────────────────────────────►│
                │◄────────── EAX = 32 bit ────────────►│
                                │◄── AX = 16 bit ──►│
```

> **Curioso:** fu AMD a proporre l'estensione a 64-bit, non Intel! Intel stava puntando
> su un'architettura completamente diversa e incompatibile (Itanium/IA-64), ma il mercato
> scelse l'approccio compatibile di AMD. Intel fu costretta ad adottarla (la chiamò EM64T,
> poi "Intel 64").

---

## Lo schema generale delle architetture

```
                      FAMIGLIA x86
                           │
           ┌───────────────┼───────────────┐
           │               │               │
        16-bit           32-bit          64-bit
      (Real Mode)         (IA-32)       (x86-64)
           │               │               │
     8086, 8088       80386, 80486    Athlon 64,
     80186, 80286     Pentium I/II    Core 2, i3/5/7
                      Pentium III     Ryzen, ecc.
                      Pentium 4
                           │
                    (base del corso)
```

---

## Nomi alternativi — Glossario

| Sigla | Significato | Quando si usa |
|-------|------------|---------------|
| **x86** | Famiglia Intel 8086 e successori | Termine generico per tutta la famiglia |
| **x86-16** | Subset a 16 bit | Codice per 8086/286, DOS |
| **IA-32** | Intel Architecture 32-bit | Nome ufficiale Intel per il 32-bit |
| **x86-32** | x86 a 32 bit | Equivalente a IA-32, più diffuso |
| **x86-64** | Estensione 64-bit di x86 | Nome tecnico standard |
| **AMD64** | Nome originale AMD per x86-64 | Nei compilatori (es. gcc -march=x86-64) |
| **Intel 64** / **EM64T** | Implementazione Intel di x86-64 | Documentazione Intel |
| **IA-64** | Intel Architecture 64-bit | ⚠️ **Itanium** — DIVERSO da x86-64! Incompatibile! |

> **Errore comune:** IA-64 **NON** è x86-64! IA-64 è l'architettura Itanium,
> completamente incompatibile con x86, che Intel ha abbandonato nel 2021.

---

## Modalità operative del processore

Un processore x86 moderno può operare in diverse **modalità**:

```
Accensione del PC
       │
       ▼
┌─────────────────┐
│  Real Mode      │ ← 16-bit, accesso diretto alla RAM (come 8086)
│  (Modalità Reale│   BIOS e bootloader operano qui
└────────┬────────┘
         │ il S.O. attiva la modalità protetta
         ▼
┌─────────────────┐
│ Protected Mode  │ ← 32-bit (IA-32), memoria virtuale, ring di protezione
│ (Mod. Protetta) │   Windows/Linux x86 classici operano qui
└────────┬────────┘
         │ su CPU a 64-bit, il S.O. può entrare in long mode
         ▼
┌─────────────────┐
│   Long Mode     │ ← 64-bit (x86-64), modalità di Windows/Linux moderni
│   (64-bit)      │   Contiene una "sottomodalità" compatibility mode per
└─────────────────┘   eseguire programmi a 32-bit
```

**In questo corso lavoriamo sempre in Protected Mode a 32-bit** (IA-32),
la modalità più didatticamente chiara e quella di riferimento del sito
[cs.virginia.edu/evans/cs216](https://www.cs.virginia.edu/~evans/cs216/guides/x86.html).

---

## Perché studiamo x86-32 invece di x86-64?

| Aspetto | x86-32 (IA-32) | x86-64 (AMD64) |
|---------|---------------|---------------|
| Registro principale | EAX (32 bit) | RAX (64 bit) |
| Registri GP | 8 | **16** (R8..R15 aggiuntivi) |
| Calling convention | **cdecl**: parametri sullo stack | **fastcall**: primi 4 param. in RCX/RDX/R8/R9 |
| Complessità | ★★☆☆☆ | ★★★★☆ |
| Chiarezza didattica | Ottima (stack chiaramente visibile) | Più complessa (param. nei registri) |
| Uso pratico | Legacy, microcontrollori, DLL Windows | **Tutto il software moderno** |

Il 32-bit è il punto di partenza perfetto perché la gestione dei parametri sullo stack
è visibile e comprensibile. Una volta capito il 32-bit, il passaggio al 64-bit
è molto più agevole.

---

## Esercizi di approfondimento

1. Cerca su Wikipedia la pagina "x86" e confronta la timeline dei processori con quella presentata qui.
2. Come si calcola l'indirizzo fisico in Real Mode con CS=0x2000 e IP=0x0150?
3. Perché il Pentium usava un bus dati a 64 bit ma era comunque considerato "32-bit"? (Suggerimento: pensa alla differenza tra bus dati e width dell'ALU)
4. Quanta RAM può indirizzare un sistema x86-64 con bus indirizzi a 48 bit? (calcola 2⁴⁸ in GB)
5. Cerca il significato di "ring 0" e "ring 3" nella modalità protetta x86. Qual è la differenza tra codice kernel e codice utente?
