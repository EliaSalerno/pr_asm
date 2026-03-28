.686
.model flat, c
.stack 100h

.code
; -----------------------------------------------------------------------------
; Nome Funzione: ContaCarattere
; Descrizione: Conta quante volte un carattere appare in una stringa C-style (null-terminated)
; Input: [ebp + 8]  -> Indirizzo della stringa (char*)
;        [ebp + 12] -> Carattere da cercare (passato come int/byte)
; Output: eax       -> Numero di occorrenze
; -----------------------------------------------------------------------------
ContaCarattere PROC
    push ebp
    mov ebp, esp
    push ebx            ; Salviamo i registri che useremo

    mov edx, [ebp + 8]  ; EDX = puntatore alla stringa
    mov cl, [ebp + 12]  ; CL = carattere da cercare (solo il byte basso)
    xor eax, eax        ; EAX = 0 (contatore)

ciclo:
    mov bl, [edx]       ; Leggi il carattere corrente
    test bl, bl         ; Verifica se è il terminatore null (\0)
    jz fine             ; Se è 0, fine della stringa

    cmp bl, cl          ; Confronta il carattere della stringa con quello cercato
    jne prossimo        ; Se diversi, vai al prossimo
    inc eax             ; Se uguali, incrementa il contatore

prossimo:
    inc edx             ; Avanza al prossimo carattere (1 byte)
    jmp ciclo

fine:
    pop ebx             ; Ripristina i registri
    pop ebp
    ret
ContaCarattere ENDP

END
