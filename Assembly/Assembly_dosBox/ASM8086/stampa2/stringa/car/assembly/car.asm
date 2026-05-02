DOSSEG
 .MODEL SMALL
 .STACK 100h

.DATA
 NOME DB 10,0,10 dup(0)
 msg1 DB 'Come ti chiami? $'
 msg2 DB 13,10,'Ciao $'

.CODE
 main:
  MOV ax, @DATA
  MOV ds, ax

  MOV dx, OFFSET msg1
  MOV ax, 0900h
  INT 21h

  MOV dx, OFFSET NOME
  MOV ax, 0a00h
  INT 21h

  MOV bl, NOME[1]
  XOR bh,bh
  MOV NOME[bx+2], '$'

  MOV ax, 0900h
  MOV dx, OFFSET msg2
  INT 21h

  MOV ax, 0900h
  MOV dx, OFFSET NOME[2]
  INT 21h

  MOV ax, 4c00h
  INT 21H
 END main
