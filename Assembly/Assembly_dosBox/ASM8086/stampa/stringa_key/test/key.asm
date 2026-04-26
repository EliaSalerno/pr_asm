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

  MOV ax, 0900h
  MOV dx, OFFSET msg1
  INT 21h

  ; Iniziamo la lettura
  JMP leggiamo
 uno:
  ; Dobbiamo completare la stringa
  JMP completiamo
 due:
  ; Possiamo salutare
  JMP saluto
 completiamo:
  MOV bl, nome[1]
  XOR bh, bh
  MOV nome[bx+2], '$'
  JMP due
 fine:
  MOV ax, 4c00h
  INT 21h
 leggiamo:
  MOV ax, 0a00h
  MOV dx, OFFSET nome
  INT 21h
  JMP uno
 saluto:
  MOV ax, 0900h
  MOV dx, OFFSET msg2
  INT 21h
  MOV ax, 0900h
  MOV dx, OFFSET nome[2]
  INT 21h
  JMP fine
 END main
