Per stampare un valore intero in assembly x86 a 16 bit, ecco alcuni esempi di come farlo:

## Esempio con interruzione DOS (INT 21h)

```assembly
.model small
.stack 100h
.data
    numero dw 1234          ; numero da stampare
    buffer db 6 dup('$')    ; buffer per la conversione
    
.code
main proc
    mov ax, @data
    mov ds, ax
    
    ; Carica il numero da stampare
    mov ax, numero
    
    ; Converte il numero in stringa
    call converti_numero
    
    ; Stampa la stringa
    mov dx, offset buffer
    mov ah, 09h             ; funzione DOS per stampare stringa
    int 21h
    
    ; Termina il programma
    mov ax, 4c00h
    int 21h
main endp

; Procedura per convertire numero in stringa
converti_numero proc
    mov bx, 10              ; divisore
    mov cx, 0               ; contatore cifre
    mov si, offset buffer
    add si, 4               ; punta alla fine del buffer
    mov byte ptr [si+1], '$' ; terminatore stringa
    
converti_loop:
    xor dx, dx              ; azzera dx per la divisione
    div bx                  ; ax = ax/10, dx = resto
    add dl, '0'             ; converte cifra in ASCII
    mov [si], dl            ; memorizza la cifra
    dec si                  ; sposta il puntatore
    inc cx                  ; incrementa contatore
    test ax, ax             ; controlla se ax = 0
    jnz converti_loop       ; continua se non zero
    
    ; Sposta la stringa all'inizio del buffer
    inc si
    mov di, offset buffer
sposta_loop:
    mov al, [si]
    mov [di], al
    inc si
    inc di
    cmp al, '$'
    jne sposta_loop
    
    ret
converti_numero endp

end main
```

## Versione semplificata per numeri a singola cifra

```assembly
.model small
.stack 100h
.code
main proc
    mov ax, 5               ; numero da stampare (0-9)
    add al, '0'             ; converte in ASCII
    mov dl, al
    mov ah, 02h             ; funzione DOS per stampare carattere
    int 21h
    
    mov ax, 4c00h
    int 21h
main endp
end main
```

## Esempio con BIOS (INT 10h)

```assembly
.model small
.stack 100h
.code
main proc
    mov ax, 1234            ; numero da stampare
    call stampa_numero
    
    mov ax, 4c00h
    int 21h
main endp

stampa_numero proc
    mov bx, 10
    mov cx, 0
    
    ; Estrae le cifre e le mette nello stack
estrai_cifre:
    xor dx, dx
    div bx
    push dx                 ; mette la cifra nello stack
    inc cx
    test ax, ax
    jnz estrai_cifre
    
    ; Stampa le cifre dallo stack
stampa_cifre:
    pop dx
    add dl, '0'             ; converte in ASCII
    mov ah, 0eh             ; funzione BIOS teletype
    int 10h
    loop stampa_cifre
    
    ret
stampa_numero endp
end main
```

## Note importanti:

1. **INT 21h**: Interruzione DOS per I/O
2. **INT 10h**: Interruzione BIOS per video
3. La conversione da numero binario a stringa ASCII richiede divisioni successive per 10
4. Il buffer deve essere abbastanza grande per contenere tutte le cifre più il terminatore
5. Per numeri negativi, bisogna gestire il segno separatamente