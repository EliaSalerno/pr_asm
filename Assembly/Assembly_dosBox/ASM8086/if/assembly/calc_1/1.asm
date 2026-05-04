DOSSEG
 .MODEL SMALL
 .STACK 100h

.DATA
 n1 DB 2,0,2 dup('$')
 n2 DB 2,0,2 dup('$')
 op DB 2,0,2 dup('$')
 msg1 DB 'Inserire il primo numero! $'
 msg2 DB 13,10,'Inserire il secondo numero! $'
 msgop DB 13,10, 'Quale operazione vuoi svolgere? $'

.CODE
 main:
  MOV ax, @DATA
  MOV ds, ax

 primo:
  MOV ax, 0900h
  MOV dx, OFFSET msg1
  INT 21h

  MOV ax, 0a00h
  MOV dx, OFFSET n1
  INT 21h

  MOV bl, n1[1]
  CMP bl, 0
  JZ primo

 secondo:
  MOV ax, 0900h
  MOV dx, OFFSET msg2
  INT 21h

  MOV ax, 0a00h
  MOV dx, OFFSET n2
  INT 21h

  MOV bl, n2[1]
  CMP bl, 0
  JZ secondo

 terzo:
  MOV ax, 0900h
  MOV dx, OFFSET msgop
  INT 21h

  MOV ax, 0a00h
  MOV dx, OFFSET op
  INT 21h

  MOV bl, op[1]
  CMP bl, 0
  JZ terzo
  MOV bl, op[2]
  CMP bl, '+'
  JZ somma
  CMP bl, '-'
  JZ sottrazione
  CMP bl, '*'
  JZ moltiplicazione
  CMP bl, '/'
  JZ divisione

 stampa:
  ADD al, '0'
  MOV dl, al
  MOV ax, 0200h
  INT 21h
  JMP fine

 somma:
  MOV al, n1[2]
  SUB al, '0'
  MOV bl, n2[2]
  SUB bl, '0'
  ADD al, bl
  JMP stampa
 sottrazione:
  MOV al, n1[2]
  SUB al, '0'
  MOV bl, n2[2]
  SUB bl, '0'
  SUB al, bl
  JMP stampa
 moltiplicazione:
  MOV al, n1[2]
  SUB al, '0'
  MOV bl, n2[2]
  SUB bl, '0'
  MUL bl
  
 divisione:
   MOV al, n1[2]
   SUB al, '0'
   MOV bl, n2[2]
   SUB bl, '0'
   MOV ah, 0
   DIV bl
   JMP stampa
 fine:
  MOV ax, 4c00h
  INT 21h
 END main
