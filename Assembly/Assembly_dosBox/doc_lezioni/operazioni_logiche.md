# Operazioni Logiche in Assembly 16-bit (x86)

Le operazioni logiche in assembly operano **bit a bit** sui registri o sulla memoria.

---

## AND

Mette a `1` solo i bit che sono `1` in **entrambi** gli operandi.

```asm
AND AX, BX       ; AX = AX AND BX
AND AX, 0F0Fh    ; maschera: mantieni solo certi bit
```

**Uso tipico:** isolare (mascherare) bit specifici.

```
  AX = 1100 1010 1111 0000
  BX = 1111 0000 1010 1100
       ─────────────────────
 AND = 1100 0000 1010 0000
```

---

## OR

Mette a `1` se **almeno uno** dei due bit è `1`.

```asm
OR AX, BX        ; AX = AX OR BX
OR AX, 0080h     ; forza il bit 7 a 1
```

**Uso tipico:** settare (forzare a 1) bit specifici.

```
  AX = 1100 0000 1010 0000
  BX = 0000 1111 0000 1111
       ─────────────────────
  OR = 1100 1111 1010 1111
```

---

## XOR

Mette a `1` solo se i bit sono **diversi** tra loro.

```asm
XOR AX, BX       ; AX = AX XOR BX
XOR AX, AX       ; ← trucco classico: azzera AX velocemente
```

**Uso tipico:** invertire bit, azzerare registri, cifratura semplice.

```
  AX = 1100 1010 1111 0000
  BX = 1010 1010 1010 1010
       ─────────────────────
 XOR = 0110 0000 0101 1010
```

---

## NOT

**Inverte** tutti i bit (complemento a uno).

```asm
NOT AX           ; ogni bit di AX viene invertito
```

```
  AX = 1100 1010 0000 1111
 NOT = 0011 0101 1111 0000
```

---

## TEST

Come `AND` ma **non modifica** il registro — aggiorna solo i **flag** (ZF, SF, PF).

```asm
TEST AX, 0001h   ; controlla se il bit 0 è settato
JZ   bit_zero    ; salta se il bit era 0 (ZF=1)
```

**Uso tipico:** controllare singoli bit senza modificare il valore.

---

## SHL / SAL — Shift Left

Scorre i bit verso **sinistra** (equivale a moltiplicare per 2).

```asm
SHL AX, 1        ; AX = AX * 2
SHL AX, CL       ; CL contiene il numero di posizioni
```

```
  AX = 0000 0000 0000 0101  (= 5)
SHL 1 → 0000 0000 0000 1010  (= 10)
```

---

## SHR — Shift Right (logico)

Scorre i bit verso **destra**, inserisce `0` a sinistra (divisione intera per 2, senza segno).

```asm
SHR AX, 1        ; AX = AX / 2 (unsigned)
```

---

## SAR — Shift Arithmetic Right

Come `SHR` ma **preserva il bit di segno** (per numeri con segno).

```asm
SAR AX, 1        ; AX = AX / 2 (signed, preserva segno)
```

---

## ROL / ROR — Rotate

Ruota i bit senza perderne nessuno — il bit uscente rientra dall'altro lato.

```asm
ROL AX, 1        ; ruota a sinistra
ROR AX, 1        ; ruota a destra
```

---

## Effetto sui Flag

| Operazione      | ZF | SF | CF | OF |
|-----------------|----|----|----|----|
| AND/OR/XOR/TEST | ✅ | ✅ |  0 |  0 |
| NOT             | ❌ | ❌ | ❌ | ❌ |
| SHL/SHR/SAR     | ✅ | ✅ | ✅ | ✅ |

> **ZF** = Zero Flag, **SF** = Sign Flag, **CF** = Carry Flag, **OF** = Overflow Flag

---

## Esempio Pratico — Controlla e manipola bit

```asm
; Controlla se il bit 3 di AX è settato
TEST AX, 0008h
JNZ  bit3_settato

; Setta il bit 5 di AX
OR   AX, 0020h

; Azzera il bit 5 di AX
AND  AX, FFDFh    ; maschera: NOT(0020h) = FFDFh

; Inverti il bit 5 di AX
XOR  AX, 0020h
```

---

---

# Esercizi

---

## Esercizio 1 — AND: maschera dei nibble bassi

**Testo:** `AX = 1010 1100 1111 0101b`. Applica una maschera AND per azzerare i **4 bit più significativi** di ogni byte, mantenendo solo i nibble bassi.

**Svolgimento:**

```asm
MOV AX, 0ACF5h   ; AX = 1010 1100 1111 0101
AND AX, 0F0Fh    ; maschera = 0000 1111 0000 1111
```

**Calcolo bit a bit:**

```
  AX  = 1010 1100  1111 0101
MASK  = 0000 1111  0000 1111
        ────────────────────
  AND = 0000 1100  0000 0101  → 0C05h
```

**Risultato:** `AX = 0C05h`

---

## Esercizio 2 — OR: forzare bit a 1

**Testo:** `BX = 0000 0000 0100 0010b`. Forza i bit 0 e 7 a `1`.

**Svolgimento:**

```asm
MOV BX, 0042h    ; BX = 0000 0000 0100 0010
OR  BX, 0081h    ; maschera = 0000 0000 1000 0001
```

**Calcolo bit a bit:**

```
  BX = 0000 0000 0100 0010
MASK = 0000 0000 1000 0001
       ────────────────────
  OR = 0000 0000 1100 0011  → 00C3h
```

**Risultato:** `BX = 00C3h`

---

## Esercizio 3 — XOR: azzerare un registro

**Testo:** Azzera il registro `CX` nel modo più veloce possibile.

**Svolgimento:**

```asm
XOR CX, CX       ; qualunque valore XOR se stesso = 0
```
