 DOSSEG
  .MODEL SMALL
  .STACK 100h

 .DATA
  n1 DB 01h
  n2 DB 02h
  msg DB 10,'Scambio terminato!$'

 .CODE
  main:
   MOV ax, @DATA
   MOV ds, ax

   MOV al, OFFSET n1   ;assegnamento ai registri
   MOV bl, OFFSET n2

   MOV n1, bl   ;scambio
   MOV n2, al

   MOV dx, OFFSET msg
   MOV ax, 0900h
   INT 21h

   MOV ax, 4C00h
   INT 21h
  END main