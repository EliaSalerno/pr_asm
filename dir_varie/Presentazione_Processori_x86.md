# Assembly x86: Architettura e Programmazione
## Sintesi del materiale sui processori

---

## SLIDE 1: Introduzione all'Assembly x86

### Cos'è l'Assembly x86?
- Linguaggio di programmazione a basso livello
- Istruzioni che corrispondono direttamente alle operazioni del processore
- Architettura a 32-bit (x86) e 64-bit (x64)
- Utilizzato per: ottimizzazione, driver, sistemi embedded

### Perché studiare Assembly?
- Comprendere il funzionamento interno del processore
- Debugging avanzato
- Ottimizzazione delle prestazioni
- Reverse engineering e sicurezza informatica

---

## SLIDE 2: Architettura di Von Neumann

### Modello di Von Neumann (1945)
Architettura fondamentale dei computer moderni con 5 componenti principali:

#### 1. **CPU (Central Processing Unit)**
- **ALU (Arithmetic Logic Unit)**: esegue operazioni aritmetiche e logiche
- **Control Unit**: coordina e controlla le operazioni
- **Registri**: memoria velocissima interna alla CPU
- **FPU (Floating Point Unit)**: esegue operazioni con numeri a virgola mobile
- **MMU (Memory Management Unit)**: gestisce la memoria e la protezione

#### 2. **Memoria (Memory)**
- Memorizza sia **dati** che **istruzioni** (concetto chiave!)
- RAM (Random Access Memory)
- Indirizzamento lineare

#### 3. **Input/Output**
- Dispositivi di ingresso (tastiera, mouse, sensori)
- Dispositivi di uscita (monitor, stampante, altoparlanti)

#### 4. **Bus di Sistema**
- **Data Bus**: trasporta i dati
- **Address Bus**: trasporta gli indirizzi di memoria
- **Control Bus**: trasporta segnali di controllo

#### 5. **Periferiche**
- Dispositivi di ingresso (tastiera, mouse, sensori)
- Dispositivi di uscita (monitor, stampante, altoparlanti)

### Ciclo Fetch-Decode-Execute
1. **Fetch**: preleva istruzione dalla memoria
2. **Decode**: decodifica l'istruzione
3. **Execute**: esegue l'istruzione
4. **Store**: memorizza il risultato (se necessario)

---

## SLIDE 3: Nomenclature dei Processori

### Evoluzione dell'Architettura Intel x86

#### **8086** (1978) - 16-bit
- Primo processore della famiglia x86
- Registri a 16-bit (AX, BX, CX, DX)
- Bus dati a 16-bit
- Indirizzamento fino a 1 MB

#### **80286** (1982) - 16-bit
- Modalità protetta
- Indirizzamento fino a 16 MB
- Multitasking hardware

#### **80386 (i386)** (1985) - 32-bit ⭐
- **Prima CPU a 32-bit** della famiglia
- Registri estesi: EAX, EBX, ECX, EDX
- Indirizzamento fino a 4 GB
- Modalità virtuale 8086

#### **80486 (i486)** (1989) - 32-bit
- Cache integrata
- FPU (Floating Point Unit) integrata
- Pipeline migliorata

#### **Pentium** (1993) - 32-bit
- Architettura superscalare
- Due pipeline di esecuzione
- MMX (MultiMedia eXtensions)

#### **x86-64 (AMD64, x64)** (2003) - 64-bit
- Estensione a 64-bit dell'architettura x86
- Registri a 64-bit: RAX, RBX, RCX, RDX
- 8 registri aggiuntivi: R8-R15
- Indirizzamento teorico fino a 16 EB

### Significato di "x86"
- **x** = variabile (8086, 80286, 80386, 80486)
- **86** = dalla serie 8086
- Indica la **famiglia di processori compatibili** con 8086

---

## SLIDE 4: CISC vs RISC

### **CISC** (Complex Instruction Set Computer)

#### Caratteristiche
- **Istruzioni complesse** che fanno molte operazioni
- **Numero elevato** di istruzioni (300+)
- **Lunghezza variabile** delle istruzioni
- **Pochi registri** general purpose
- **Accesso diretto** memoria-memoria

#### Vantaggi
✓ Codice più compatto
✓ Meno istruzioni per task complessi
✓ Compatibilità retroattiva

#### Svantaggi
✗ Istruzioni più lente da decodificare
✗ Pipeline più complessa
✗ Maggior consumo energetico

#### Esempi
- **Intel x86/x64**
- **AMD**
- **Motorola 68000**

---

### **RISC** (Reduced Instruction Set Computer)

#### Caratteristiche
- **Istruzioni semplici** e uniformi
- **Numero ridotto** di istruzioni (< 100)
- **Lunghezza fissa** delle istruzioni
- **Molti registri** general purpose (32+)
- **Load/Store architecture** (solo load/store accedono alla memoria)

#### Vantaggi
✓ Istruzioni più veloci
✓ Pipeline più efficiente
✓ Minore consumo energetico
✓ Più facile da ottimizzare

#### Svantaggi
✗ Codice più lungo
✗ Più istruzioni per task complessi

#### Esempi
- **ARM** (smartphone, tablet)
- **RISC-V** (open source)
- **MIPS**
- **PowerPC**
- **SPARC**

---

### Confronto Pratico

| Aspetto | CISC (x86) | RISC (ARM) |
|---------|------------|------------|
| Istruzioni | 300+ | ~50-100 |
| Lunghezza | Variabile (1-15 byte) | Fissa (4 byte) |
| Registri | 8 general purpose | 16-32 general purpose |
| Memoria | Accesso diretto | Load/Store |
| Pipeline | Complessa | Semplice |
| Consumo | Maggiore | Minore |

