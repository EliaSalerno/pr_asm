DOSSEG
 .MODEL SMALL
 .STACK 100h

.DATA
 nome DB 10,0,10 dup('$')
 msg1 DB 'Come ti chiami? $'
 msg2 DB 13,10,'Ciao $'
 msg3 DB 13,10,'Non hai inserito niente.',13,10,'Rifacciamo. $'

.CODE
 main:
  MOV ax, @DATA
  MOV ds, ax

 inizio:
  MOV ax, 0900h
  MOV dx, OFFSET msg1
  INT 21h

  MOV dx, OFFSET nome
  MOV ah, 0ah
  INT 21h

  MOV bl, nome[1]
  CMP bl, 0
  JZ zero
  JNZ saluto

 zero:
  MOV dx, OFFSET msg3
  MOV ah, 09h
  INT 21h
  JMP inizio
 saluto:
  MOV dx, OFFSET msg2
  MOV ah, 09h
  INT 21h
  MOV dx, OFFSET nome[2]
  MOV ah, 09h
  INT 21h

  MOV ax, 4c00h
  INT 21H
 END main
