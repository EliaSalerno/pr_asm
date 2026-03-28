# Lezione 6 — Calling Convention e Interfacciamento con C#

## 6.1 Cos'è una Calling Convention?

Quando un programma scritto in un linguaggio chiama una funzione scrtta in un altro linguaggio
(es. C# chiama una funzione Assembly), i due devono **accordarsi su come passarsi i dati**.

Questo accordo si chiama **calling convention** (convenzione di chiamata).
Per x86-32 su Windows, la più comune è la **`cdecl`** (C declaration).

---

## 6.2 La Calling Convention cdecl (standard C/C#)

### Regole per il CHIAMANTE (es. il codice C#)

1. **Parametri sullo stack in ordine inverso** (l'ultimo parametro viene pushato per primo)
2. **Ripulire lo stack** dopo la chiamata (`add esp, N` dove N = numero_parametri × 4)
3. **Salvare EAX, ECX, EDX** se ne ha bisogno dopo la chiamata (possono essere modificati)

### Regole per la FUNZIONE CHIAMATA (il codice Assembly)

1. **Prologo**: `push ebp` poi `mov ebp, esp`
2. Allocare **variabili locali** con `sub esp, N`
3. **Salvare EBX, ESI, EDI** se li usa (devono sopravvivere alla chiamata)
4. Eseguire il lavoro, mettere il **risultato in EAX**
5. **Epilogo**: ripristinare l'ordine inverso del prologo e fare `ret`

---

## 6.3 Schema visivo completo

```
CHIAMANTE (C#)                          FUNZIONE ASM
─────────────────────────────           ──────────────────────────────
  push param2                         ┐
  push param1                         │ parametri sullo stack
  call _NomeFunzione ────────────────→│
                                       │ push ebp          ← prologo
                                       │ mov ebp, esp
                                       │ sub esp, 4        ← var locali
                                       │ push esi          ← salva reg
                                       │
                                       │ [corpo della funzione]
                                       │ mov eax, risultato ← ritorno
                                       │
                                       │ pop esi           ← epilogo
                                       │ mov esp, ebp
                                       │ pop ebp
                                       │ ret ─────────────────────────┐
  add esp, 8      ←────────────────────┘                              │
  ; EAX = risultato ←────────────────────────────────────────────────┘
```

---

## 6.4 Offset dei parametri rispetto a EBP

Dopo il prologo (`push ebp; mov ebp, esp`), i parametri si trovano a offset **fissi** da EBP:

```
[ebp + 4]  = indirizzo di ritorno  (messo da CALL)
[ebp + 8]  = 1° parametro
[ebp + 12] = 2° parametro
[ebp + 16] = 3° parametro
[ebp - 4]  = 1ª variabile locale
[ebp - 8]  = 2ª variabile locale
```

---

## 6.5 Come esportare una funzione in una DLL

Per rendere una funzione Assembly chiamabile dal C#, dobbiamo:
1. Dichiararla con `PUBLIC` in MASM
2. Usare il prefisso `_` (richiesto dalla cdecl su Windows a 32 bit)
3. Compilare come DLL

```asm
.486
.MODEL FLAT, C        ; modello flat a 32 bit, chiamata C (cdecl)
.CODE

PUBLIC NomeFunzione  ; rende la funzione visibile fuori dalla DLL

NomeFunzione PROC
    ; corpo
    ret
NomeFunzione ENDP

END
```

---

## 6.6 Come chiamare la DLL da C# con P/Invoke

**P/Invoke** (Platform Invocation Services) permette al codice C# di chiamare funzioni native (scritte in C, C++, Assembly) contenute in una DLL.

```csharp
using System.Runtime.InteropServices;

// Dichiara la funzione della DLL
[DllImport("nomefile.dll", CallingConvention = CallingConvention.Cdecl)]
private static extern int NomeFunzione(int param1, int param2);

// Chiamata
int risultato = NomeFunzione(3, 5);
Console.WriteLine($"Risultato: {risultato}");
```

### Nota sui tipi

| Tipo C# | Tipo Assembly | Dimensione |
|---------|--------------|-----------|
| `int` | DWORD (32 bit) | 4 byte |
| `uint` | DWORD | 4 byte |
| `short` | WORD (16 bit) | 2 byte |
| `byte` | BYTE (8 bit) | 1 byte |

---

## 6.7 Esempio completo: somma di due interi

### File: `somma.asm`

```asm
.486
.MODEL FLAT, C
.CODE

PUBLIC Somma

; int Somma(int a, int b)
; Ritorna a + b
Somma PROC
    push ebp
    mov  ebp, esp

    mov  eax, [ebp + 8]   ; carica il primo parametro (a)
    add  eax, [ebp + 12]  ; aggiunge il secondo parametro (b)
    ; EAX = a + b → valore di ritorno

    mov  esp, ebp
    pop  ebp
    ret
Somma ENDP

END
```

### File: `Program.cs`

```csharp
using System.Runtime.InteropServices;

[DllImport("somma.dll", CallingConvention = CallingConvention.Cdecl)]
static extern int Somma(int a, int b);

int risultato = Somma(10, 32);
Console.WriteLine($"10 + 32 = {risultato}");
```

---

## 6.8 Riepilogo delle regole da non dimenticare

| Regola | Dettaglio |
|--------|-----------|
| Parametri | Pushati in ordine inverso dal chiamante |
| Pulizia stack | A carico del chiamante (cdecl) |
| Valore di ritorno | Sempre in EAX (intero 32-bit) |
| Registri da preservare | EBX, ESI, EDI (il chiamato li deve ripristinare) |
| Registri "liberi" | EAX, ECX, EDX (il chiamato può modificarli) |
| Nome funzione | Prefisso `_` per compatibilità cdecl su Win32 |
| DllImport | `CallingConvention.Cdecl` |

---

## 6.9 Esercizi di consolidamento

1. Scrivi lo "scheletro" (prologo + epilogo) di una funzione Assembly con 2 parametri e 1 variabile locale.

2. In C#, come si dichiara una funzione Assembly esterna che prende un `int` e ritorna un `int`?

3. Perché la pulizia dello stack (add esp, N) è a carico del chiamante in cdecl? Quale alternativa esiste? (cerca `stdcall`)

4. Una funzione Assembly che calcola `a * b + c` riceve 3 parametri. A quali offset da EBP li trova?

5. Se la DLL si chiama `calcoli.dll` e la funzione si chiama `_Massimo`, scrivi la dichiarazione `[DllImport]` completa in C#.
