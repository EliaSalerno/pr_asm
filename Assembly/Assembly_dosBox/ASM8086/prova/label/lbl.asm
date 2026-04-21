DOSSEG
 .MODEL SMALL
 .STACK 100h

.DATA
 n1 DB 0ffh
 n2 DB 01h
 msg1 DB 'Inizio!$'
 msg2 DB 10,'Overflow detected!$'
 msg3 DB 10,'Fine!','$',10

.CODE
 main:
  MOV ax, @DATA
  MOV ds, ax

  MOV dx, OFFSET msg1
  MOV ax, 0900h
  ; MOV ah, 09h
  INT 21h

  MOV al, n1
  ADD al, n2
  JC overflow
  JMP fine

 overflow:
  MOV dx, OFFSET msg2
  MOV ah, 09h
  INT 21h
  JMP fine

 fine:
  MOV dx, OFFSET msg3
  MOV ax, 0900h
  INT 21h
 END main
