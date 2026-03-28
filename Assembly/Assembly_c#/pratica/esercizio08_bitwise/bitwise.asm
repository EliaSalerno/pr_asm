.686
.model flat, c
.stack 100h

.code

; -----------------------------------------------------------------------------
; Funzione: InvertiBit
; Descrizione: Inverte tutti i bit di un intero usando NOT
; -----------------------------------------------------------------------------
InvertiBit PROC
    push ebp
    mov ebp, esp
    mov eax, [ebp + 8]
    not eax
    pop ebp
    ret
InvertiBit ENDP

; -----------------------------------------------------------------------------
; Funzione: IsolaBit
; Descrizione: Ritorna 1 se l' n-esimo bit è acceso, altrimenti 0
; Input: [ebp + 8]  -> numero
;        [ebp + 12] -> posizione n (0-31)
; -----------------------------------------------------------------------------
IsolaBit PROC
    push ebp
    mov ebp, esp
    
    mov eax, [ebp + 8]  ; Carica il numero
    mov ecx, [ebp + 12] ; Carica la posizione
    
    chr eax, cl         ; Scarta i bit a destra (sposta il bit desiderato in posizione 0)
    ; Attenzione: SHR non va bene se vogliamo solo isolare senza spostare.
    ; Usiamo uno shift e poi un AND.
    
    mov eax, [ebp + 8]
    mov ecx, [ebp + 12]
    
    ; Creiamo una maschera dinamica spostando l'1 a sinistra
    mov edx, 1
    shl edx, cl         ; EDX ora ha solo l' n-esimo bit acceso
    
    and eax, edx        ; EAX ora ha il valore del bit o zero
    
    ; Trasformiamo in 0 o 1 pulito per C#
    jz bit_zero
    mov eax, 1
    jmp fine
bit_zero:
    xor eax, eax
fine:
    pop ebp
    ret
IsolaBit ENDP

END
