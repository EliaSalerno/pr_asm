# Esercizio 06 — Scansione di Stringhe: Conta Occorrenze

## Obiettivo
Scrivere una funzione in Assembly x86 (32-bit) che riceva come input una stringa (puntatore a caratteri) e un carattere specifico, e restituisca il numero di volte che quel carattere appare nella stringa.

## Concetti Chiave
1.  **Iterazione su stringhe**: In Assembly, una stringa è un array di byte che termina con il valore `0` (null-terminator).
2.  **Puntatori**: Bisogna usare un registro (es. `EDX`) come indice che punta all'indirizzo di memoria corrente e incrementarlo di 1 byte alla volta.
3.  **Confronto condizionale**: Usare `CMP` per verificare se il carattere corrente è quello cercato, e `JNE` o `JE` per gestire il contatore.

## Struttura della Funzione
La funzione deve seguire la convenzione di chiamata `cdecl`:
-   **Input**: 
    -   `[ebp + 8]`: Indirizzo di inizio della stringa (stringa C-style).
    -   `[ebp + 12]`: Carattere da cercare (passato come 4 byte, ma ne useremo solo il primo).
-   **Output**:
    -   `EAX`: Numero di occorrenze trovate.

## Frammento di Codice (Punti critici)
```assembly
ciclo:
    mov bl, [edx]       ; Leggi il byte all'indirizzo puntato da EDX
    test bl, bl         ; Verifica se è 0 (fine stringa)
    jz fine             ; Se sì, esci dal ciclo

    cmp bl, cl          ; Confronta con il carattere cercato
    jne prossimo        ; Se diverso, non incrementare
    inc eax             ; Se uguale, incrementa il contatore

prossimo:
    inc edx             ; Sposta il puntatore al prossimo carattere
    jmp ciclo
```

## Guida all'Esercitazione
1.  **Analisi**: Apri il file `conta.asm` e identifica le istruzioni che gestiscono il "salto" in caso di mancata corrispondenza.
2.  **Debugging**: Avvia il progetto C# e metti un breakpoint in Visual Studio sulla riga `inc eax`. Osserva il valore di `EAX` nella finestra dei registri man mano che procedi.
3.  **Sfida Extra**: Modifica il codice per rendere la funzione *case-insensitive* (quindi 'A' deve contare anche le 'a').
    - *Suggerimento*: Prima del confronto, se il carattere è tra 'A' e 'Z', puoi aggiungere 32 per trasformarlo in minuscolo, oppure usare un doppio confronto.

## Criteri di Verifica
Il test runner C# fornito effettuerà i seguenti controlli:
- [ ] La stringa "banana" con carattere 'a' deve restituire 3.
- [ ] Stringa vuota "" deve restituire 0.
- [ ] Ricerca di un carattere non presente deve restituire 0.
