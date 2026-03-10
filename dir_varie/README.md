# ASSEMBLY... ROBA DA MATTI

### Impariamo ad usare assembly mediante esercitazioni

```
Ho creato un container in docker, sfruttando un ubuntu 32 bit.
Operazioni:
 - update upgrade autoremove;
 - install git, nano, gcc, nasm, gas;
 - create directory: prima_prova;

```
### Comandi utili per docker
```
	docker build -t nome_immagine .
	# nella medesima cartella del dockerfile
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
	gcc -S -masm=intel -m32 nome_file.c
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

## Gli ultimi aggiornamenti del repo

Negli ultimi aggiornamenti ho introdotto l'uso di dotnet di windows per la gestione di un asm prima sotto c e poi sotto c#.
Risulta essere più comodo per lo storico dei ragazzi dato il contributo offerto dalle ore di informatica. 
In breve creo un progetto c# in una directory dedicata. Nella cartella di progetto gestisco il file csproj in modo da forzare dotnet su un sistema a 32 bit, 
successivamente genero un file asm in cui immetto una funzione che verrà poi chiamata nel Program.cs. 
Dobbiamo generare un dll nativo senza entrypoint (DllMain), per questo motivo andrà gestito nella generazione del dll inserendo l'opzione "/noentry";
inoltre il dll gestito da stdcall (che sarebbe la convenzione che usiamo noi), viene esposto con un nome "particolare", per ovviare a questo problema 
dobbiamo creare un .def che definisca il nuovo nome da esportare. dotnet build - copiamo il dll nel bin\debug\net8.0-9.0 - dotnet run e il gioco è fatto. 

# Ebbene conviene scrivere tutto

## Assembly in dll da dotnet

### Primo passo realizzare la directori del progetto

Consiglio di lavorare da "Developer Powershell for VS", che credo si installi insieme a visual studio
```
mkdir AsmDotNet (oppure md da prompt o powershell)
cd AsmDotNet
dotnet new console
```

Per aprire i nostri file utilizziamo il seguente comando:

```
notepad Nomefile.asm
```

Una volta creata la directory e aver creato un nuovo progetto di .net in csharp, bisogna forzare dotnet a ragionare in x86 cioè nel nostro caso in 32 bit.<br>
Per ottenere ciò bisogna cambiare il contenuto del file di progetto.

Nuovo contenuto

```
<Project Sdk="Microsoft.NET.Sdk">

  <PropertyGroup>
    <OutputType>Exe</OutputType>
    <TargetFramework>net8.0</TargetFramework>  // da notare la versione, questo perchè in 9.0 ho avuto dei problemi risolti passando alla versione 8.0
    <PlatformTarget>x86</PlatformTarget>  //da notare sia i tag in cui abbiamo scritto x86
  </PropertyGroup>

</Project>

```
Una volta corretto il contenuto del file di progetto possiamo procedere alla creazione di file in assembly-> estensione .asm

contenuto: 

```
.386
.model flat, stdcall
option casemap:none

PUBLIC AddNumbers

.code
AddNumbers PROC a:DWORD, b:DWORD
     mov eax, a
     add eax, b
     ret 8
AddNumbers ENDP
END
```

Procediamo ora al file .def, perchè dobbiamo definire il modo in cui assembler deve esporre la funzione, cioè con quale nome. Difatti la <br>
stdcall è una calling convention ed ha delle regole di configurazione delle chiamate di funzione, una tra queste (che spesso rappresenta il primo <br>
scoglio da superare), è quella che definisce il naming della funzione esposta, o meglio quando si usa la convenzione stdcall succede che il nome <br>
della funzione viene preceduto da un "_", mentre alla fine si mette "@" con il numero di byte occupato dai parametri passati. <br>
Nel nostro esempio sopra esposto abbiamo 2 variabili di tipo dword (ogni variabile così pesa 4 byte). <br>
Perciò somma diventa _somma@8; questo nuovo nome diventa così problematico da gestire e per risolverlo si può agire in due modi:

1. Modo pulito: facciamo in modo che il program.cs quando eseguito riesca a reperire la funzione corretta chiamandola in modo ordinario, e per <br>
ottenere questo permettiamo all'assembler di esporlo del suo modo ma poi interferiamo con una nuova definizione della funzione sostituendo <br>
con quello più comodo per noi:<br>
contenuto file .def

```
LIBRARY nome_file_asm
EXPORTS
     nomefunzione=_nomefunzione@n // dove n è il numero di byte dei parametri
```

2. Modo meno pulito: ridefiniamo il comportamento del program.cs nella parte dedicata al recupero delle informazioni dal file dll. <br>
Ma questo modo ha un grosso limite: questa modalità dipende fortemente dal numero di parametri da passare. Per tale motivo, ho deciso <br>
di non approfondire questa modalità

Una volta completata questa fase bisogna passare alla fase di compilazione dell'assembly per la generazione del file .obj.<br>
Comandi utili:

```
ml /c /coff Nome_file.asm
```
e poi al linker per la generazione del dll (il vero file da cui reperire la funzione dal csharp)

```
link /dll /noentry /machine:x86 /def:nome_file.def /out:Nomefile.dll Nomefile.obj

// da notare l'uso dell'opzione noentry, il dll non ha entrypoint rappresentato di solito dal dllmain, per questo bisogna utilizzarla
// da notare il comando machine:x86 senza questo si rischia di lavorare sull'architettura reale della macchina. 
```

Se non da problemi possiamo procedere al file Program.cs:

```
using System;
using System.Runtime.InteropServices;

class Program
{
	[DllImport("Nomefile.dll",CallingConvention=CallingConvention.StdCall)]
	public static extern tipo_funzione nomefunzione( parametri utili);
	
	static void Main()
	{
		Console.WriteLine(nomefunzione(parametri utili));
	}
}
```

In questo modo semplice creiamo un esempio di collaborazione tra assembly e csharp. <br>
Una volta completato questa operazione possiamo procedere alla fase successiva.

```
dotnet build
```

Se l'operazione non da problemi...

```
copy nomefile.dll \bin\Debug\net8.0
```

poi 

```
dotnet run
```

Se non ci sono problemi il risultato è la somma dei due valori inseriti nel program.cs, tra i parametri passati.
