# Test di Verifica — Assembly x86

Questa cartella contiene un test di verifica per ciascuna delle 6 lezioni del corso di Assembly x86.

---

## Struttura dei test

| File | Lezione | Argomenti | Punti | Tempo |
|------|---------|-----------|-------|-------|
| [test01_architettura.md](test01_architettura.md) | Lezione 1 | Architettura von Neumann, ciclo FDE, basi numeriche, DWORD | 26 | 25 min |
| [test02_registri.md](test02_registri.md) | Lezione 2 | Registri general-purpose, sottoregistri (AH/AL), flag, EIP | 28 | 30 min |
| [test03_memoria.md](test03_memoria.md) | Lezione 3 | RAM, little-endian, sezione .DATA, modalità di indirizzamento | 28 | 30 min |
| [test04_istruzioni.md](test04_istruzioni.md) | Lezione 4 | MOV, PUSH/POP, aritmetica, logica, CMP, salti, CALL/RET | 30 | 35 min |
| [test05_stack.md](test05_stack.md) | Lezione 5 | Stack LIFO, ESP/EBP, stack frame, prologo/epilogo, ricorsione | 30 | 35 min |
| [test06_calling_convention.md](test06_calling_convention.md) | Lezione 6 | cdecl, parametri, P/Invoke, DllImport, registri preservati | 30 | 35 min |
| [verifica_1.md](verifica_1.md) | 1-3 + Appr. | Test cumulativo su architettura, registri, memoria e microcodice | 35 | 45 min |

---

## Formato dei test
...
---

## Chiavi di risposta

> *(Per uso del docente — non distribuire agli studenti)*

### Verifica 1 — Soluzioni Dettagliate
**Sezione 1: Architettura e Storia**
1. **B** (Programma e dati nella stessa memoria).
2. **CISC (x86):** Istruzioni complesse/variabili, richiede micro-sequencer. **RISC (ARM):** Istruzioni semplici/fisse, spesso cablate senza micro-sequencer.
3. `Physical = 0x2000 * 16 + 0x1500` = `0x20000 + 0x1500` = **0x21500**.
4. **B** (Compatibilità x86-64 di AMD vs IA-64 di Intel).

**Sezione 2: Registri e Ciclo FDE**
5. **B** (Traduzione in micro-operazioni $\mu op$).
6. `AX = 0x5678`, `AH = 0x56`, `AL = 0x78`.
7. **ZF:** 1 se risultato zero. **SF:** 1 se risultato negativo. **CF:** 1 se riporto (unsigned).
8. **C** (EIP - Instruction Pointer).

**Sezione 3: Memoria e Indirizzamento**
9. `0x1000: 0xEF`, `0x1001: 0xBE`, `0x1002: 0xAD`, `0x1003: 0xDE`.
10. Immediato, Registro, Diretto a memoria, Base + Indice * Scala.
11. `mov eax, x` carica il valore; `mov eax, [x]` in MASM è spesso equivalente per variabili nominali, ma concettualmente `[x]` indica la dereferenziazione dell'indirizzo di x.

**Sezione 4: Pratica e Conversioni**
12. 42 = **101010b** = **2Ah**. DWORD = **4 byte**. WORD = **16 bit**.
13. Ordine: **3** (Invio EAX), **4** (Incremento EIP), **1** (Sottrazione ESP), **2** (Segnale scrittura). *Nota: Tecnicamente l'ordine è: 1. Dec ESP, 2. Invio EAX, 3. Segnale scrittura, 4. Inc EIP.*

**Sezione 5: Bonus**
14. $2^{36}$ byte = **64 GB**.

---

### Chiavi Parte A (Test Singoli)
...
### Test 1 — Architettura
1-b, 2-b, 3-b, 4-d, 5-c, 6-b, 7-c, 8-b, 9-b, 10-b


### Test 2 — Registri
1-c, 2-c, 3-d, 4-c, 5-b, 6-c, 7-b, 8-d, 9-b, 10-b, 11-c, 12-c

### Test 3 — Memoria
1-c, 2-b, 3-d, 4-c, 5-b, 6-b, 7-b, 8-d, 9-c, 10-a

### Test 4 — Istruzioni
1-c, 2-b, 3-c, 4-b, 5-b, 6-b, 7-c, 8-c, 9-c, 10-c, 11-c, 12-b

### Test 5 — Stack
1-b, 2-b, 3-c, 4-c, 5-a, 6-c, 7-c, 8-b, 9-c, 10-c, 11-b, 12-b

### Test 6 — Calling Convention
1-b, 2-d, 3-c, 4-d, 5-b, 6-c, 7-b, 8-b, 9-b, 10-c, 11-b, 12-c
