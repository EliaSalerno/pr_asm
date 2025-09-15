# ASSEMBLY... ROBA DA MATTI

### Impariamo ad usare assembly mediante esercitazioni

```
Ho creato un container in docker, sfruttando un ubuntu 32 bit.
Operazioni:
 - update upgrade autoremove;
 - install git, nano, gcc, nasm, gas;
 - create directory: prima_prova;

```
## Fasi di test

<details>
<summary>Prima prova (history)</summary>
Ho creato un programma che inverte un vettore inserito da tastira in c, 
poi ho compilato il c con gcc e con il medesimo compilatore ho assemblato lo stesso file. 
</details>
<details>
<summary> Primo test (history2)</summary>
Finito male la compilazione del file .s deve essere effettuata con gas. 
Da questo passaggio si crea il file .o (oggetto).
</details>
<details>
<summary> Secondo test (history3)</summary>
Ho scoperto che sia gas che nasm lavorano male con le librerie di c,
problema che invece non ha gcc. Infatti lavorando solo con gcc si puo'
tranquillamente superare il problema dettato dal c su assembly
</details>
<details>
<summary>Compilazione piu' corretta</summary>�
Per generare il file .s per l'architettura a 32bit, purtroppo non basta il comando gcc -S file.c;
questo probabilmente perche' nonostante il kernel a 32 bit genera un file coerente con l'architettura
del processore.... o piu' semplicemente il SO da me trovato si finge un 32bit ma in realta' si tratta 
di un 64... 
Comunque il comando piu' corretto e' il seguente:
	gcc -S -masm=intel m32 nome_file.c
</details>

## Analisi lavoro
Dopo le fasi di analisi, ho compreso un dettaglio di non poco conto. Questo dettaglio e' presente nella terza prova della cartella test
In questa prova ho creato un file.c con solo il main - la dichiarazione di 3 variabili - l'assegnazione delle prime 2 e una somma nella terza.
Ho generato l'assembler di questo semplice codice e il risultato mi ha lasciato inizialmente basito poi, ragionandoci sopra ... sorpreso.
La conversione ha generato un file che tratta il main come una procedura, in effetti ad inizio procedura si ha la push di ebp, il salvataggio di esp in ebp,
e tutte le conseguenti operazioni di popolamento dello stack. 

main:
.LFB0:
        .cfi_startproc
        push    ebp
        .cfi_def_cfa_offset 8
        .cfi_offset 5, -8
        mov     ebp, esp
        .cfi_def_cfa_register 5
        sub     esp, 16
        mov     DWORD PTR [ebp-12], 1
        mov     DWORD PTR [ebp-8], 2
        mov     edx, DWORD PTR [ebp-8]
        mov     eax, DWORD PTR [ebp-12]
        add     eax, edx
        mov     DWORD PTR [ebp-4], eax
        mov     eax, 0
        leave
        .cfi_restore 5
        .cfi_def_cfa 4, 4
        ret
        .cfi_endproc


Unica ma non lieve differenza che qui lo stack lo organizza nel main, libera 16 byte anche se ne bastano 12 per le variabili locali....
Azzera eax perche' in effetti non e' una vera procedura.... e salva il risultato nella prima variabile locale....

Esempio funzione
```
section .data
    #; variabili se necessario

section .text
    global _start

#; Funzione per sommare due numeri
#; Parametri:
#;   - first number in [esp+4]
#;   - second number in [esp+8]
#; Restituisce la somma in eax
add_numbers:
    push ebp            #; salva il base pointer
    mov ebp, esp        #; imposta il base pointer
    mov eax, [ebp+8]    #; primo numero
    mov ebx, [ebp+12]   #; secondo numero
    add eax, ebx        #; somma
    pop ebp             #; ripristina il base pointer
    ret

_start:
    #; passo i parametri alla funzione sulla pila
    push 20             #; secondo numero
    push 10             #; primo numero
    call add_numbers    #; chiama funzione

    #; risultato della somma ora in eax
    #; se vuoi terminare il programma passando il risultato come codice di uscita
    mov ebx, eax        #; copia risultato in ebx per l'uso di eax in exit
    mov eax, 1          #; syscall number per exit in Linux
    int 0x80            #; chiamata al kernel
```
Esempio semplice di funzione che somma due numeri

Print su linux ... in assembly (senza c)
```
section .data
    message db 'Ciao, è una stampa in Assembly!', 0xA
    msg_len equ $ - message

section .text
    global _start

_start:
    #; scrivere il messaggio
    mov eax, 4          #; syscall per sys_write
    mov ebx, 1          #; file descriptor 1 = stdout
    mov ecx, message    #; indirizzo del messaggio
    mov edx, msg_len    #; lunghezza del messaggio
    int 0x80            #; chiamata al kernel

    #; terminare il programma
    mov eax, 1          #; syscall per sys_exit
    xor ebx, ebx        #; codice di uscita 0
    int 0x80
```
Print su windows ... in assembly (senza c)
```
#; stampa.asm
#; Assembla con: nasm -f win32 stampa.asm
#; Linka con: link /SUBSYSTEM:WINDOWS stampa.obj

extern _MessageBoxA@16 #; Importa la funzione MessageBoxA da user32.dll
extern _ExitProcess@4  #; Importa la funzione ExitProcess da kernel32.dll

section .data
    titolo db "Saluto", 0  #; Titolo della finestra di messaggio
    messaggio db "Ciao, mondo!", 0 #; Messaggio da visualizzare

section .text
    global _main  #; Etichetta punto di ingresso per il linker

_main:
    #; Chiama MessageBoxA per visualizzare il messaggio
    push dword 0      #; uType = MB_OK (nessun bottone speciale)
    push dword messaggio #; lpText = Indirizzo del messaggio
    push dword titolo   #; lpCaption = Indirizzo del titolo
    push dword 0      #; hWnd = NULL (nessuna finestra padre)
    call _MessageBoxA@16 #; Chiama la funzione MessageBoxA

    #; Chiama ExitProcess per terminare il programma
    push dword 0      #; uExitCode = 0 (uscita senza errori)
    call _ExitProcess@4  #; Chiama la funzione ExitProcess
```

### Comandi utili per lavorare in git passando dal c

```
    gcc -c -masm=intel -m32 file.c --> converte in formato asm intel il c
    gcc -o file file.s
```