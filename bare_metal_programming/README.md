# Programmazione Assembly 8086 Bare Metal (senza sistema operativo)

## Cos'è il Bare Metal?

Programmare **bare metal** significa scrivere codice che gira direttamente sull'hardware,
senza alcun sistema operativo sottostante. Nessun DOS, nessun Windows, nessun Linux —
solo il tuo codice e la CPU.

Questo è esattamente il contesto dove il comportamento dei caratteri di controllo
(come `LF` e `CR`) è **diverso** da quello che si osserva su DOSBox, perché non c'è
nessun driver DOS che modifica il comportamento del terminale.

---

## 8086 vs x86 moderno — cosa cambia nel bare metal?

| Caratteristica | 8086 | 80286+ / x86 moderno |
|----------------|------|----------------------|
| Modalità | Solo Real Mode (16-bit) | Real → Protected → Long Mode |
| Memoria indirizzabile | 1 MB (20 bit) | Fino a 64-bit |
| Segmenti | Obbligatori | Opzionali (in protected mode) |
| Istruzioni extra | No | PUSHA/POPA, ENTER, LEAVE... |
| Prefissi 32-bit | No | `0x66`, `0x67` (operand/address size) |

Il bootloader **è già 8086-compatibile** se usi `BITS 16` in NASM e non usi
istruzioni successive all'8086. Il BIOS avvia sempre in **Real Mode a 16-bit**,
quindi il tuo codice parte nativamente come su un 8086.

---

## Come funziona l'avvio

```
Accensione
    │
    ▼
BIOS (firmware)
    │  ── POST (Power-On Self Test)
    │  ── Inizializza hardware base (tastiera, video, disco)
    │  ── Cerca disco avviabile (controlla byte 511-512 = 0x55AA)
    ▼
MBR (Master Boot Record)
    │  ── Settore 0 del disco, esattamente 512 byte
    │  ── Caricato dal BIOS all'indirizzo fisico 0x7C00
    │  ── CS:IP punta a 0000:7C00
    ▼
IL TUO CODICE GIRA QUI  ←── bare metal puro, nessun OS
```

Il BIOS carica i primi **512 byte** del disco all'indirizzo `0x7C00` in RAM e salta lì.
Da quel momento sei tu a controllare tutto.

---

## Strumenti necessari

| Strumento | Funzione | Installazione |
|-----------|----------|---------------|
| **NASM** | Assembler | `sudo apt install nasm` |
| **QEMU** | Emulatore bare metal | `sudo apt install qemu-system-x86` |
| **dd** | Scrivere immagine su USB | Già incluso in Linux/macOS |

---

## La differenza fondamentale: LF su BIOS vs DOS

Questo è il punto chiave che motiva tutta la guida.

### Su DOSBox / MS-DOS (INT 21h)
Il driver CON di DOS intercetta ogni carattere e **aggiunge automaticamente un CR
quando riceve un LF**. Quindi `0Ah` da solo fa:
- Va alla riga sotto
- Torna a colonna 0 (come se avessi scritto `0Dh 0Ah`)

### Su BIOS puro (INT 10h / AH=0Eh) — bare metal 8086
Il BIOS non fa nessuna interpretazione automatica. Ogni carattere fa esattamente
e **solo** quello che deve fare per definizione:

| Carattere | Codice | Effetto BIOS puro |
|-----------|--------|-------------------|
| LF | `0Ah` | Scende di una riga, **colonna invariata** |
| CR | `0Dh` | Torna a colonna 0, **riga invariata** |
| CR + LF | `0Dh 0Ah` | Torna a colonna 0 e scende di riga |

### Risultato visivo con solo LF

Se stampi tre stringhe separate da solo `0Ah`:

```
Ciao
    Mondo
        Come stai?
```

Il cursore scende ma non torna mai a sinistra → **effetto scaletta**.

---

## Esempio 1 — Bootloader minimale "Hello"

