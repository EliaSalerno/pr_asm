DOSSEG
 .MODEL SMALL
 .STACK 100h

.DATA
 nome DB ' Elia!$'
 msg1 DB 'Ciao$'

.CODE
 main:
  MOV ax, @DATA
  MOV ds, ax

  MOV ax, 0900h
  MOV dx, OFFSET msg1
  INT 21h

  MOV ax, 0900h
  MOV dx, OFFSET nome
  INT 21h

  MOV ax, 4c00h
  INT 21h
 END main
