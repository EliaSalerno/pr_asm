; =============================================================================
; ESERCIZIO 1 — Somma di due interi
; =============================================================================
; Funzione: int Somma(int a, int b)
; Ritorna:  a + b
;
; OBIETTIVI DIDATTICI:
;   - Prima funzione Assembly completa
;   - Prologo ed epilogo standard
;   - Accesso ai parametri tramite EBP
;   - Valore di ritorno in EAX
; =============================================================================

.486
.MODEL FLAT, C
.CODE

PUBLIC Somma

; -----------------------------------------------------------------------------
; int Somma(int a, int b)
; Parametri:
;   [EBP + 8]  = a (4 byte)
;   [EBP + 12] = b (4 byte)
; Ritorna (in EAX): a + b
; -----------------------------------------------------------------------------
Somma PROC
    ; === PROLOGO ===
    ; Serve a creare un nuovo 'stack frame' per questa funzione
    push ebp              ; Salva il Base Pointer del chiamante (C#) per ripristinarlo dopo
    mov  ebp, esp         ; Imposta EBP come riferimento fisso per accedere ai parametri

    ; === CORPO ===
    ; In Assembly x86, non possiamo sommare due locazioni di memoria direttamente.
    ; Dobbiamo passare attraverso un registro (EAX).
    mov  eax, [ebp + 8]   ; Carica il primo parametro 'a' nel registro EAX
    add  eax, [ebp + 12]  ; Somma il secondo parametro 'b' al valore in EAX (EAX = EAX + b)
    
    ; La convenzione cdecl prevede che il valore di ritorno sia in EAX.
    ; Quindi non dobbiamo fare altro con il risultato.

    ; === EPILOGO ===
    ; Ripristina lo stato precedente della CPU prima di ritornare
    mov  esp, ebp         ; Elimina le eventuali variabili locali (qui non ci sono, ma è buona norma)
    pop  ebp              ; Ripristina il Base Pointer originale del chiamante
    ret                   ; Ritorna al chiamante (C#) leggendo l'indirizzo di ritorno dallo stack
Somma ENDP

END
