DOSSEG
 .MODEL SMALL
 .STACK 100h

.DATA
 n1 DB 01h
 n2 DB 0ffh
 msg1 DB 10,'Overflow detected!$'
 msg2 DB 'Ready.... go!$'
 msg3 DB 10,'The end$'

.CODE
 main:
  MOV ax, @DATA
  MOV ds, ax

  MOV dx, OFFSET msg2
  MOV ah, 09h
  INT 21h

  MOV al, n1
  ADD al, n2
  JC overflow
  JMP fine

 overflow:
  MOV ax, 0900h
  MOV dx, OFFSET msg1
  INT 21h
 
 fine:
  MOV dx, OFFSET msg3
  MOV ah, 09h
  INT 21h
  MOV ax, 4c00h
  INT 21h
 END main
