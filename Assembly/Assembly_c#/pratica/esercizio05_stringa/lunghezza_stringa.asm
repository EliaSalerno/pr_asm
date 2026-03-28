; =============================================================================
; ESERCIZIO 5 — Lunghezza di una stringa
; =============================================================================
; Funzione: int LunghezzaStringa(char* s)
; Ritorna:  il numero di caratteri nella stringa (senza il terminatore '\0')
;
; OBIETTIVI DIDATTICI:
;   - Puntatori a caratteri (byte pointer)
;   - Ciclo con condizione sul valore letto (strcmp stile)
;   - Uso di BYTE PTR per accedere a un singolo byte
;   - Differenza tra DWORD e BYTE in memoria
; =============================================================================

.486
.MODEL FLAT, C
.CODE

PUBLIC LunghezzaStringa

; -----------------------------------------------------------------------------
; int LunghezzaStringa(char* s)
; Ritorna il numero di caratteri escludendo il terminatore nullo (0).
; -----------------------------------------------------------------------------
LunghezzaStringa PROC
    ; === PROLOGO ===
    push ebp
    mov  ebp, esp
    push esi               

    ; === CORPO ===
    mov  esi, [ebp + 8]    ; Carica l'indirizzo della stringa (puntatore)
    xor  eax, eax          ; EAX sarà il nostro contatore (inizializzato a 0)

ciclo:
    ; Legge un singolo BYTE dalla memoria.
    ; BYTE PTR specifica che vogliamo solo 1 byte, non 4.
    ; MOVZX (Move with Zero eXtend) porta il byte (8 bit) in un registro a 32 bit (ECX).
    movzx ecx, BYTE PTR [esi + eax]  
    
    ; TEST esegue un AND logico ma non salva il risultato, serve solo a settare i flag.
    ; 'test ecx, ecx' è il modo più rapido per vedere se un registro è zero.
    test  ecx, ecx                    
    
    ; JZ = Jump if Zero. Se abbiamo trovato lo '0' (fine stringa), saltiamo alla fine.
    jz    fine_ciclo                  

    inc   eax              ; Altrimenti incrementa il contatore (lunghezza++)
    jmp   ciclo            ; Ricomincia il ciclo dal prossimo byte

fine_ciclo:
    ; === EPILOGO ===
    pop  esi
    mov  esp, ebp
    pop  ebp
    ret
LunghezzaStringa ENDP

END
