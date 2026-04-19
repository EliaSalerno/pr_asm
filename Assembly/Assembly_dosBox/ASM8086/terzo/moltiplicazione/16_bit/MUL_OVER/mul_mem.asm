DOSSEG
 .MODEL SMALL
 .STACK 100h

.DATA
 n1 DW 2000h
 n2 DW 0010h
 ris DD 0
 over DB 'Overflow detected!$'

.CODE
 main:
  MOV ax, @DATA
  MOV ds, ax

  MOV ax, n1
  MOV bx, n2
  MUL bx

  MOV WORD PTR [ris], ax
  MOV WORD PTR [ris+2],dx

  JC overflow_detected
  JMP fine

 overflow_detected:
  MOV dx, OFFSET over
  MOV ah, 09h
  INT 21h

 fine:
  MOV ah, 4ch
  INT 21h
 END main
