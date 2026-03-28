; =============================================================================
; ESERCIZIO 3 — Fattoriale iterativo
; =============================================================================
; Funzione: int Fattoriale(int n)
; Ritorna:  n! = n × (n-1) × ... × 1   (0! = 1)
;
; OBIETTIVI DIDATTICI:
;   - Ciclo in Assembly (jg + jmp)
;   - Uso di più registri insieme (EAX accumulatore, ECX contatore)
;   - Gestione del caso base (n = 0 o n = 1)
; =============================================================================

.486
.MODEL FLAT, C
.CODE

PUBLIC Fattoriale

; -----------------------------------------------------------------------------
; int Fattoriale(int n)
; Calcola n! in modo iterativo (usando un ciclo)
; -----------------------------------------------------------------------------
Fattoriale PROC
    ; === PROLOGO ===
    push ebp
    mov  ebp, esp

    ; === CORPO ===
    mov  ecx, [ebp + 8]    ; ECX fungerà da contatore decrescente (i = n, n-1, ...)
    mov  eax, 1             ; EAX è l'accumulatore del risultato (inizializzato a 1)

    ; Gestione caso base: se n <= 1, ritorna immediatamente 1 (EAX è già 1)
    cmp  ecx, 1
    jle  fine_ciclo        

ciclo:
    ; IMUL moltiplica EAX per l'operando indicato (EAX = EAX * ECX)
    imul eax, ecx          
    
    dec  ecx                ; Decrementa il contatore (i--)
    
    cmp  ecx, 1             ; Controlla se abbiamo finito (siamo arrivati a 1?)
    jg   ciclo              ; Se ECX > 1, ripeti il ciclo

fine_ciclo:
    ; === EPILOGO ===
    mov  esp, ebp
    pop  ebp
    ret
Fattoriale ENDP

END