```nasm
; hello_boot.asm
; Bootloader 8086 bare metal minimale
;
; Compilare: nasm -f bin hello_boot.asm -o hello_boot.img
; Testare:   qemu-system-i386 -cpu 8086 -fda hello_boot.img

BITS 16
ORG 0x7C00

start:
    ; Azzera i segmenti — importante su 8086 reale
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00      ; Stack cresce verso il basso, prima del nostro codice

    ; Stampa "Hello!" usando BIOS INT 10h / AH=0Eh
    mov ah, 0x0E        ; funzione TTY output
    mov bh, 0x00        ; pagina video 0

    mov al, 'H'
    int 0x10
    mov al, 'e'
    int 0x10
    mov al, 'l'
    int 0x10
    mov al, 'l'
    int 0x10
    mov al, 'o'
    int 0x10
    mov al, '!'
    int 0x10

halt:
    cli                 ; Disabilita interrupt
    hlt                 ; Ferma la CPU

; Padding e firma di boot obbligatoria
times 510-($-$$) db 0   ; Riempi fino al byte 510
dw 0xAA55               ; Firma: il BIOS controlla questi 2 byte
```

Compila e testa:
```bash
nasm -f bin hello_boot.asm -o hello_boot.img
qemu-system-i386 -cpu 8086 -fda hello_boot.img
```

---

## Esempio 2 — Stampa con routine riutilizzabile

Più pratico: una routine che stampa una stringa terminata da `0`.

```nasm
; stringa_boot.asm
; Stampa stringhe con routine riutilizzabile
;
; Compilare: nasm -f bin stringa_boot.asm -o stringa_boot.img
; Testare:   qemu-system-i386 -cpu 8086 -fda stringa_boot.img

BITS 16
ORG 0x7C00

start:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    ; Stampa prima stringa
    mov si, msg1
    call print_string

    ; Stampa seconda stringa
    mov si, msg2
    call print_string

halt:
    cli
    hlt

; ── Routine: print_string ──────────────────────────────────────
; Input: SI = puntatore alla stringa (terminata da 0)
; Modifica: AX, SI
print_string:
    mov ah, 0x0E
    mov bh, 0x00
.loop:
    lodsb               ; AL = [SI], SI++
    test al, al         ; controlla se AL == 0
    jz .done
    int 0x10
    jmp .loop
.done:
    ret

; ── Dati ──────────────────────────────────────────────────────
msg1 db 'Prima riga', 0x0D, 0x0A, 0   ; CR + LF corretto
msg2 db 'Seconda riga', 0x0D, 0x0A, 0

times 510-($-$$) db 0
dw 0xAA55
```

---

## Esempio 3 — Dimostrazione LF vs CR+LF (il test che ci interessa!)

Questo esempio dimostra visivamente la differenza tra `LF` solo e `CR+LF`
su BIOS puro senza DOS.

