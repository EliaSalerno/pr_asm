# Lezione 5b — Laboratorio: Analisi dello Stack Frame

In questa lezione vedremo come "smontare" lo stack di una funzione mentre il programma è in esecuzione. Capire il frame dello stack è la chiave per il debugging avanzato e per capire come i linguaggi di alto livello (come C# o C++) funzionano realmente.

## 1. Obiettivo del Laboratorio
Analizzeremo una funzione che calcola la media di due numeri, usando però una **variabile locale** per memorizzare temporaneamente la somma prima di dividerla.

## 2. Lo schema del Frame al microscopio
Quando entriamo nella funzione `Media(int a, int b)`, ecco come deve apparire il nostro "bersaglio" in memoria:

| Indirizzo | Contenuto | Significato | Offset rispetto a EBP |
| :--- | :--- | :--- | :--- |
| `0x...14` | `b` (es. 20) | Secondo parametro | `[ebp + 12]` |
| `0x...10` | `a` (es. 10) | Primo parametro | `[ebp + 8]` |
| `0x...0C` | `0x...` | Indirizzo di Ritorno | `[ebp + 4]` |
| **`0x...08`** | **EBP Vecchio** | Punto di aggancio frame | **`[ebp]`** |
| `0x...04` | `Somma` | Variabile locale | `[ebp - 4]` |

## 3. L'esercizio guidato
Scriveremo insieme la funzione `Media`.

### Passo 1: Il Prologo
```asm
Media PROC
    push ebp        ; Salva il frame del chiamante
    mov ebp, esp    ; Crea il nuovo frame
    sub esp, 4      ; RISERVA SPAZIO per la variabile locale (somma)
```

### Passo 2: Calcolo con Variabile Locale
```asm
    mov eax, [ebp + 8]  ; Prendi 'a'
    add eax, [ebp + 12] ; Aggiungi 'b'
    mov [ebp - 4], eax  ; SALVA il risultato nella variabile locale
    
    ; ... qui potremmo fare altre cose ...
    
    mov eax, [ebp - 4]  ; Recupera dalla variabile locale
    shr eax, 1          ; Dividi per 2 (Shift Right)
```

### Passo 3: L'Epilogo (Fondamentale!)
```asm
    mov esp, ebp    ; DISTRUGGE le variabili locali (ripristina ESP)
    pop ebp         ; Ripristina il frame del chiamante
    ret
Media ENDP
```

## 4. Cosa osservare nel Debugger di Visual Studio
Insegna ai tuoi studenti a:
1. Mettere un breakpoint sulla prima riga della funzione.
2. Aprire la finestra **Debug > Windows > Registers** (Registri).
3. Aprire la finestra **Debug > Windows > Memory > Memory 1**.
4. Nella finestra Memory, scrivere `ESP` nella barra dell'indirizzo.
5. Premere `F11` (Punto a riga successiva) e osservare come il valore di `ESP` cambia e come i dati appaiono nella memoria.

> [!IMPORTANT]
> **La prova del nove**: Se dimentichi `mov esp, ebp` prima di `ret`, il programma crasherà quasi sicuramente. Perché? Perché `ret` proverà a usare la variabile locale come se fosse l'indirizzo di ritorno!
