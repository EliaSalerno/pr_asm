# Coppia Segmento:Offset

È il modo in cui l'**Intel 8086** rappresenta un indirizzo di memoria, usando **due valori separati**.

---

## Il problema di partenza

Il processore 8086 ha registri a **16 bit**, quindi può indirizzare al massimo:

2¹⁶ = **65.536 byte (64 KB)**

Ma il bus degli indirizzi è a **20 bit**, quindi la memoria fisica è:

2²⁰ = **1.048.576 byte (1 MB)**

Con soli 16 bit non si raggiunge 1 MB → serve un trucco.

---

## La soluzione: la segmentazione

La memoria viene divisa in **segmenti**. Un indirizzo è espresso come:

> **Segmento : Offset**

- **Segmento** → indica *quale blocco* di memoria (base del segmento)
- **Offset** → indica *quanto ci si sposta* dall'inizio di quel blocco

Entrambi sono valori a 16 bit, ma combinati producono un indirizzo a **20 bit**.

---

## Analogia concreta

Immagina un edificio con più scale:

| Concetto | Analogia |
|----------|----------|
| Segmento | Numero della scala (es. scala B) |
| Offset | Piano + appartamento dentro quella scala |
| Indirizzo fisico | L'indirizzo postale completo |

Sapere solo il piano non basta → devi sapere *anche* da quale scala parti.

---

## Esempio visivo

```
Memoria (1MB)
┌─────────────────┐ ← 00000h
│                 │
│   Segmento DS   │ ← base: 20000h  (DS=2000h)
│   ┌─────────┐   │
│   │  +0050h │ ◄─── Offset (SI=0050h)
│   └─────────┘   │
│                 │
└─────────────────┘ ← FFFFFh
```

L'indirizzo fisico **20050h** è esattamente quella cella di memoria.

---

## I registri usati per ogni segmento

| Segmento | Registro base | Offset tipico | Uso |
|----------|--------------|---------------|-----|
| Codice | CS | IP | Istruzioni da eseguire |
| Dati | DS | SI, DI, BX | Variabili e dati |
| Stack | SS | SP, BP | Stack delle chiamate |
| Extra | ES | DI | Dati aggiuntivi |

Ogni coppia ha un **significato preciso** a seconda di cosa sta facendo il processore in quel momento.