```nasm
; lf_vs_crlf.asm
; Dimostra il comportamento di LF senza CR su BIOS 8086 puro
;
; Compilare: nasm -f bin lf_vs_crlf.asm -o lf_vs_crlf.img
; Testare:   qemu-system-i386 -cpu 8086 -fda lf_vs_crlf.img

BITS 16
ORG 0x7C00

start:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    ; ── PARTE 1: Solo LF (0Ah) ──────────────────────────────
    ; Risultato atteso: effetto scaletta (colonna NON torna a 0)
    mov si, titolo1
    call print_string

    mov si, riga_A          ; "AAA" seguito da solo 0Ah
    call print_string
    mov si, riga_B          ; "BBB" seguito da solo 0Ah
    call print_string
    mov si, riga_C          ; "CCC" seguito da solo 0Ah
    call print_string

    ; Pausa: aspetta pressione tasto prima di continuare
    mov ah, 0x00
    int 0x16                ; BIOS: attendi tasto

    ; Pulisci schermo
    call clear_screen

    ; ── PARTE 2: CR + LF (0Dh 0Ah) ─────────────────────────
    ; Risultato atteso: righe allineate a sinistra
    mov si, titolo2
    call print_string

    mov si, riga_D          ; "DDD" seguito da 0Dh + 0Ah
    call print_string
    mov si, riga_E          ; "EEE" seguito da 0Dh + 0Ah
    call print_string
    mov si, riga_F          ; "FFF" seguito da 0Dh + 0Ah
    call print_string

halt:
    cli
    hlt

; ── Routine: print_string ──────────────────────────────────────
print_string:
    mov ah, 0x0E
    mov bh, 0x00
.loop:
    lodsb
    test al, al
    jz .done
    int 0x10
    jmp .loop
.done:
    ret

; ── Routine: clear_screen ──────────────────────────────────────
; Usa INT 10h AH=00h: reimposta modalità video (pulisce lo schermo)
clear_screen:
    mov ah, 0x00
    mov al, 0x03            ; modalità testo 80x25 colori
    int 0x10
    ret

; ── Dati ──────────────────────────────────────────────────────

; Titoli
titolo1  db 'PARTE 1: Solo LF (0Ah) - effetto scaletta:', 0x0D, 0x0A, 0
titolo2  db 'PARTE 2: CR+LF (0Dh,0Ah) - allineato:', 0x0D, 0x0A, 0

; Righe con SOLO LF — il cursore scende ma NON torna a colonna 0
riga_A   db 'AAA', 0x0A, 0      ; solo LF
riga_B   db 'BBB', 0x0A, 0      ; solo LF
riga_C   db 'CCC', 0x0A, 0      ; solo LF

; Righe con CR+LF — comportamento corretto
riga_D   db 'DDD', 0x0D, 0x0A, 0
riga_E   db 'EEE', 0x0D, 0x0A, 0
riga_F   db 'FFF', 0x0D, 0x0A, 0

times 510-($-$$) db 0
dw 0xAA55
```

### Output atteso — Parte 1 (solo LF):
```
PARTE 1: Solo LF (0Ah) - effetto scaletta:
AAA
   BBB
      CCC
```

### Output atteso — Parte 2 (CR+LF):
```
PARTE 2: CR+LF (0Dh,0Ah) - allineato:
DDD
EEE
FFF
```

---

## Esempio 4 — Bootloader con output esadecimale

Utile per debug: stampa il valore di un registro in esadecimale.

```nasm
; hex_debug.asm
; Stampa valori in esadecimale — utile per debug bare metal
;
; Compilare: nasm -f bin hex_debug.asm -o hex_debug.img
; Testare:   qemu-system-i386 -cpu 8086 -fda hex_debug.img

BITS 16
ORG 0x7C00

start:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    mov si, msg_ax
    call print_string

    mov ax, 0x1234      ; valore di esempio da stampare
    call print_hex      ; stampa AX in esadecimale

    mov ah, 0x0E
    mov al, 0x0D
    int 0x10            ; CR
    mov al, 0x0A
    int 0x10            ; LF

halt:
    cli
    hlt

; ── Routine: print_string ──────────────────────────────────────
print_string:
    mov ah, 0x0E
    mov bh, 0x00
.loop:
    lodsb
    test al, al
    jz .done
    int 0x10
    jmp .loop
.done:
    ret

; ── Routine: print_hex ─────────────────────────────────────────
; Input: AX = valore a 16 bit da stampare
; Stampa 4 cifre hex precedute da "0x"
print_hex:
    push ax
    push bx
    push cx

    ; Stampa prefisso "0x"
    mov ah, 0x0E
    mov bh, 0x00
    mov al, '0'
    int 0x10
    mov al, 'x'
    int 0x10

    pop cx              ; ripristina AX in CX per lavorarci
    pop bx
    pop ax
    push ax

    mov cx, 4           ; 4 cifre hex
.hex_loop:
    rol ax, 4           ; porta il nibble più significativo in basso
    mov bx, ax
    and bx, 0x000F      ; isola i 4 bit bassi
    mov bl, byte [hex_chars + bx]   ; converti in carattere ASCII
    mov ah, 0x0E
    mov bh, 0x00
    mov al, bl
    int 0x10
    loop .hex_loop

    pop ax
    ret

; ── Dati ──────────────────────────────────────────────────────
msg_ax    db 'AX = ', 0
hex_chars db '0123456789ABCDEF'

times 510-($-$$) db 0
dw 0xAA55
```