#### Esempio: Somma in Memoria
```assembly
# CISC (x86)
add [mem1], [mem2]      ; Una sola istruzione

# RISC (ARM)
ldr r1, [mem1]          ; Carica da memoria
ldr r2, [mem2]          ; Carica da memoria
add r3, r1, r2          ; Somma
str r3, [mem1]          ; Salva in memoria
```

---

## SLIDE 5: Modalità di Esecuzione x86

### **Real Mode** (Modalità Reale)

#### Caratteristiche
- Modalità originale dell'8086
- Indirizzamento a **16-bit**
- Accesso diretto all'hardware
- **Nessuna protezione** della memoria
- Limite di **1 MB** di RAM

#### Utilizzo
- Boot del sistema (BIOS)
- DOS e sistemi operativi antichi
- Firmware e bootloader

#### Indirizzamento Segmentato
```
Indirizzo Fisico = (Segmento × 16) + Offset
Esempio: 0x1234:0x5678 = 0x12340 + 0x5678 = 0x179B8
```

---

### **Protected Mode** (Modalità Protetta)

#### Caratteristiche
- Introdotta con 80286, estesa con 80386
- Indirizzamento a **32-bit** (fino a 4 GB)
- **Protezione della memoria** tra processi
- **Multitasking** con privilegi
- **Memoria virtuale** e paginazione

#### Livelli di Privilegio (Ring)
- **Ring 0**: Kernel del sistema operativo (massimi privilegi)
- **Ring 1-2**: Driver e servizi (raramente usati)
- **Ring 3**: Applicazioni utente (privilegi limitati)

#### Vantaggi
✓ Isolamento tra processi
✓ Protezione del kernel
✓ Gestione avanzata della memoria
✓ Multitasking preemptive

#### Utilizzo
- Windows (tutte le versioni moderne)
- Linux
- macOS (su Intel)

---

### **Long Mode** (Modalità a 64-bit)

#### Caratteristiche
- Introdotta con AMD64/x86-64
- Indirizzamento a **64-bit** (teorico: 16 EB)
- Registri estesi a 64-bit (RAX, RBX, ...)
- **8 registri aggiuntivi** (R8-R15)
- Supporto per più di 4 GB di RAM

#### Sotto-modalità
1. **64-bit Mode**: esecuzione nativa a 64-bit
2. **Compatibility Mode**: esecuzione codice 32-bit

#### Vantaggi
✓ Spazio di indirizzamento enorme
✓ Più registri disponibili
✓ Migliori prestazioni
✓ Supporto per grandi quantità di RAM

---

### **Virtual 8086 Mode**

#### Caratteristiche
- Modalità speciale della Protected Mode
- Permette esecuzione di **codice Real Mode** in ambiente protetto
- Usata per compatibilità con software DOS

#### Utilizzo
- Emulazione DOS in Windows
- Esecuzione di applicazioni legacy

---

### Transizioni tra Modalità

```
Boot (Real Mode)
    ↓
Bootloader carica OS
    ↓
Switch a Protected Mode (32-bit)
    ↓
[Opzionale] Switch a Long Mode (64-bit)
```

---

## SLIDE 6: ISA (Instruction Set Architecture)

### Cos'è l'ISA?

**ISA** = Interfaccia tra hardware e software

Definisce:
- **Istruzioni** disponibili
- **Registri** e loro utilizzo
- **Modalità di indirizzamento**
- **Tipi di dati** supportati
- **Gestione delle eccezioni**
- **Modello di memoria**

### ISA come Contratto
```
Software (Assembly/Compilatore)
         ↕ ISA
Hardware (Processore)
```

---

### Principali ISA

#### **x86 / x86-64**
- **Tipo**: CISC
- **Bit**: 32-bit / 64-bit
- **Produttori**: Intel, AMD
- **Utilizzo**: PC, server, laptop
- **Caratteristiche**: Compatibilità retroattiva, molto diffuso

#### **ARM**
- **Tipo**: RISC
- **Bit**: 32-bit / 64-bit (ARMv8)
- **Produttori**: ARM Holdings (licenze)
- **Utilizzo**: Smartphone, tablet, embedded, Apple Silicon
- **Caratteristiche**: Efficienza energetica, scalabile

#### **RISC-V**
- **Tipo**: RISC
- **Bit**: 32/64/128-bit
- **Produttori**: Open source (vari)
- **Utilizzo**: Embedded, ricerca, IoT
- **Caratteristiche**: Open source, modulare, moderno

#### **MIPS**
- **Tipo**: RISC
- **Bit**: 32-bit / 64-bit
- **Utilizzo**: Router, embedded, console (PlayStation)
- **Caratteristiche**: Semplice, educativo

#### **PowerPC**
- **Tipo**: RISC
- **Bit**: 32-bit / 64-bit
- **Utilizzo**: Server IBM, console (Xbox 360, PS3)
- **Caratteristiche**: Alte prestazioni

---

### Componenti dell'ISA x86

#### 1. **Istruzioni**
- Movimento dati: MOV, PUSH, POP, LEA
- Aritmetiche: ADD, SUB, MUL, DIV
- Logiche: AND, OR, XOR, NOT
- Controllo: JMP, CALL, RET, Jcc
- Speciali: INT, CPUID, RDTSC

#### 2. **Registri**
- General Purpose: EAX, EBX, ECX, EDX, ESI, EDI
- Speciali: ESP, EBP, EIP, EFLAGS
- Segmento: CS, DS, SS, ES, FS, GS

#### 3. **Modalità di Indirizzamento**
- Immediato: `mov eax, 5`
- Registro: `mov eax, ebx`
- Diretto: `mov eax, [0x1000]`
- Indiretto: `mov eax, [ebx]`
- Indicizzato: `mov eax, [ebx+esi*4+8]`

#### 4. **Tipi di Dati**
- Byte (8-bit)
- Word (16-bit)
- Dword (32-bit)
- Qword (64-bit)
- Float, Double

---

### Estensioni ISA x86

