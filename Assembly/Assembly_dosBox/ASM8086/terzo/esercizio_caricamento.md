Ecco un esempio di come caricare un valore intero da tastiera in linguaggio Assembly a 16 bit, utilizzando l'istruzione DOS per la lettura dei caratteri. L'esempio utilizza il registro `AX` per memorizzare il valore intero:

```assembly
.model small
.stack 100h
.data
    num db 10 dup(0)     ; Riserva spazio per 10 caratteri
    msg db 'Inserisci un numero: $'
.code
main:
    ; Inizializza
    mov ax, @data
    mov ds, ax

    ; Mostra messaggio
    mov ah, 09h
    lea dx, msg
    int 21h

    ; Leggi input da tastiera
    mov ah, 0Ah          ; Funzione per la lettura stringa
    lea dx, num         ; Indirizzo della variabile 'num'
    int 21h

    ; Converti caratteri in numero
    mov cx, num[0]      ; Lunghezza dell'input
    mov si, offset num + 1  ; Inizio dei caratteri dell'input
    xor ax, ax          ; Azzerare AX (accumulatore per il numero)

convert:
    movzx bx, byte ptr [si]  ; Carica il carattere in BX
    sub bx, '0'              ; Converte carattere in valore numerico
    mov dx, 10               ; Moltiplicatore per base 10
    mul dx                   ; AX = AX * 10
    add ax, bx               ; Aggiunge il nuovo numero
    inc si                   ; Passa al prossimo carattere
    loop convert              ; Ripeti fino a cx = 0

    ; Il numero finale è in AX
    ; Puoi ora usarlo o fare altre operazioni

    ; Termina programma
    mov ax, 4C00h
    int 21h
end main
```

### Spiegazione:
1. **Dichiarazione delle sezioni**: La sezione `.data` contiene le variabili.
2. **Visualizzazione del messaggio**: Utilizza l'interruzione 21h per visualizzare un messaggio.
3. **Input da tastiera**: Legge una stringa di caratteri dalla tastiera.
4. **Conversione**: Converte i caratteri ASCII in un numero intero.
5. **Terminazione**: Termina il programma correttamente.