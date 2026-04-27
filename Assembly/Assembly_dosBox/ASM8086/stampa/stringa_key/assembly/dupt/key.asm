DOSSEG
 .MODEL SMALL
 .STACK 100h

.DATA                           ;+--+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 nome DB 10,0,10 dup('$')       ;|10|0|$|$|$|$|$|$|$|$|$|$| | | | | |
				;+--+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 msg1 DB 'Come ti chiami? $'    ;|C |o|m|e| |t|i| |c|h|i|a|m|i|?| |$|
				;+--+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 msg2 DB 10,'Ciao $'            ;|10|C|i|a|o| |$| | | | | | | | | | |
                                ;+--+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

.CODE
 main:
  MOV ax, @DATA   		;Caricamento indirizzo inizio data segment in ds
  MOV ds, ax

  MOV ax, 0900h			;Stampa primo messaggio
  MOV dx, OFFSET msg1
  INT 21h

  MOV ax, 0a00h			;Caricamento da tastiera nome
  MOV dx, OFFSET nome
  INT 21h

;  MOV bl, nome[1]		Completamento caricamento con il carattere terminatore
;  XOR bh, bh
;  MOV nome[bx+2], '$'

  MOV ah, 09h			;Stampa secondo messaggio
  MOV dx, OFFSET msg2
  INT 21h

  MOV ah, 09h			;Stampa nome inserito nel secondo messaggio
  MOV dx, OFFSET nome[2]
  INT 21h

  MOV ax, 4c00h			;Termina il programma
  INT 21h
 END main
