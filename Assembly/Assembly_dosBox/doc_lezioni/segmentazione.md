# ATTIVITÀ: Comprensione dei Segmenti di Memoria

## **OBIETTIVI DELL'ATTIVITÀ**

### Obiettivo Generale
Comprendere il concetto di segmento nell'architettura x86 e la sua applicazione pratica nella gestione della memoria.

### Obiettivi Specifici
1. **Definire** cosa si intende per segmento di memoria
2. **Calcolare** indirizzi fisici utilizzando segmenti e offset
3. **Identificare** i diversi tipi di segmenti e le loro funzioni
4. **Applicare** i concetti teorici in esempi pratici

---

## **DOMANDA 1: Definizione e Concetti Base**

### Quesito
**Spiega cosa si intende per "segmento" nell'architettura x86. Includi nella tua risposta:**
- La dimensione massima di un segmento
- I quattro registri di segmento principali e le loro funzioni
- Il motivo per cui si utilizza la moltiplicazione per 16

### Obiettivi Specifici per questa Domanda
- [ ] Definire correttamente il concetto di segmento
- [ ] Identificare la dimensione limite (64KB)
- [ ] Elencare CS, DS, SS, ES con le rispettive funzioni
- [ ] Spiegare il meccanismo di shift a sinistra di 4 bit

### Criteri di Valutazione
- **Eccellente (9-10)**: Risposta completa con esempi pratici
- **Buono (7-8)**: Risposta corretta ma manca qualche dettaglio
- **Sufficiente (6)**: Concetti base presenti ma spiegazione superficiale
- **Insufficiente (<6)**: Concetti errati o mancanti

---

## **DOMANDA 2: Applicazione Pratica**

### Quesito
**Risolvi i seguenti calcoli di indirizzi fisici e completa l'esercizio:**

1. **Calcolo Indirizzi:**
   - Segmento = 2A00h, Offset = 01B5h → Indirizzo fisico = ?
   - Segmento = 1F80h, Offset = 0750h → Indirizzo fisico = ?

2. **Scenario Pratico:**
   ```
   Un programma ha:
   - CS (Code Segment) = 3000h
   - DS (Data Segment) = 4000h  
   - SS (Stack Segment) = 5000h
   
   Calcola gli indirizzi fisici quando:
   - IP (Instruction Pointer) = 0100h
   - Una variabile si trova all'offset 0250h nel segmento dati
   - Lo stack pointer (SP) = 0500h
   ```

### Obiettivi Specifici per questa Domanda
- [ ] Applicare correttamente la formula: Indirizzo Fisico = (Segmento × 16) + Offset
- [ ] Convertire correttamente i numeri esadecimali
- [ ] Interpretare scenari realistici di utilizzo dei segmenti
- [ ] Dimostrare comprensione pratica dei diversi registri di segmento

### Criteri di Valutazione
- **Eccellente (9-10)**: Tutti i calcoli corretti con procedimento chiaro
- **Buono (7-8)**: Calcoli corretti ma qualche errore minore nel procedimento
- **Sufficiente (6)**: Formula applicata correttamente ma errori nei calcoli
- **Insufficiente (<6)**: Formula errata o calcoli completamente sbagliati

---

## **VALUTAZIONE COMPLESSIVA**

| Criterio | Peso | Punteggio |
|----------|------|-----------|
| Domanda 1 - Teoria | 40% | ___/10 |
| Domanda 2 - Pratica | 50
