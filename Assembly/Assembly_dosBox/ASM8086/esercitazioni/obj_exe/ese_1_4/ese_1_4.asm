DOSSEG
 .MODEL SMALL
 .STACK 100h

.DATA
 str1 DB 'Hello!','$'
 str2 DB 13,'B','$'

.CODE
 main:
  MOV AX, @DATA
  MOV DS, AX

  ;Stampa str1
  MOV DX, OFFSET str1
  MOV AH, 09h
  INT 21h

  ;Stampa str2
  MOV DX, OFFSET str2
  MOV AH, 09h
  INT 21h

  ;Interruzione programma
  MOV AX, 4C00h
  INT 21h
 END main