#### **MMX** (1997)
- MultiMedia eXtensions
- Istruzioni SIMD per multimedia
- Registri MM0-MM7 (64-bit)

#### **SSE** (1999-2001)
- Streaming SIMD Extensions
- Registri XMM0-XMM15 (128-bit)
- Operazioni su floating point

#### **AVX** (2011)
- Advanced Vector Extensions
- Registri YMM0-YMM15 (256-bit)
- Migliori prestazioni SIMD

#### **AVX-512** (2015)
- Registri ZMM0-ZMM31 (512-bit)
- 32 registri su alcuni processori
- Prestazioni estreme per HPC

---

## SLIDE 7: Calling Conventions - Approfondimento

### Perché Servono le Calling Conventions?

**Problema**: Come passare parametri e gestire lo stack in modo consistente?

**Soluzione**: Convenzioni standard che definiscono:
1. Come passare i parametri
2. Chi pulisce lo stack
3. Quali registri preservare
4. Come restituire valori

---

### **cdecl** (C Declaration)

#### Regole
- **Parametri**: da destra a sinistra sullo stack
- **Pulizia stack**: chiamante (caller)
- **Registri preservati**: EBX, ESI, EDI, EBP
- **Valore di ritorno**: EAX (32-bit), EDX:EAX (64-bit)

#### Esempio
```assembly
; Chiamante
push 30         ; terzo parametro
push 20         ; secondo parametro
push 10         ; primo parametro
call _func
add esp, 12     ; pulizia stack (3 × 4 byte)

; Funzione
_func:
    push ebp
    mov ebp, esp
    mov eax, [ebp+8]    ; primo parametro
    mov ebx, [ebp+12]   ; secondo parametro
    mov ecx, [ebp+16]   ; terzo parametro
    ; ... elaborazione ...
    pop ebp
    ret                 ; NON pulisce lo stack
```

#### Vantaggi
✓ Supporta funzioni variadiche (printf, scanf)
✓ Standard C/C++

#### Svantaggi
✗ Codice chiamante più grande

---

### **stdcall** (Standard Call)

#### Regole
- **Parametri**: da destra a sinistra sullo stack
- **Pulizia stack**: chiamato (callee)
- **Registri preservati**: EBX, ESI, EDI, EBP
- **Valore di ritorno**: EAX
- **Name mangling**: `_FunctionName@N` (N = byte parametri)

#### Esempio
```assembly
; Chiamante
push 30
push 20
push 10
call _func@12   ; nome decorato
; NON serve pulire lo stack

; Funzione
_func@12:
    push ebp
    mov ebp, esp
    mov eax, [ebp+8]
    mov ebx, [ebp+12]
    mov ecx, [ebp+16]
    ; ... elaborazione ...
    pop ebp
    ret 12          ; pulisce 12 byte dallo stack
```

#### Vantaggi
✓ Codice chiamante più compatto
✓ Usato da Windows API

#### Svantaggi
✗ Non supporta funzioni variadiche

---

### **fastcall**

#### Regole
- **Primi 2 parametri**: in ECX e EDX
- **Parametri successivi**: sullo stack (destra → sinistra)
- **Pulizia stack**: chiamato
- **Name mangling**: `@FunctionName@N`

#### Esempio
```assembly
; Chiamante
push 30         ; terzo parametro (stack)
mov edx, 20     ; secondo parametro (registro)
mov ecx, 10     ; primo parametro (registro)
call @func@12

; Funzione
@func@12:
    push ebp
    mov ebp, esp
    ; ECX = primo parametro
    ; EDX = secondo parametro
    mov eax, [ebp+8]    ; terzo parametro
    ; ... elaborazione ...
    pop ebp
    ret 4           ; pulisce solo il terzo parametro
```

#### Vantaggi
✓ Più veloce (meno accessi memoria)

---

### **thiscall** (C++)

#### Regole
- **Puntatore this**: in ECX
- **Altri parametri**: sullo stack (destra → sinistra)
- **Pulizia stack**: chiamato (metodi normali), chiamante (variadici)

#### Esempio
```assembly
; Chiamata metodo C++
mov ecx, ptrObject  ; this pointer
push 20             ; parametro
call MyClass::method
```

---

### **x64 Calling Convention** (Microsoft x64)

#### Regole
- **Primi 4 parametri**: RCX, RDX, R8, R9
- **Parametri successivi**: sullo stack
- **Shadow space**: 32 byte riservati sullo stack
- **Registri preservati**: RBX, RBP, RDI, RSI, R12-R15
- **Valore di ritorno**: RAX

#### Esempio
```assembly
; Chiamante
sub rsp, 32         ; shadow space
mov r9, 40          ; quarto parametro
mov r8, 30          ; terzo parametro
mov rdx, 20         ; secondo parametro
mov rcx, 10         ; primo parametro
call func
add rsp, 32         ; rimuove shadow space
```

---

### **System V AMD64 ABI** (Linux/Unix x64)

#### Regole
- **Primi 6 parametri interi**: RDI, RSI, RDX, RCX, R8, R9
- **Primi 8 parametri float**: XMM0-XMM7
- **Parametri successivi**: sullo stack
- **Red zone**: 128 byte sotto RSP (non toccati da segnali)

#### Esempio
```assembly
; Chiamante
mov r9, 60          ; sesto parametro
mov r8, 50          ; quinto parametro
mov rcx, 40         ; quarto parametro
mov rdx, 30         ; terzo parametro
mov rsi, 20         ; secondo parametro
mov rdi, 10         ; primo parametro
call func
```

---

### Confronto Calling Conventions

