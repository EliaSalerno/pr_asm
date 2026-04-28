DOSSEG
 .MODEL SMALL
 .STACK 100h

.DATA
 nome DB 10,0,10 dup('$')
 msg1 DB 'Come ti chiami? $'
 msg2 DB 10,'Ciao $'

.CODE
 main:
  MOV ax, @DATA
  MOV ds, ax

  MOV ax, 0900h
  MOV dx, OFFSET msg1
  INT 21h

  MOV ax, 0a00h
  MOV dx, OFFSET nome
  INT 21h

  MOV ax, 0900h
  MOV dx, OFFSET msg2
  INT 21h

  MOV ax, 0900h
  MOV dx, OFFSET nome[2]
  INT 21h

  MOV ah, 4ch
  INT 21h
 END main
