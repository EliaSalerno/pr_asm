Per stampare un numero a più cifre in assembly 8086, dobbiamo scomporlo dividendo ripetutamente per 10. Poiché la divisione estrae le cifre dall'ultima alla prima (partendo dalle unità), useremo lo stack come memoria temporanea per poterle poi stampare nell'ordine corretto (LIFO - Last In, First Out).
Ecco un esempio completo per stampare un intero a 16 bit:

.model small
.stack 100h

.data
    valore dw 12345      ; Variabile a 16 bit (max 65535 se unsigned)

.code
main proc
    mov ax, @data
    mov ds, ax

    mov ax, valore       ; Carichiamo il numero in AX
    mov bx, 10           ; Divisore costante
    mov cx, 0            ; Contatore per quante cifre troviamo

scomponi:
    mov dx, 0            ; Azzera DX (necessario per divisione 32/16 o 16/16)
    div bx               ; AX / 10 -> Quoziente in AX, Resto in DX
    push dx              ; Salviamo il resto (la cifra) nello stack
    inc cx               ; Incrementiamo il contatore cifre
    cmp ax, 0            ; Abbiamo finito di dividere?
    jne scomponi         ; Se AX > 0, continua

stampa:
    pop dx               ; Recuperiamo l'ultima cifra inserita
    add dl, 48           ; Convertiamo il valore numerico in carattere ASCII ('0' = 48)
    mov ah, 02h          ; Funzione DOS per stampare un carattere
    int 21h              ; Chiamata al sistema
    loop stampa          ; Ripete per il numero di cifre in CX

    ; Termina programma
    mov ax, 4C00h
    int 21h
main endp
end main

## Spiegazione tecnica:

   1. div bx: Quando dividi un registro a 16 bit (AX) per un altro a 16 bit (BX), il processore mette il quoziente in AX e il resto in DX.
   2. push dx: Inseriamo il resto (che è la nostra cifra, es. il 5 di 12345) nello stack.
   3. inc cx: Teniamo traccia di quante volte dividiamo, così sappiamo quanti pop fare dopo.
   4. loop stampa: L'istruzione loop usa automaticamente il registro CX come contatore, decrementandolo a ogni giro finché non arriva a zero.