| Convention | Parametri | Pulizia | Registri | Uso |
|------------|-----------|---------|----------|-----|
| **cdecl** | Stack (R→L) | Caller | EBX,ESI,EDI,EBP | C/C++ standard |
| **stdcall** | Stack (R→L) | Callee | EBX,ESI,EDI,EBP | Windows API |
| **fastcall** | ECX,EDX + Stack | Callee | EBX,ESI,EDI,EBP | Ottimizzazione |
| **thiscall** | ECX (this) + Stack | Callee | EBX,ESI,EDI,EBP | C++ metodi |
| **MS x64** | RCX,RDX,R8,R9 | Caller | RBX,RBP,RSI,RDI,R12-R15 | Windows 64-bit |
| **SysV x64** | RDI,RSI,RDX,RCX,R8,R9 | Caller | RBX,RBP,R12-R15 | Linux/Unix 64-bit |

---

## SLIDE 8: Registri x86 (32-bit)

### Registri General Purpose
- **EAX** - Accumulator (operazioni aritmetiche, valore di ritorno)
- **EBX** - Base register (indirizzamento memoria)
- **ECX** - Counter (cicli e iterazioni)
- **EDX** - Data register (operazioni I/O, moltiplicazioni)

### Registri Indice
- **ESI** - Source Index (operazioni su stringhe)
- **EDI** - Destination Index (operazioni su stringhe)

### Registri Speciali
- **ESP** - Stack Pointer (punta alla cima dello stack)
- **EBP** - Base Pointer (punto di riferimento per lo stack frame)

### Sotto-registri
- **AX** (16-bit) = parte bassa di EAX
- **AL** (8-bit) = byte basso di AX
- **AH** (8-bit) = byte alto di AX

---

## SLIDE 3: Lo Stack (Pila)

### Caratteristiche dello Stack
- **Struttura LIFO** (Last-In, First-Out)
- **Cresce verso il basso** (indirizzi decrescenti)
- **ESP** punta sempre alla cima dello stack
- **EBP** usato come punto di riferimento fisso

### Operazioni Fondamentali

#### PUSH (Inserimento)
```assembly
push eax        ; Decrementa ESP di 4, salva EAX
push 10         ; Inserisce il valore 10 sullo stack
```

#### POP (Estrazione)
```assembly
pop ebx         ; Carica il valore in EBX, incrementa ESP di 4
```

### Utilizzi dello Stack
1. Gestione chiamate a funzioni
2. Salvataggio parametri
3. Variabili locali
4. Salvataggio contesto dei registri

---

## SLIDE 4: Indirizzamento Memoria

### Modalità di Indirizzamento
```assembly
mov eax, [ebx]          ; Indirizzamento indiretto
mov eax, [ebx+4]        ; Con offset
mov eax, [esi+4*ebx]    ; Con scala e indice
mov [var], ebx          ; Indirizzamento diretto
```

### Direttive di Dimensione
- **BYTE PTR** - 1 byte
- **WORD PTR** - 2 bytes (16-bit)
- **DWORD PTR** - 4 bytes (32-bit)

### Dichiarazione Dati
```assembly
.DATA
var     DB 64           ; Byte (1 byte)
X       DW ?            ; Word (2 bytes) non inizializzata
Y       DD 30000        ; Double Word (4 bytes)
arr     DD 100 DUP(0)   ; Array di 100 DWORD a zero
str     DB 'hello',0    ; Stringa
```

---

## SLIDE 5: Istruzioni Assembly Principali

### Movimento Dati
```assembly
mov eax, ebx            ; Copia EBX in EAX
lea edi, [ebx+4*esi]    ; Carica indirizzo effettivo
```

### Operazioni Aritmetiche
```assembly
add eax, 10             ; EAX = EAX + 10
sub eax, ebx            ; EAX = EAX - EBX
inc ecx                 ; ECX = ECX + 1
dec edx                 ; EDX = EDX - 1
imul eax, ebx           ; EAX = EAX * EBX
idiv ebx                ; EAX = EDX:EAX / EBX, EDX = resto
```

### Operazioni Logiche
```assembly
and eax, 0Fh            ; AND bit a bit
or eax, ebx             ; OR bit a bit
xor eax, eax            ; XOR (azzera EAX)
not eax                 ; NOT (complemento)
shl eax, 2              ; Shift left (moltiplica per 4)
shr ebx, 1              ; Shift right (divide per 2)
```

---

## SLIDE 6: Controllo di Flusso

### Salti Incondizionati
```assembly
jmp label               ; Salta a label
```

### Confronti e Salti Condizionati
```assembly
cmp eax, ebx            ; Confronta EAX con EBX
je label                ; Jump if Equal
jne label               ; Jump if Not Equal
jg label                ; Jump if Greater
jge label               ; Jump if Greater or Equal
jl label                ; Jump if Less
jle label               ; Jump if Less or Equal
```

### Chiamate a Funzioni
```assembly
call function           ; Chiama funzione (push EIP, jmp)
ret                     ; Ritorna (pop EIP)
```

---

## SLIDE 7: Stack Frame e Chiamate a Funzione

### Struttura di uno Stack Frame
```
[Parametri]             <- EBP + 8, +12, +16...
[Indirizzo di ritorno]  <- EBP + 4
[EBP salvato]           <- EBP
[Variabili locali]      <- EBP - 4, -8, -12...
[Registri salvati]      <- ESP
```

### Prologo della Funzione (Callee)
```assembly
push ebp                ; Salva EBP del chiamante
mov ebp, esp            ; Imposta nuovo base pointer
sub esp, 16             ; Alloca 16 byte per variabili locali
push edi                ; Salva registri da preservare
push esi
```

### Corpo della Funzione
```assembly
mov eax, [ebp+8]        ; Accesso primo parametro
mov [ebp-4], eax        ; Accesso prima variabile locale
```

### Epilogo della Funzione (Callee)
```assembly
pop esi                 ; Ripristina registri
pop edi
mov esp, ebp            ; Dealloca variabili locali
pop ebp                 ; Ripristina EBP
ret                     ; Ritorna al chiamante
```

---

## SLIDE 8: Convenzioni di Chiamata

