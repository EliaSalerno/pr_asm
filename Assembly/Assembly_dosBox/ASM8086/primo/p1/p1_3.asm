; hello.asm – Stampa 'Hello, World!' usando interrupt DOS

DOSSEG
.MODEL SMALL
.STACK 100h

.DATA
    msg DB 'Hello, World!',13,, '$'
    ; DB = Define Byte
    ; 13 = CR (carriage return)  10 = LF (line feed)  '$' = terminatore stringa DOS

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    MOV DX, OFFSET msg    ; DX punta all'inizio della stringa
    MOV AH, 09h           ; Funzione 09h = stampa stringa terminata da '$'
    INT 21h               ; Chiama DOS

    MOV AX, 4C00h
    INT 21h
MAIN ENDP
END MAIN
