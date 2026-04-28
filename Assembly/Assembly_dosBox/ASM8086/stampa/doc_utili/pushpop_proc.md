Ecco un esempio completo di una procedura in assembly 8086 che utilizza PUSH e POP per preservare i registri:

```assembly
.MODEL SMALL
.STACK 100h
.DATA
    numero1 DW 15
    numero2 DW 25
    risultato DW ?
    msg DB 'Risultato: $'

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    ; Carica i parametri
    MOV AX, numero1
    MOV BX, numero2
    
    ; Chiama la procedura
    CALL SOMMA_QUADRATI
    
    ; Salva il risultato
    MOV risultato, AX
    
    ; Termina il programma
    MOV AH, 4Ch
    INT 21h
MAIN ENDP

; Procedura che calcola la somma dei quadrati di due numeri
; Input: AX = primo numero, BX = secondo numero
; Output: AX = AX² + BX²
SOMMA_QUADRATI PROC
    ; Salva i registri che useremo (tranne AX che contiene il risultato)
    PUSH BX          ; Salva BX
    PUSH CX          ; Salva CX
    PUSH DX          ; Salva DX
    
    ; Calcola AX²
    MOV CX, AX       ; Copia AX in CX
    MUL CX           ; AX = AX * CX = AX²
    MOV CX, AX       ; Salva AX² in CX
    
    ; Ripristina BX e calcola BX²
    MOV AX, BX       ; AX = BX
    MUL AX           ; AX = BX²
    
    ; Somma i quadrati
    ADD AX, CX       ; AX = AX² + BX²
    
    ; Ripristina i registri nell'ordine inverso
    POP DX           ; Ripristina DX
    POP CX           ; Ripristina CX
    POP BX           ; Ripristina BX
    
    RET              ; Ritorna al chiamante
SOMMA_QUADRATI ENDP

END MAIN
```

## Esempio più semplice con spiegazione dettagliata:

```assembly
; Procedura che moltiplica un numero per 3
; Input: AX = numero da moltiplicare
; Output: AX = numero * 3

MOLTIPLICA_PER_TRE PROC
    PUSH BX          ; Salva BX nello stack
    PUSH CX          ; Salva CX nello stack
    
    ; Algoritmo: N * 3 = N + N + N
    MOV BX, AX       ; BX = N
    MOV CX, AX       ; CX = N
    ADD AX, BX       ; AX = N + N = 2N
    ADD AX, CX       ; AX = 2N + N = 3N
    
    POP CX           ; Ripristina CX (ordine inverso!)
    POP BX           ; Ripristina BX
    
    RET
MOLTIPLICA_PER_TRE ENDP
```

## Punti chiave da ricordare:

1. **Ordine LIFO**: I registri vengono ripristinati nell'ordine **inverso** rispetto al salvataggio
2. **PUSH salva**, **POP ripristina**: 
   - `PUSH reg` mette il registro nello stack
   - `POP reg` preleva dallo stack e mette nel registro

3. **Bilanciamento**: Ogni PUSH deve avere il suo corrispondente POP

4. **Convenzione**: Generalmente si salvano tutti i registri usati tranne quello che contiene il valore di ritorno

## Esempio di chiamata:
```assembly
MOV AX, 7        ; Carica il numero 7
CALL MOLTIPLICA