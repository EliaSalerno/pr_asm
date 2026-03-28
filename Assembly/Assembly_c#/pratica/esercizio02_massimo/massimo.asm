; =============================================================================
; ESERCIZIO 2 — Massimo tra due interi
; =============================================================================
; Funzione: int Massimo(int a, int b)
; Ritorna:  il maggiore tra a e b
;
; OBIETTIVI DIDATTICI:
;   - Uso di CMP e salti condizionali (JGE)
;   - If/else in Assembly
; =============================================================================

.486
.MODEL FLAT, C
.CODE

PUBLIC Massimo

; -----------------------------------------------------------------------------
; int Massimo(int a, int b)
; Logica C#: return (a >= b) ? a : b;
; -----------------------------------------------------------------------------
Massimo PROC
    ; === PROLOGO ===
    push ebp
    mov  ebp, esp

    ; === CORPO ===
    mov  eax, [ebp + 8]    ; Carica 'a' in EAX (ipotizziamo sia il massimo)
    mov  ecx, [ebp + 12]   ; Carica 'b' in ECX per il confronto

    ; CMP sottrae idealmente i due operandi (eax - ecx) e aggiorna i FLAG
    cmp  eax, ecx          
    
    ; JGE = Jump if Greater or Equal. Salta se EAX >= ECX.
    jge  gia_massimo       

    ; Se NON abbiamo saltato, significa che ECX (b) è maggiore di EAX (a).
    mov  eax, ecx          ; Sovrascriviamo EAX con il vero massimo (b)

gia_massimo:
    ; Qui arriviamo in entrambi i casi. EAX contiene comunque il valore maggiore.

    ; === EPILOGO ===
    mov  esp, ebp
    pop  ebp
    ret
Massimo ENDP

END
