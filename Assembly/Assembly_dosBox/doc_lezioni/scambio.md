# Scambio di Variabili in Assembly 8086

## Indice
1. [Introduzione](#introduzione)
2. [Metodo del Registro Temporaneo](#metodo-del-registro-temporaneo)
3. [Metodo XOR](#metodo-xor)
4. [Istruzione XCHG](#istruzione-xchg)
5. [Confronto delle Performance](#confronto-delle-performance)
6. [Esempi Pratici](#esempi-pratici)
7. [Considerazioni Architetturali](#considerazioni-architetturali)

## Introduzione

Lo scambio di variabili è un'operazione fondamentale in programmazione assembly. Nel processore 8086, esistono diverse tecniche per scambiare il contenuto di due variabili, ognuna con vantaggi e svantaggi specifici in termini di velocità, utilizzo di memoria e registri.

Il processore 8086 è un'architettura a 16 bit con registri generali di 16 bit (AX, BX, CX, DX) e di 8 bit (AL, AH, BL, BH, CL, CH, DL, DH).

## Metodo del Registro Temporaneo

### Descrizione
Il metodo più intuitivo utilizza un registro come area temporanea per memorizzare uno dei valori durante lo scambio.

### Implementazione Base
```assembly
.data
    var1 dw 1234h    ; Prima variabile (16 bit)
    var2 dw 5678h    ; Seconda variabile (16 bit)

.code
    ; Scambio usando AX come registro temporaneo
    mov ax, var1     ; AX = contenuto di var1
    mov bx, var2     ; BX = contenuto di var2
    mov var1, bx     ; var1 = ex contenuto di var2
    mov var2, ax     ; var2 = ex contenuto di var1
```

### Vantaggi
- **Semplicità**: Logica facilmente comprensibile
- **Affidabilità**: Funziona sempre, indipendentemente dai valori
- **Controllo**: Pieno controllo sui registri utilizzati

### Svantaggi
- **Numero di istruzioni**: Richiede 4 istruzioni MOV
- **Utilizzo registri**: Occupa un registro temporaneo
- **Cicli di clock**: Più lento rispetto ad altre tecniche

### Variante Ottimizzata
```assembly
.code
    mov ax, var1     ; Carica var1 in AX
    xchg ax, var2    ; Scambia AX con var2
    mov var1, ax     ; Salva il nuovo valore in var1
    ; Ora var1 contiene l'ex var2, var2 contiene l'ex var1
```

## Metodo XOR

### Descrizione
Utilizza le proprietà dell'operazione XOR per scambiare valori senza utilizzare memoria aggiuntiva.

### Principio Matematico
L'operazione XOR ha la proprietà che `A XOR B XOR B = A`. Questa caratteristica permette di "nascondere" un valore nell'altro e poi recuperarlo.

### Implementazione Completa
```assembly
.data
    var1 dw 1234h
    var2 dw 5678h

.code
    ; Caricamento iniziale
    mov ax, var1     ; AX = var1
    mov bx, var2     ; BX = var2
    
    ; Sequenza XOR per lo scambio
    xor ax, bx       ; AX = var1 XOR var2
    xor bx, ax       ; BX = var2 XOR (var1 XOR var2) = var1
    xor ax, bx       ; AX = (var1 XOR var2) XOR var1 = var2
    
    ; Salvataggio risultati
    mov var1, ax     ; var1 = ex var2
    mov var
Questo messaggio è stato generato da Nova - Scarica gratis:
https://novaapp.onelink.me/PBYt/cyi2tjkv