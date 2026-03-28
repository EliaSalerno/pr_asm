; =============================================================================
; ESERCIZIO 4 — Somma degli elementi di un array
; =============================================================================
; Funzione: int SommaArray(int* array, int lunghezza)
; Ritorna:  la somma di tutti gli elementi dell'array
;
; OBIETTIVI DIDATTICI:
;   - Passaggio di un puntatore come parametro
;   - Indirizzamento base + indice × scala  [ESI + ECX*4]
;   - Ciclo con contatore e accesso indicizzato alla memoria
; =============================================================================

.486
.MODEL FLAT, C
.CODE

PUBLIC SommaArray

; -----------------------------------------------------------------------------
; int SommaArray(int* array, int lunghezza)
; Parametri:
;   [EBP + 8]  = Indirizzo base dell'array in RAM
;   [EBP + 12] = Numero di elementi
; -----------------------------------------------------------------------------
SommaArray PROC
    ; === PROLOGO ===
    push ebp
    mov  ebp, esp
    
    ; Salviamo ESI perché la convenzione cdecl dice che dobbiamo preservarlo.
    ; Se lo usiamo e lo sporchiamo, C# potrebbe crashare al ritorno.
    push esi               

    ; === CORPO ===
    mov  esi, [ebp + 8]    ; Carica l'indirizzo dell'array in ESI (Source Index)
    mov  ecx, [ebp + 12]   ; Carica la lunghezza in ECX per il controllo ciclo
    xor  eax, eax          ; Azzera EAX (risultato) usando XOR (più veloce di MOV EAX, 0)

    ; Se la lunghezza è 0 o negativa, esci subito
    cmp  ecx, 0
    jle  fine_ciclo

    xor  edx, edx          ; EDX fungerà da indice i = 0

ciclo:
    ; Indirizzamento complesso: [base + indice * scala]
    ; Poiché gli int sono a 32 bit (4 byte), moltiplichiamo l'indice per 4.
    add  eax, [esi + edx*4] 
    
    inc  edx               ; i++
    cmp  edx, ecx          ; Siamo arrivati alla fine? (i < lunghezza)
    jl   ciclo

fine_ciclo:
    ; === EPILOGO ===
    pop  esi               ; Ripristina il valore originale di ESI
    mov  esp, ebp
    pop  ebp
    ret
SommaArray ENDP

END
