DOSSEG
 .MODEL SMALL
 .STACK 100h

.DATA
 n1 DB 06h
 n2 DB 07h

.CODE
 main:
  MOV ax, @DATA
  MOV ds, ax

  MOV al, n1
  MOV bl, n2
  MUL bl

  MOV ah, 4ch
  INT 21h
 END main