### stdcall (Standard Call)
- **Parametri**: da destra a sinistra sullo stack
- **Pulizia stack**: gestita dalla funzione chiamata
- **Nome decorato**: `_FunctionName@N` (N = byte parametri)
- **Valore di ritorno**: in EAX
- **Usato da**: Windows API

### cdecl (C Declaration)
- **Parametri**: da destra a sinistra sullo stack
- **Pulizia stack**: gestita dal chiamante
- **Nome decorato**: `_FunctionName`
- **Valore di ritorno**: in EAX
- **Usato da**: compilatori C standard

### Esempio Chiamata (Caller)
```assembly
push [var]              ; Terzo parametro
push 216                ; Secondo parametro
push eax                ; Primo parametro
call _myFunc            ; Chiamata
add esp, 12             ; Pulizia stack (solo cdecl)
```

---

## SLIDE 9: Integrazione Assembly + .NET

### Requisiti
- **Windows** (obbligatorio)
- **.NET SDK** (es. net8.0)
- **MASM 32-bit** (ml.exe)
- **Microsoft Linker** (link.exe)

### Configurazione Progetto .NET
```xml
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <OutputType>Exe</OutputType>
    <TargetFramework>net8.0</TargetFramework>
    <PlatformTarget>x86</PlatformTarget>
  </PropertyGroup>
</Project>
```

### Codice Assembly (AsmFunctions.asm)
```assembly
.386
.model flat, stdcall
option casemap:none

PUBLIC AddNumbers

.code
AddNumbers PROC a:DWORD, b:DWORD
    mov eax, a
    add eax, b
    ret
AddNumbers ENDP
END
```

---

## SLIDE 10: Compilazione e Linking

### Compilazione Assembly
```powershell
ml /c /coff AsmFunctions.asm
```
Produce: `AsmFunctions.obj`

### File .def (per nomi puliti)
```
LIBRARY AsmFunctions
EXPORTS
    AddNumbers=_AddNumbers@8
```

### Creazione DLL
```powershell
link /dll /noentry /machine:x86 ^
     /def:AsmFunctions.def ^
     /out:AsmFunctions.dll AsmFunctions.obj
```

### Codice C# (P/Invoke)
```csharp
using System;
using System.Runtime.InteropServices;

class Program
{
    [DllImport("AsmFunctions.dll", 
               CallingConvention = CallingConvention.StdCall)]
    public static extern int AddNumbers(int a, int b);

    static void Main()
    {
        Console.WriteLine(AddNumbers(5, 7)); // Output: 12
    }
}
```

---

## SLIDE 11: Problemi Comuni e Soluzioni

### BadImageFormatException
- **Causa**: Mismatch tra architetture (32/64 bit)
- **Soluzione**: `<PlatformTarget>x86</PlatformTarget>`

### EntryPointNotFoundException
- **Causa**: Nome decorato stdcall (`_Function@N`)
- **Soluzione**: Usare file `.def` per esportare nome pulito

### LNK2001: DllMain non risolto
- **Causa**: DLL assembly pura senza entry point
- **Soluzione**: Usare flag `/noentry` nel link

### DllNotFoundException
- **Causa**: DLL non nella cartella di output
- **Soluzione**: Copiare in `bin\Debug\net8.0\`

---

## SLIDE 12: Esempio Completo - Funzione Somma

### File Assembly (sum.asm)
```assembly
.386
.model flat, stdcall
option casemap:none

PUBLIC AddNumbers

.code
AddNumbers PROC a:DWORD, b:DWORD
    mov eax, a          ; Carica primo parametro
    add eax, b          ; Somma secondo parametro
    ret                 ; Risultato in EAX
AddNumbers ENDP
END
```

### Compilazione e Link
```powershell
# Compila assembly
ml /c /coff sum.asm

# Crea file .def
echo LIBRARY SumLib > sum.def
echo EXPORTS >> sum.def
echo     AddNumbers=_AddNumbers@8 >> sum.def

# Crea DLL
link /dll /noentry /machine:x86 /def:sum.def /out:sum.dll sum.obj
```

### Uso in C#
```csharp
[DllImport("sum.dll", CallingConvention = CallingConvention.StdCall)]
public static extern int AddNumbers(int a, int b);

// Utilizzo
int result = AddNumbers(10, 20); // result = 30
```

---

## SLIDE 13: Debugging Assembly

### Strumenti di Debug
- **Visual Studio Debugger**
- **WinDbg** (Windows Debugger)
- **GDB** (GNU Debugger per Linux)
- **OllyDbg / x64dbg** (reverse engineering)

### Tecniche di Debug
1. **Breakpoint** sulla chiamata alla funzione assembly
2. **Finestra Disassembly** per vedere istruzioni
3. **Finestra Registri** per monitorare EAX, EBX, etc.
4. **Finestra Memoria** per ispezionare lo stack
5. **Step Into (F11)** per eseguire istruzione per istruzione

### Verifica dello Stack
```
Indirizzo    Valore      Descrizione
[ESP+12]     param3      Terzo parametro
[ESP+8]      param2      Secondo parametro
[ESP+4]      param1      Primo parametro
[ESP]        ret_addr    Indirizzo di ritorno
```

---

## SLIDE 14: Best Practices

### Convenzioni di Codifica
- Commentare ogni sezione di codice
- Usare nomi significativi per le label
- Seguire una convenzione di chiamata consistente
- Documentare i registri modificati

### Ottimizzazione
- Minimizzare accessi alla memoria
- Usare registri invece di variabili quando possibile
- Evitare salti non necessari
- Allineare dati per performance migliori

### Sicurezza
- Validare sempre i parametri
- Controllare overflow dello stack
- Gestire correttamente i buffer
- Preservare registri critici

---

## SLIDE 15: Risorse e Riferimenti

### Documentazione Ufficiale
- **Intel x86 Instruction Set Reference**
- **Microsoft MASM Documentation**
- **AMD64 Architecture Programmer's Manual**

### Guide e Tutorial
- CS216 University of Virginia (David Evans)
- Guide assembly x86 online
- Forum e community (Stack Overflow, Reddit r/asm)

### Tool Utili
- **MASM** (Microsoft Macro Assembler)
- **NASM** (Netwide Assembler)
- **Visual Studio Build Tools**
- **Compiler Explorer** (godbolt.org)

### Comandi Essenziali
```powershell
# Compilazione
ml /c /coff file.asm

