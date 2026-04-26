DOSSEG
 .MODEL SMALL
 .STACK 100h

.DATA
 nome DB 10,0,10 dup(0)
 msg1 DB 'Come ti chiami? $'
 msg2 DB 10,'Ciao ','$'

.CODE
 main:
  MOV ax, @DATA
  MOV ds, ax

  MOV ax, 0900h
  MOV dx, OFFSET msg1
  INT 21h

  ; Ora leggiamo il nome
  JMP leggi
 uno:
  ; Una volta letto dobbiamo completare la stringa con il carattere terminatore
  JMP completa
 due:
  ; Una volta completato il nome possiamo stampare il messaggio completo
  JMP saluta

 saluta:
  MOV ax, 0900h
  MOV dx, OFFSET msg2
  INT 21h
  MOV ax, 0900h
  MOV dx, OFFSET nome[2]
  INT 21h
  JMP termina
 completa:
  MOV bl, nome[1]
  XOR bh, bh
  MOV nome[bx+2], '$'
  JMP due
 termina:
  MOV ax, 4c00h
  INT 21h
 leggi:
  MOV ax, 0a00h
  MOV dx, OFFSET nome
  INT 21h
  JMP uno
 END main
