.686
.model flat, c
.stack 100h

.code
; -----------------------------------------------------------------------------
; Nome Funzione: CalcolaMedia
; Descrizione: Calcola (a + b) / 2 usando una variabile locale per la somma
; -----------------------------------------------------------------------------
CalcolaMedia PROC
    ; === PROLOGO ===
    push ebp            ; Salva il vecchio base pointer
    mov ebp, esp        ; Imposta il frame corrente
    sub esp, 4          ; Alloca 4 byte per una variabile locale (somma)

    ; [ebp + 8]  -> Parametro a
    ; [ebp + 12] -> Parametro b
    ; [ebp - 4]  -> Variabile locale (somma temporanea)

    ; === CORPO ===
    mov eax, [ebp + 8]  ; EAX = a
    add eax, [ebp + 12] ; EAX = a + b
    
    mov [ebp - 4], eax  ; SALVA nella variabile locale lo stato intermedio
    
    ; Recuperiamo per dimostrare l'uso dello stack
    mov eax, [ebp - 4]  ; EAX = somma
    sar eax, 1          ; Divide per 2 (Shift Arithmetic Right per mantenere il segno)

    ; === EPILOGO ===
    mov esp, ebp        ; Rilascia lo spazio della variabile locale
    pop ebp             ; Ripristina il base pointer
    ret
CalcolaMedia ENDP

END
