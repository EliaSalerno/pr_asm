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
<summary>Compilazione piu' corretta</summary>Ã
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
```
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
```

Unica ma non lieve differenza che qui lo stack lo organizza nel main, libera 16 byte anche se ne bastano 12 per le variabili locali....
Azzera eax perche' in effetti non e' una vera procedura.... e salva il risultato nella prima variabile locale....
