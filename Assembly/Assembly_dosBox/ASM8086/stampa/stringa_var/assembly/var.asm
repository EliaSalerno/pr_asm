DOSSEG
 .MODEL SMALL
 .STACK 100h

.DATA
 nome DB 'Elia','$'
 msg1 DB 'Ciao $'

.CODE
 main:
  MOV ax, @DATA
  MOV ds, ax

  MOV ax, 0900h
  MOV dx, OFFSET msg1
  INT 21h

  MOV ah, 09h
  MOV dx, OFFSET nome
  INT 21h

  MOV ah, 4ch
  INT 21h
 END main