# Link DLL
link /dll /noentry /machine:x86 /out:output.dll input.obj

# Verifica esportazioni
dumpbin /exports file.dll

# Build .NET
dotnet build
dotnet run
```

---

## SLIDE 16: Conclusioni

### Cosa Abbiamo Imparato
✓ Architettura x86 e registri del processore
✓ Gestione dello stack e stack frame
✓ Istruzioni assembly fondamentali
✓ Convenzioni di chiamata (stdcall, cdecl)
✓ Integrazione assembly con .NET/C#
✓ Compilazione e linking con MASM

### Applicazioni Pratiche
- Sviluppo di driver e kernel
- Ottimizzazione di codice critico
- Reverse engineering
- Sicurezza informatica e malware analysis
- Sistemi embedded e real-time

### Prossimi Passi
- Esercitarsi con esempi pratici
- Studiare istruzioni SIMD (SSE, AVX)
- Approfondire architettura x64
- Esplorare assembly su altre piattaforme (ARM, RISC-V)

---

## SLIDE 17: Glossario Tecnico - Parte 1

### **CPU (Central Processing Unit)**
Unità centrale di elaborazione del computer. Esegue le istruzioni dei programmi, effettua calcoli aritmetici e logici, e coordina le operazioni di tutti i componenti del sistema.

**Componenti principali:**
- ALU (Arithmetic Logic Unit)
- Control Unit
- Registri
- Cache

---

### **ISA (Instruction Set Architecture)**
Insieme di istruzioni che un processore può eseguire. Definisce l'interfaccia tra hardware e software, specificando:
- Istruzioni disponibili
- Registri
- Modalità di indirizzamento
- Tipi di dati supportati

**Esempi:** x86, ARM, RISC-V, MIPS

---

### **Assembly**
Linguaggio di programmazione a basso livello che utilizza mnemonici (parole simboliche) per rappresentare le istruzioni macchina del processore.

**Caratteristiche:**
- Corrispondenza 1:1 con istruzioni macchina
- Specifico per ogni architettura (ISA)
- Controllo diretto dell'hardware
- Massima efficienza possibile

**Esempio:**
```assembly
mov eax, 5      ; Carica 5 in EAX
add eax, 10     ; Somma 10 a EAX
```

---

### **Assembler**
Programma che traduce codice assembly in codice macchina (binario) eseguibile dal processore.

**Processo:**
```
Codice Assembly (.asm)
        ↓
    Assembler (ml.exe, nasm)
        ↓
Codice Oggetto (.obj)
        ↓
    Linker (link.exe)
        ↓
Eseguibile (.exe, .dll)
```

**Esempi di assembler:**
- **MASM** (Microsoft Macro Assembler)
- **NASM** (Netwide Assembler)
- **GAS** (GNU Assembler)

---

## SLIDE 18: Glossario Tecnico - Parte 2

### **Linker (Link Editor)**
Programma che combina uno o più file oggetto (.obj) e librerie per creare un eseguibile finale (.exe) o una libreria dinamica (.dll).

**Funzioni:**
- Risolve riferimenti tra moduli
- Alloca indirizzi finali
- Gestisce simboli esterni
- Crea tabelle di esportazione/importazione

**Esempio:**
```powershell
link /dll /out:mylib.dll file1.obj file2.obj
```

---

### **Calling Convention**
Insieme di regole che definisce come le funzioni ricevono parametri e restituiscono valori.

**Definisce:**
1. **Ordine dei parametri** (stack, registri)
2. **Chi pulisce lo stack** (caller o callee)
3. **Registri da preservare**
4. **Registro per valore di ritorno** (tipicamente EAX/RAX)

**Principali convenzioni:**
- **cdecl**: caller pulisce, supporta variadici
- **stdcall**: callee pulisce, Windows API
- **fastcall**: primi parametri in registri
- **thiscall**: per metodi C++

---

### **Architettura di un Processore**
Struttura interna e organizzazione dei componenti di un processore.

**Livelli di architettura:**

#### 1. **Microarchitettura**
Implementazione fisica dell'ISA:
- Pipeline
- Cache (L1, L2, L3)
- Branch predictor
- Execution units

#### 2. **ISA (Instruction Set Architecture)**
Interfaccia programmabile:
- Set di istruzioni
- Registri visibili
- Modalità di indirizzamento

#### 3. **Organizzazione**
- Numero di core
- Frequenza di clock
- Bus di sistema
- Memoria cache

**Esempi:**
- **x86**: architettura CISC, compatibilità retroattiva
- **ARM Cortex**: architettura RISC, efficienza energetica
- **Apple M-series**: ARM con design custom

---

## SLIDE 19: Glossario Tecnico - Parte 3

### **stdcall (Standard Call)**
Convenzione di chiamata usata principalmente da Windows API.

**Caratteristiche:**
- Parametri passati sullo stack (destra → sinistra)
- **Callee pulisce lo stack** (funzione chiamata)
- Nome decorato: `_FunctionName@N` (N = byte parametri)
- Valore di ritorno in EAX

**Esempio:**
```assembly
; Chiamante
push 20
push 10
call _AddNumbers@8  ; nome decorato
; Stack già pulito dalla funzione

; Funzione
_AddNumbers@8:
    push ebp
    mov ebp, esp
    mov eax, [ebp+8]
    add eax, [ebp+12]
    pop ebp
    ret 8           ; pulisce 8 byte (2 parametri)
