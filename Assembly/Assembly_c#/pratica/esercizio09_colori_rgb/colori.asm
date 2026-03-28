.686
.model flat, c
.stack 100h

.code

; -----------------------------------------------------------------------------
; Funzione: CreaColore
; Input: [ebp + 8]  -> Rosso (0-255)
;        [ebp + 12] -> Verde (0-255)
;        [ebp + 16] -> Blu   (0-255)
; Output: EAX        -> 0x00RRGGBB
; -----------------------------------------------------------------------------
CreaColore PROC
    push ebp
    mov ebp, esp
    
    mov eax, [ebp + 8]  ; EAX = R
    shl eax, 16         ; EAX = R << 16
    
    mov ecx, [ebp + 12] ; ECX = G
    shl ecx, 8          ; ECX = G << 8
    
    or eax, ecx         ; EAX = (R << 16) | (G << 8)
    
    mov ecx, [ebp + 16] ; ECX = B
    or eax, ecx         ; EAX = (R << 16) | (G << 8) | B
    
    pop ebp
    ret
CreaColore ENDP

; -----------------------------------------------------------------------------
; Funzione: EstraiVerde
; Input:  [ebp + 8] -> Colore 32-bit (0xRRGGBB)
; Output: EAX       -> Solo il valore del Verde (0-255)
; -----------------------------------------------------------------------------
EstraiVerde PROC
    push ebp
    mov ebp, esp
    
    mov eax, [ebp + 8]  ; EAX = 0xRRGGBB
    shr eax, 8          ; Sposta a destra (EAX = 0x00RRGG)
    and eax, 0FFh       ; Maschera: tieni solo gli ultimi 8 bit (GG)
    
    pop ebp
    ret
EstraiVerde ENDP

END
