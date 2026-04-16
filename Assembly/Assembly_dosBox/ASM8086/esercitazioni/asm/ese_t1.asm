DOSSEG
 .MODEL SMALL
 .STACK 100h

.DATA
 str1 DB 'Hello '
 ;str2 DB 'world!$'

.CODE 
 main:
  MOV AX, @DATA
  MOV DS, AX

  ;stampa str1
  MOV DX, OFFSET str1
  MOV AX, 0900h
  INT 21h

  ;stampa str2
  ;MOV DX, OFFSET str2
  ;MOV AX, 0900h
  ;INT 21h

  ;interruzione codice
  MOV AX, 4C00H
  INT 21h
 END main
