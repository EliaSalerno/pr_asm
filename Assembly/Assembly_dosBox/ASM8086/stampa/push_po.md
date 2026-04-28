Ecco un esempio di programma in assembly 8086 che utilizza le istruzioni `PUSH` e `POP` per gestire lo stack. Questo esempio mostra come salvare e ripristinare i valori dei registri utilizzando lo stack.

### Esempio di Programma Assembly 8086 con PUSH e POP

```assembly
.MODEL SMALL          ; Modello di memoria piccolo
.STACK 100h          ; Dimensione dello stack

.DATA                ; Inizio del segmento dati
message DB 'The result is: $'  ; Messaggio da visualizzare
result DB ?         ; Variabile per il risultato

.CODE                ; Inizio del segmento codice
main PROC           ; Procedura principale
    MOV AX, @DATA   ; Inizializza il segmento dati
    MOV DS, AX

    MOV AL, 5       ; Carica il primo numero in AL
    MOV BL, 10      ; Carica il secondo numero in BL

    ; Esegui operazione prima della gestione dello stack
    ADD AL, BL      ; Somma i numeri (AL = AL + BL)
    
    ; Usa PUSH e POP per gestire i registri
    PUSH AX         ; Salva AX sullo stack
    PUSH BX         ; Salva BX sullo stack

    ; Qui potresti eseguire altre operazioni

    ; Ripristina i valori dei registri
    POP BX          ; Ripristina BX dallo stack
    POP AX          ; Ripristina AX dallo stack

    MOV result, AL  ; Salva il risultato nella variabile

    ; Visualizzazione del risultato
    ; (Qui un codice di visualizzazione sarebbe necessario; omesso per brevisità)

    ; Termina il programma
    MOV AX, 4C00h   ; Interruzione per terminare il programma
    INT 21h
main ENDP           ; Fine della procedura principale

END main            ; Indica il punto di inizio del programma
```

### Spiegazione del Codice

1. **Sezione Dati**: Definisce un messaggio e una variabile per memorizzare il risultato.
2. **Inizio della Logica**:
   - I valori 5 e 10 sono caricati nei registri AL e BL, rispettivamente.
   - La somma dei registri AL e BL è eseguita con l'istruzione `ADD`.
3. **Gestione dello Stack**:
   - I registri AX e BX vengono salvati nello stack usando `PUSH`.
   - È possibile eseguire altre operazioni (non rappresentate qui per brevità).
   - I valori salvati sono ripristinati usando `POP`.
4. **Stoccaggio del Risultato**: Il risultato della somma viene memorizzato in `result`.
5. **Terminazione**: Infine, il programma termina attraverso una chiamata all'interruzione DOS.

### Compilazione e Esecuzione
Puoi seguire gli stessi passaggi di compilazione e esecuzione descritti nel messaggio precedente, assicurandoti di avere un ambiente appropriato per il codice assembly. 

### Considerazione Finale
Puoi aggiungere codice aggiuntivo per visualizzare il valore di `result`, ma l'implementazione specifica dipenderà dall'ambiente in cui stai eseguendo il codice e dalle tue necessità specifiche.