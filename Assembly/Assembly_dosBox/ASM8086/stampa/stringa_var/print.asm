DOSSEG
 .MODEL SMALL
 .STACK 100h

.DATA
 msg1 DB 'Hello, world!$',13,10

.CODE
 main:
  MOV ax, @DATA
  MOV ds, ax

  MOV dx, OFFSET msg1
  MOV ax, 0900h
  INT 21h

  MOV ah, 4ch
  INT 21h
 END main
