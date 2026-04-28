Ecco un esempio completo di un programma in assembly 8086 che utilizza una procedura per sommare due numeri e restituire il risultato. Questo esempio illustra definizioni di segmenti di dati e codice, la chiamata di una procedura, e la gestione dei parametri.

### Esempio di Programma Assembly 8086

```assembly
.MODEL SMALL          ; Modello di memoria piccolo
.STACK 100h          ; Dimensione dello stack

.DATA                ; Inizio del segmento dati
num1 DB 5           ; Primo numero
num2 DB 10          ; Secondo numero
result DB ?         ; Variabile per il risultato

.CODE                ; Inizio del segmento codice
main PROC           ; Procedura principale
    ; Inizializza i registri
    MOV AL, num1    ; Carica il primo numero in AL
    MOV BL, num2    ; Carica il secondo numero in BL

    ; Chiama la procedura per sommare
    CALL SumNumbers

    ; Memorizza il risultato
    MOV result, AL  ; Salva il risultato nella variabile

    ; Termina il programma
    MOV AX, 4C00h   ; Interruzione per terminare il programma
    INT 21h
main ENDP           ; Fine della procedura principale

SumNumbers PROC     ; Procedura per sommare due numeri
    ADD AL, BL      ; Aggiunge BL ad AL (AL = AL + BL)
    RET              ; Ritorna al chiamante
SumNumbers ENDP     ; Fine della procedura di somma

END main            ; Indica il punto di inizio del programma
```

### Compilazione e Esecuzione

Per compilare ed eseguire questo programma, puoi utilizzare un assembler come MASM o TASM. Ecco i passaggi generali:

1. **Salva il Codice**: Copia il codice in un file di testo e salvalo con un'estensione `.asm`, per esempio `somme.asm`.
2. **Compila il Codice**: Usa il comando del tuo assembler per compilare il codice. Ad esempio, con MASM:
   ```
   MASM somme.asm;
   ```
3. **Linka il Programma**: Dopo la compilazione, utilizza il linker per generare l'eseguibile:
   ```
   LINK somme.obj;
   ```
4. **Esegui il Programma**: Infine, esegui il programma:
   ```
   somme.exe
   ```

### Considerazioni
- Questo programma calcola la somma di `num1` e `num2`, memorizzando il risultato in `result`.
- Puoi modificare i valori di `num1` e `num2` nel segmento dati per testare con diversi numeri.
- Assicurati di usare un ambiente di assemblaggio compatibile con il modello di memoria e le interruzioni DOS per il corretto funzionamento del programma.