```

**Vantaggi:**
✓ Codice chiamante più compatto
✓ Standard per Windows API

**Limitazioni:**
✗ Non supporta funzioni variadiche (printf, scanf)

---

### **CISC (Complex Instruction Set Computer)**
Filosofia di design dei processori con set di istruzioni complesso.

**Caratteristiche:**
- Istruzioni complesse (fanno molte operazioni)
- Numero elevato di istruzioni (300+)
- Lunghezza variabile (1-15 byte in x86)
- Pochi registri general purpose
- Accesso diretto memoria-memoria

**Vantaggi:**
✓ Codice più compatto
✓ Meno istruzioni per task complessi
✓ Compatibilità retroattiva

**Svantaggi:**
✗ Decodifica più lenta
✗ Pipeline complessa
✗ Maggior consumo energetico

**Esempi:**
- Intel x86/x64
- AMD
- Motorola 68000

**Esempio istruzione CISC:**
```assembly
add [mem1], [mem2]  ; Somma diretta memoria-memoria
```

---

### **RISC (Reduced Instruction Set Computer)**
Filosofia di design dei processori con set di istruzioni ridotto.

**Caratteristiche:**
- Istruzioni semplici e uniformi
- Numero ridotto di istruzioni (<100)
- Lunghezza fissa (tipicamente 4 byte)
- Molti registri (16-32+)
- **Load/Store architecture** (solo load/store accedono memoria)

**Vantaggi:**
✓ Istruzioni più veloci
✓ Pipeline efficiente
✓ Minore consumo energetico
✓ Più facile da ottimizzare

**Svantaggi:**
✗ Codice più lungo
✗ Più istruzioni per task complessi

**Esempi:**
- ARM (smartphone, Apple Silicon)
- RISC-V (open source)
- MIPS
- PowerPC

**Esempio istruzione RISC:**
```assembly
ldr r1, [mem1]      ; Carica da memoria
ldr r2, [mem2]      ; Carica da memoria
add r3, r1, r2      ; Somma (solo registri)
str r3, [mem1]      ; Salva in memoria
```

---

## SLIDE 20: Glossario Tecnico - Parte 4

### **Stack (Pila)**
Struttura dati LIFO (Last-In, First-Out) usata per gestire chiamate a funzioni, parametri e variabili locali.

**Caratteristiche:**
- Cresce verso indirizzi **decrescenti** (in x86)
- Gestito da ESP (Stack Pointer)
- Operazioni: PUSH (inserimento), POP (estrazione)

**Utilizzi:**
1. Passaggio parametri a funzioni
2. Salvataggio indirizzo di ritorno
3. Variabili locali
4. Salvataggio contesto registri

**Esempio:**
```assembly
push eax        ; ESP = ESP - 4, [ESP] = EAX
pop ebx         ; EBX = [ESP], ESP = ESP + 4
```

**Visualizzazione:**
```
Indirizzi alti
    ↑
[Parametri]
[Return address]
[EBP salvato]
[Variabili locali]  ← ESP (cima dello stack)
    ↓
Indirizzi bassi
```

---

### **Stack Pointer (ESP/RSP)**
Registro speciale che punta sempre alla **cima dello stack** (ultimo elemento inserito).

**Caratteristiche:**
- **ESP** in x86 (32-bit)
- **RSP** in x64 (64-bit)
- Modificato automaticamente da PUSH/POP/CALL/RET
- Decrementato da PUSH, incrementato da POP

**Operazioni:**
```assembly
; Prima: ESP = 0x1000
push eax        ; ESP = 0x0FFC (decrementato di 4)
push ebx        ; ESP = 0x0FF8 (decrementato di 4)
pop ecx         ; ESP = 0x0FFC (incrementato di 4)
```

**Regole:**
- Non modificare ESP arbitrariamente
- Mantenere allineamento (4 byte in x86, 16 byte in x64)
- Bilanciare PUSH e POP

---

### **Base Pointer (EBP/RBP)**
Registro usato come **punto di riferimento fisso** per accedere parametri e variabili locali nello stack frame.

**Caratteristiche:**
- **EBP** in x86 (32-bit)
- **RBP** in x64 (64-bit)
- Rimane costante durante l'esecuzione della funzione
- Facilita l'accesso a parametri e variabili locali

**Setup tipico:**
```assembly
push ebp            ; Salva EBP precedente
mov ebp, esp        ; EBP = ESP (nuovo frame)
sub esp, 16         ; Alloca variabili locali
```

**Accesso dati:**
```assembly
mov eax, [ebp+8]    ; Primo parametro
mov ebx, [ebp+12]   ; Secondo parametro
mov [ebp-4], ecx    ; Prima variabile locale
mov [ebp-8], edx    ; Seconda variabile locale
```

**Cleanup:**
```assembly
mov esp, ebp        ; Dealloca variabili locali
pop ebp             ; Ripristina EBP precedente
ret
```

---

### **Stack Frame (Activation Record)**
Porzione dello stack dedicata a una singola chiamata di funzione.

**Struttura completa:**
```
Indirizzi alti
    ↑
[Parametro N]           ← EBP + 8 + (N-1)*4
[Parametro 2]           ← EBP + 12
[Parametro 1]           ← EBP + 8
[Return address]        ← EBP + 4
[EBP salvato]           ← EBP (base del frame)
[Variabile locale 1]    ← EBP - 4
[Variabile locale 2]    ← EBP - 8
[Registri salvati]      ← ESP (cima dello stack)
    ↓