---

## Testare su QEMU emulando 8086

### Comando base
```bash
nasm -f bin mio_boot.asm -o mio_boot.img
qemu-system-i386 -cpu 8086 -fda mio_boot.img
```

### Opzioni utili di QEMU

```bash
# Finestra più grande
qemu-system-i386 -cpu 8086 -fda mio_boot.img -vga std

# Avvio senza GUI (output su terminale) — utile per debugging
qemu-system-i386 -cpu 8086 -fda mio_boot.img -nographic

# Con monitor QEMU per debug (Ctrl+Alt+2 per accedervi)
qemu-system-i386 -cpu 8086 -fda mio_boot.img -monitor stdio

# Log di debug CPU
qemu-system-i386 -cpu 8086 -fda mio_boot.img -d cpu,int 2> debug.log
```

### Verificare i flag di avvio (monitor QEMU)
Con `-monitor stdio` puoi digitare comandi mentre gira:
```
info registers    → mostra tutti i registri
x /10i 0x7c00    → disassembla 10 istruzioni da 0x7C00
x /512b 0x7c00   → dump dei 512 byte del bootloader
```

---

## Testare su USB reale (hardware fisico 8086/compatibile)

> ⚠️ **Attenzione**: `dd` sovrascrive l'intero dispositivo. Assicurati di usare
> il dispositivo giusto (`/dev/sdX`).

```bash
# Individua la tua USB
lsblk

# Scrivi il bootloader sulla USB (sostituisci sdX con il tuo dispositivo)
sudo dd if=mio_boot.img of=/dev/sdX bs=512 count=1

# Sincronizza
sync
```

Poi avvia il PC da USB nel BIOS (tasto F12, F8 o DEL all'avvio).

---

## Struttura della memoria 8086 al boot

```
Indirizzo fisico    Contenuto
─────────────────────────────────────────
0x00000 - 0x003FF   IVT (Interrupt Vector Table) — 256 vettori x 4 byte
0x00400 - 0x004FF   BDA (BIOS Data Area)
0x00500 - 0x07BFF   Area libera (~30 KB) — puoi usarla per stack/dati
0x07C00 - 0x07DFF   Il tuo bootloader (512 byte) ← sei qui
0x07E00 - 0x9FFFF   Area libera (~608 KB) — per codice/dati aggiuntivi
0xA0000 - 0xBFFFF   Video RAM
0xC0000 - 0xFFFFF   ROM BIOS e option ROMs
```

---

## Riepilogo: LF e CR su BIOS 8086 puro

| Contesto | `0Ah` (LF) solo | `0Dh 0Ah` (CR+LF) |
|----------|-----------------|-------------------|
| **DOSBox / MS-DOS** | ✅ Va a capo + colonna 0 (driver DOS) | ✅ Identico |
| **BIOS 8086 puro** (INT 10h) | ⚠️ Scende riga, colonna **invariata** | ✅ Va a capo + colonna 0 |
| **Hardware seriale / stampante** | ⚠️ Solo avanzamento riga | ✅ Corretto ovunque |

**Conclusione**: su bare metal 8086, `0Ah` da solo produce l'effetto scaletta.
Per un comportamento corretto e portabile, usa sempre `0Dh, 0Ah`.

---

## Riferimenti utili

- **RBIL** (Ralf Brown's Interrupt List) — documentazione completa di tutti gli interrupt BIOS
- **OSDev Wiki** — https://wiki.osdev.org/  (risorsa principale per bare metal)
- **NASM Manual** — https://www.nasm.us/doc/
- **QEMU docs** — https://www.qemu.org/docs/master/
