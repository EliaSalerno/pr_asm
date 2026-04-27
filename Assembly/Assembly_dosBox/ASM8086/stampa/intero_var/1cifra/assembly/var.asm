DOSSEG
 .MODEL SMALL
 .STACK 100h

.DATA
 n1 DB 7
 msg1 DB 'Numero: $'

.CODE
 main:
  MOV ax, @DATA
  MOV ds, ax

  MOV al, n1
  ADD al, '0'

  MOV dl, al
  MOV ah, 02h
  INT 21h

  MOV ah, 4ch
  INT 21h
 END main
