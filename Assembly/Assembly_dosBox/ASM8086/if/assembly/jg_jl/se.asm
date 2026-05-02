DOSSEG
 .MODEL SMALL
 .STACK 100h

.DATA
 num1 DB 5h
 num2 DB 9H
 msg1 DB 'Maggiore!$'
 msg2 DB 'Minore!$'
 msg3 DB 'Uguali!$'

.CODE
 main:
  MOV ax, @DATA
  MOV ds, ax

  MOV al, num1
  CMP al, num2
  JG great
  JL less
  MOV dx, OFFSET msg3
  JMP print

 great:
  MOV dx, OFFSET msg1
  JMP print

 less:
  MOV dx, OFFSET msg2
  JMP print

 print:
  MOV ah, 09h
  INT 21H

  MOV ah, 4ch
  INT 21h
 END main
