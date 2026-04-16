DOSSEG
 .MODEL SMALL
 .STACK 100h

.DATA
 str1 DB 'Hello $'
 str2 DB 'world!$',13

.CODE
 main:
  MOV AX,@DATA
  MOV DS, AX

  ;Stampa str1
  MOV DX, OFFSET str1
  MOV AX, 0900h
  INT 21h

  ;Stampa str2
  MOV DX, OFFSET str2
  MOV AX, 0900h
  INT 21h

  ;Interruzione programma
  ;MOV AX, 4C00h
  ;INT 21h
 END main
