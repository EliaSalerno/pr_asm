DOSSEG
    .MODEL SMALL
    .STACK 100h

.DATA
    n1 DB 01h
    n2 DB 02h

.CODE
    main:
        MOV ax, @DATA
        MOV ds, ax
    
        MOV al, n1
        MOV bl, n2
        xor al, bl
        xor bl, al
        xor al, bl ; scambiati

        MOV ax, 4C00h
        INT 21h
    END main