Indirizzi bassi
```

**Ciclo di vita:**
1. **Creazione** (prologo): PUSH EBP, MOV EBP ESP, SUB ESP
2. **Utilizzo**: accesso parametri e variabili
3. **Distruzione** (epilogo): MOV ESP EBP, POP EBP, RET

**Vantaggi:**
- Isolamento tra funzioni
- Accesso efficiente a parametri/variabili
- Supporto per ricorsione
- Debugging facilitato

---

## SLIDE 21: Glossario Tecnico - Parte 5

### **DLL (Dynamic Link Library)**
Libreria di codice che può essere caricata e utilizzata da più programmi contemporaneamente.

**Caratteristiche:**
- Condivisione del codice tra applicazioni
- Aggiornamenti senza ricompilare programmi
- Risparmio di memoria (una sola copia in RAM)
- Caricamento dinamico a runtime

**Tipi:**
1. **DLL gestita** (.NET): codice IL (Intermediate Language)
2. **DLL nativa**: codice macchina nativo

**Vantaggi:**
✓ Riduzione dimensione eseguibili
✓ Modularità
✓ Aggiornamenti indipendenti
✓ Condivisione risorse

**Svantaggi:**
✗ Dependency hell
✗ Problemi di versioning
✗ Overhead di caricamento

**Creazione:**
```powershell
link /dll /out:mylib.dll file.obj
```

**Uso in C#:**
```csharp
[DllImport("mylib.dll")]
public static extern int MyFunction(int param);
```

---

### **DLL Nativo**
DLL contenente codice macchina compilato per una specifica architettura (x86, x64, ARM).

**Caratteristiche:**
- Codice binario nativo (non IL)
- Massime prestazioni
- Specifico per piattaforma
- Chiamato tramite P/Invoke da .NET

**Differenze con DLL gestita:**

| Aspetto | DLL Nativa | DLL Gestita |
|---------|------------|-------------|
| Linguaggio | C, C++, Assembly | C#, VB.NET, F# |
| Codice | Macchina nativo | IL (bytecode) |
| Esecuzione | Diretta CPU | CLR/JIT |
| Portabilità | Specifica piattaforma | Cross-platform |
| Prestazioni | Massime | Ottime (JIT) |
| Interop | P/Invoke | Diretto |

**Esempio creazione (Assembly):**
```powershell
# Compila assembly
ml /c /coff functions.asm

# Crea DLL nativa
link /dll /noentry /machine:x86 /out:native.dll functions.obj
```

**Chiamata da C#:**
```csharp
[DllImport("native.dll", CallingConvention = CallingConvention.StdCall)]
public static extern int NativeFunction(int x, int y);
```

---

### **DllMain**
Funzione di entry point opzionale di una DLL, chiamata automaticamente dal sistema operativo quando la DLL viene caricata o scaricata.

**Prototipo:**
```c
BOOL WINAPI DllMain(
    HINSTANCE hinstDLL,  // Handle dell'istanza DLL
    DWORD fdwReason,     // Motivo della chiamata
    LPVOID lpvReserved   // Riservato
);
```

**Motivi di chiamata (fdwReason):**
- **DLL_PROCESS_ATTACH**: DLL caricata in un processo
- **DLL_PROCESS_DETACH**: DLL scaricata da un processo
- **DLL_THREAD_ATTACH**: Nuovo thread creato
- **DLL_THREAD_DETACH**: Thread terminato

**Esempio:**
```c
BOOL WINAPI DllMain(HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpvReserved)
{
    switch (fdwReason)
    {
        case DLL_PROCESS_ATTACH:
            // Inizializzazione
            break;
        case DLL_PROCESS_DETACH:
            // Cleanup
            break;
    }
    return TRUE;
}
```

**DLL Assembly senza DllMain:**
Quando si crea una DLL in puro assembly senza runtime C, DllMain non esiste. Si usa il flag `/noentry`:

```powershell
link /dll /noentry /machine:x86 /out:mylib.dll mylib.obj
```

**Quando serve DllMain:**
- Inizializzazione risorse globali
- Allocazione memoria
- Registrazione thread
- Cleanup alla chiusura

**Quando NON serve:**
- DLL con solo funzioni esportate
- Nessuna inizializzazione necessaria
- DLL assembly pure (come nei nostri esempi)

---

## SLIDE 22: Riepilogo Glossario

### Termini Fondamentali

| Termine | Definizione Breve |
|---------|-------------------|
| **CPU** | Unità centrale di elaborazione, esegue istruzioni |
| **ISA** | Interfaccia tra hardware e software, definisce istruzioni |
| **Assembly** | Linguaggio a basso livello con mnemonici |
| **Assembler** | Traduce assembly in codice macchina |
| **Linker** | Combina file oggetto in eseguibile/DLL |
| **Calling Convention** | Regole per passaggio parametri e gestione stack |
| **Architettura** | Struttura e organizzazione del processore |
| **stdcall** | Convenzione Windows, callee pulisce stack |
| **CISC** | Istruzioni complesse, molte operazioni |
| **RISC** | Istruzioni semplici, load/store |
| **Stack** | Struttura LIFO per chiamate e variabili |
| **Stack Pointer** | Registro che punta alla cima dello stack |
| **Base Pointer** | Punto di riferimento fisso nello stack frame |
| **Stack Frame** | Porzione stack per una chiamata di funzione |
| **DLL** | Libreria dinamica condivisa |
| **DLL Nativo** | DLL con codice macchina nativo |
| **DllMain** | Entry point opzionale di una DLL |

---

### Relazioni tra Concetti

```
ISA (x86)
    ↓
Assembly (linguaggio)
    ↓
Assembler (MASM)
    ↓
File Oggetto (.obj)
    ↓
Linker
    ↓
DLL Nativo
    ↓
P/Invoke (.NET)
    ↓
Applicazione C#

Stack Frame
    ├── Stack Pointer (ESP)
    ├── Base Pointer (EBP)
    ├── Parametri
    ├── Return Address
    └── Variabili Locali

Calling Convention
    ├── stdcall (Windows API)
    ├── cdecl (C standard)
    ├── fastcall (ottimizzato)
    └── thiscall (C++)
```

