DOSSEG
 .MODEL SMALL
 .STACK 100h

.DATA
 str1 DB 'Hello123,','$'
 str2 DB 13,'world!$'

.CODE
 main:
  MOV AX, @DATA
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
  MOV AH, 4Ch
  INT 21h
 END main
