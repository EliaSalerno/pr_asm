# Lezione 7 — Operazioni Bitwise (Bit-a-Bit)

## 7.1 Introduzione
A differenza delle operazioni aritmetiche (`ADD`, `SUB`) che vedono il registro come un unico numero, le operazioni **bitwise** trattano il registro come un insieme di singoli interruttori (bit) indipendenti.

Queste operazioni sono fondamentali per:
- Manipolare singoli bit (es. accendere/spegnere un LED o un flag).
- Ottimizzare il codice (es. `XOR EAX, EAX` è più veloce di `MOV EAX, 0`).
- Crittografia e protocolli di rete.
- Creare maschere di bit.

---

## 7.2 Le Operazioni Fondamentali

### 1. AND (Intersezione / Mascheramento)
Il bit risultante è 1 **solo se entrambi** i bit sorgente sono 1.
*Uso tipico:* Spegnere bit specifici o verificare se un bit è acceso.

```asm
mov al, 10101010B
and al, 00001111B    ; Maschera: tiene solo i 4 bit bassi
; Risultato in AL: 00001010B
```

### 2. OR (Unione)
Il bit risultante è 1 se **almeno uno** dei bit sorgente è 1.
*Uso tipico:* Accendere bit specifici senza toccare gli altri.

```asm
mov al, 10100000B
or  al, 00000101B    ; Accende i bit 0 e 2
; Risultato in AL: 10100101B
```

### 3. XOR (OR Esclusivo)
Il bit risultante è 1 se i bit sorgente sono **diversi**.
*Uso tipico:* Invertire bit, azzerare registri o crittografia semplice.

```asm
xor eax, eax         ; AZZERA il registro (più veloce di MOV EAX, 0)
```

### 4. NOT (Inversione)
Inverte tutti i bit (0 diventa 1, 1 diventa 0). È l'unica operazione unaria (lavora su un solo operando).

```asm
mov al, 11110000B
not al
; Risultato in AL: 00001111B
```

---

## 7.3 Maschere di Bit (Bit Masking)
Una "maschera" è un valore binario costruito appositamente per estrarre o modificare parti di un registro.

**Esempio: Testare se un numero è dispari.**
In binario, un numero è dispari se l'ultimo bit (LSB) è 1.
```asm
mov eax, [numero]
and eax, 1           ; Isola l'ultimo bit
jz  numero_pari      ; Se il risultato è 0, il numero era pari
```

---

## 7.4 Operazioni di Shift (Spostamento)
Spostano i bit a destra o a sinistra.

| Istruzione | Descrizione | Effetto Matematico |
| :--- | :--- | :--- |
| `SHL` / `SAL` | Shift Left (Sinistra) | Moltiplica per 2 |
| `SHR` | Shift Right (Destra) | Divide per 2 (senza segno) |
| `SAR` | Shift Arithmetic Right | Divide per 2 (mantenendo il segno) |

**Esempio di moltiplicazione veloce:**
```asm
mov eax, 5
shl eax, 2           ; Sposta a sinistra di 2 posizioni (5 * 2^2)
; Risultato: EAX = 20
```

---

## 7.5 Esercizi di consolidamento
1. Qual è il risultato di `0101B AND 0011B`?
2. Come puoi accendere solo il 7° bit di un registro senza modificare gli altri?
3. Perché `XOR EAX, EAX` è preferibile a `MOV EAX, 0` per un compilatore?
4. Se `EAX` contiene `-2`, che differenza c'è tra usare `SHR` e `SAR`?
