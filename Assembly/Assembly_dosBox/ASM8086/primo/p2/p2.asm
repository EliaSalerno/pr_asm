DOSSEG
.MODEL SMALL
.STACK 100h

.DATA
   msg DB 13,10,'Hello,','$'
   msg1 DB 'world!$'

.CODE
MAIN PROC
   MOV AX,@DATA
   MOV DS, AX

   MOV DX, OFFSET msg
   MOV AH, 09h
   INT 21h

   MOV DX, OFFSET msg1
   MOV AH, 09h
   INT 21h

   MOV AX, 4Ch
   INT 21h
MAIN ENDP
END MAIN
