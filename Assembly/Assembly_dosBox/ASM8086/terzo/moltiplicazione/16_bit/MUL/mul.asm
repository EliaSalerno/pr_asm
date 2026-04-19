DOSSEG
 .MODEL SMALL
 .STACK 100h

.DATA
 n1 DW 06h
 n2 DW 07h

.CODE
 main:
  MOV ax, @DATA
  MOV ds, ax

  MOV ax, n1
  MOV bx, n2
  MUL bx

  MOV ah, 4ch
  INT 21h
 END main
