DOSSEG
 .MODEL SMALL
 .STACK 100h

.DATA
 n1 DB 01h
 n2 DB 02h
 msg DB 10,'Scambio effettuato!$'

.CODE
 main:
  MOV ax, @DATA
  MOV ds, ax
  JMP scambio

 messaggio:
  MOV ah, 09h
  MOV dx, OFFSET msg
  INT 21h
  JMP fine

 fine:
  MOV ax, 4c00h
  INT 21h

 scambio:
  MOV al, n1
  XOR al, n2
  MOV n1, al
  JMP messaggio
 END main
