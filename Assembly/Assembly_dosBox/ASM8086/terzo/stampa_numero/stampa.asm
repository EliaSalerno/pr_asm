DOSSEG
 .MODEL SMALL
 .STACK 100h

.DATA
 num DW 1234h

.CODE
 main:
  MOV ax, @DATA
  MOV ds, ax

  
