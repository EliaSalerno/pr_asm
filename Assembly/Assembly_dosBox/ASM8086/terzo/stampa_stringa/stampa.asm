DOSSEG
 .MODEL SMALL
 .STACK 100h

.DATA
 str1 DB 'Ciao mondo!$',13,10

.CODE 
 main:
  MOV ax, @DATA
  MOV ds,ax

  MOV dx, OFFSET str1
  MOV ah, 09h
  INT 21h

  MOV ah, 4ch
  INT 21h
 END main
