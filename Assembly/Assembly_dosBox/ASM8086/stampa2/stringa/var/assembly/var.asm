DOSSEG
 .MODEL SMALL
 .STACK 100h

.DATA
				;+--+--+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 msg1 DB 'Come ti chiami?$'	;|C |o |m|e| |t|i| |c|h|i|a|m|i|?|$|
				;+--+--+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 msg2 DB 13,10,'Ciao $'		;|13|10|C|i|a|o| |$| | | | | | | | |
				;+--+--+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 NOME DB 'Elia$'		;|E |l |i|a|$| | | | | | | | | | | |
				;+--+--+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

.CODE
 main:
  MOV ax, @DATA
  MOV ds, ax

  MOV ah, 09h
  MOV dx, OFFSET msg1
  INT 21h

  MOV dx, OFFSET msg2     ;LEA dx, msg2
  MOV ax, 0900h
  INT 21h

  MOV dx, OFFSET NOME
  MOV ax, 0900h
  INT 21h

  MOV ax, 4c00h
  INT 21h
 END main
