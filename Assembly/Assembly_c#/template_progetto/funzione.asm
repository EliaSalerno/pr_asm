.686
.model flat, c
.stack 100h

.data
    ; Qui puoi definire le tue variabili globali

.code
; -----------------------------------------------------------------------------
; Nome Funzione: MiaFunzione
; Descrizione: Esempio di funzione che somma due numeri
; Input: [ebp + 8]  -> Primo intero (a)
;        [ebp + 12] -> Secondo intero (b)
; Output: eax       -> a + b
; -----------------------------------------------------------------------------
MiaFunzione PROC
    push ebp            ; Salva il vecchio base pointer
    mov ebp, esp        ; Imposta il nuovo base pointer

    mov eax, [ebp + 8]  ; Carica 'a' in EAX
    add eax, [ebp + 12] ; Somma 'b' a EAX

    pop ebp             ; Ripristina il base pointer
    ret                 ; Ritorna (il risultato è in EAX)
MiaFunzione ENDP

END
