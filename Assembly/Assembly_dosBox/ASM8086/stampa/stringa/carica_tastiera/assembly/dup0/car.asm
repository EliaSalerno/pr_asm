DOSSEG
 .MODEL SMALL
 .STACK 100h

.DATA
 nome DB 10,0,10 dup(0)
 msg1 DB 'Come ti chiami? $'
 msg2 DB 10,'Ciao $'

.CODE
 main:
  MOV ax, @DATA
  MOV ds, ax

  MOV ah, 09h
  MOV dx, OFFSET msg1
  INT 21h

  MOV ah, 0ah
  MOV dx, OFFSET nome
  INT 21h

  MOV bl, nome[1]
  XOR bh, bh
  MOV nome[bx+2], '$'

  MOV ah, 09h
  MOV dx, OFFSET msg2
  INT 21h

  MOV ah, 09h
  MOV dx, OFFSET nome[2]
  INT 21h

  MOV ah, 4ch
  INT 21h
 END main
