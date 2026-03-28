DOSSEG
.MODEL SMALL
.STACK 100H

.DATA
    msg DB 'Hello, Elia!', 13, 10, '$'
    ; DB = Define Bytes
    ; 13 = CR (carriage return) 10 = LF (line feed) '$' = terminatore striga DOS

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    MOV DX, OFFSET msg   ; DX punta all'inizio della stringa 
    MOV AH, 09h   ; Funzione 09h = stampa stringa terminata da '$'
    INT 21h   ; Chiama DOS

    MOV AX, 4c00H
    INT 21h
MAIN ENDP
END MAIN
