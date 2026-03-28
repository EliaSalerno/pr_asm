# Soluzioni e Guida alla Valutazione: Verifica Lezioni 01-06

## Parte 1: Architettura e Rappresentazione
1. **c) 4 byte** (Dato che sono 32 bit, 32 / 8 = 4).
2. **Fetch**: La CPU legge i byte dell'istruzione dalla RAM all'indirizzo puntato da EIP e li porta all'interno del processore.
3. **Dec: 20** -> **Hex: 14H** (16*1 + 4) | **Bin: 0001 0100** (16+4).
4. **c) EIP** (Extended Instruction Pointer).

## Parte 2: Registri e Memoria
5. **EAX** è un registro ad uso generale usato spesso per calcoli e valori di ritorno. **ESP** è il puntatore allo stack, gestisce l'indirizzo della "cima" della pila.
6. **0x00000100** (FF + 1 = 100 in esadecimale).
7. **LIFO (Last In First Out)**: L'ultimo dato inserito (push) è il primo a essere estratto (pop). In pratica, non si può accedere alla base della pila senza prima rimuovere gli elementi sopra.

## Parte 3: Lo Stack Frame
8. **b) Il chiamante** (Caratteristica distintiva della cdecl rispetto alla stdcall).
9. **c) Il primo parametro**. (EBP+4 è il ret address, EBP+8 è il primo param).
10. **b) -4**. Lo stack cresce verso il basso, quindi inserendo dati l'indirizzo diminuisce.

## Parte 4: Lettura Codice
11. **Risultato: 6**. 
    - EAX = 10
    - ECX = 5
    - 10 - 5 = 5
    - 5 + 1 = 6

## Valutazione suggerita
- **0 - 5 corrette**: Insufficiente. Bisogna rivedere il concetto di Stack Frame.
- **6 - 8 corrette**: Buono. I concetti base sono chiari.
- **9 - 11 corrette**: Ottimo. Lo studente è pronto per programmi più complessi.
