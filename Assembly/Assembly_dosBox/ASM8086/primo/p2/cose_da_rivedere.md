# Conversazione Assembly x86 DOS

---

## Conversazione 1 — Programma che si blocca in DOSBox

### Domanda
```asm
DOSSEG
.MODEL SMALL
.STACK 100h
.DATA
   msg DB 'Hello,','$'
   msg1 DB 'world!',13,10,'$'
.CODE
MAIN PROC
   MOV AX,@DATA
   MOV DS, AX
   MOV DX, OFFSET msg
   MOV AH, 09h
   INT 21h
   MOV DX, OFFSET msg1
   INT 21h
   MOV AX, 4Ch
   INT 21h
MAIN ENDP
END MAIN
```

Perché quando lo lancio in DOSBox si blocca? Inoltre il mio intento era quello di stampare "Hello World" sulla stessa riga ma da due stringhe diverse.

### Risposta

Il problema è che dopo `INT 21h` per la prima stringa, non stai reimpostando `AH` a `09h` prima della seconda chiamata. In DOSBox, lo stato dei registri può cambiare dopo un interrupt, quindi `AH` potrebbe non essere più `09h`.

Ecco il codice corretto:

```asm
DOSSEG
.MODEL SMALL
.STACK 100h
.DATA
   msg  DB 'Hello, ','$'
   msg1 DB 'world!',13,10,'$'
.CODE
MAIN PROC
   MOV AX, @DATA
   MOV DS, AX

   ; Stampa prima stringa
   MOV AH, 09h
   MOV DX, OFFSET msg
   INT 21h

   ; Stampa seconda stringa (AH va reimpostato!)
   MOV AH, 09h
   MOV DX, OFFSET msg1
   INT 21h

   ; Uscita dal programma
   MOV AX, 4C00h
   INT 21h
MAIN ENDP
END MAIN
```

**Cosa ho cambiato e perché:**

- **`MOV AH, 09h` ripetuto** prima della seconda `INT 21h` — questo era il bug principale. L'interrupt `21h` modifica i registri internamente, quindi `AH` non è garantito a `09h` dopo la prima chiamata.
- **`MOV AX, 4C00h`** invece di `MOV AX, 4Ch` — è buona pratica includere anche `AL = 00h` come codice di uscita (exit code 0 = successo), anche se spesso funziona lo stesso.
- **Spazio in `'Hello, '`** — aggiunto uno spazio finale così le due parole sono separate correttamente sulla stessa riga.

**Perché "si bloccava":** senza `AH = 09h` corretto, la seconda `INT 21h` eseguiva una funzione DOS casuale (quella rimasta in `AH` dall'interrupt precedente), probabilmente mettendo il programma in attesa di input o causando un comportamento indefinito.

---

## Conversazione 2 — Perché AH cambia dopo INT 21h?

### Domanda

Pensavo di aver fatto una cosa sensata pensando al fatto che avevo già impostato `09h`, puoi spiegarmi perché cambia?

### Risposta

#### Come funziona `INT 21h`

Quando esegui `INT 21h`, stai chiamando il **DOS interrupt handler**, che è essenzialmente una funzione del sistema operativo. Come qualsiasi funzione, essa usa i registri della CPU liberamente per il suo lavoro interno.

La funzione `09h` (print string) internamente fa più o meno questo:

```
- legge il carattere puntato da DS:DX
- chiama INT 10h (BIOS video) per stamparlo
- incrementa DX
- controlla se è '$'
- se no, ripete il ciclo
```

Durante tutto questo lavoro, **AH viene sovrascritto** — per esempio quando chiama `INT 10h` deve mettere in `AH` il numero della funzione BIOS che vuole usare.

#### I registri non sono "tuoi" durante un interrupt

Pensa ai registri come variabili globali condivise tra te e il SO. La convenzione DOS è:

| Cosa è garantito | Cosa NON è garantito |
|---|---|
| Il valore di ritorno (se c'è) in `AX` | Tutti gli altri registri |
| Lo stack ripristinato | `BX`, `CX`, `DX`, `SI`, `DI`, `AH`... |

DOS **non promette** di preservare `AH` dopo l'interrupt — quindi dopo `INT 21h` devi considerare `AH` (e spesso altri registri) come **valori sconosciuti**.

#### Analogia in C

È come se in C scrivessi:

```c
printf("Hello, ");
// Ti aspetti che dopo printf() la variabile 'func' sia ancora quella che avevi impostato?
// No, printf() usa le sue variabili interne come vuole.
printf("world!\n");
```

Ogni chiamata è indipendente — devi sempre "ricaricare" i parametri prima di ogni chiamata.

#### Regola pratica

> In assembly x86 DOS, prima di ogni `INT` ricarica **sempre** tutti i registri che quella chiamata richiede, anche se li avevi appena impostati.

---

## Conversazione 3 — Posizione di CR e LF nella stringa

### Domanda

Ma se scrivo nel data segment `msg DB 'Hello, ', 13, 10, '$'` il carriage return e il line feed lo fanno prima di scrivere Hello oppure dopo?

### Risposta

Dopo! I byte sono disposti in memoria **nell'ordine in cui li scrivi**, e la funzione `09h` li stampa sequenzialmente da sinistra a destra.

Quindi `msg DB 'Hello, ', 13, 10, '$'` in memoria è:

```
48 65 6C 6C 6F 2C 20 0D 0A 24
H  e  l  l  o  ,     CR LF  $
```

La funzione `09h` parte dal primo byte e va avanti fino a `$`, quindi l'output è:

```
Hello, 
       ← cursore va a capo qui
```

Se invece scrivi `msg DB 13, 10, 'Hello, $'`:

```
0D 0A 48 65 6C 6C 6F 2C 20 24
CR LF H  e  l  l  o  ,     $
```

Prima va a capo, poi stampa `Hello,` — utile per esempio se vuoi separare l'output dal prompt di DOSBox.

**Regola semplice:** i byte `13, 10` si comportano come caratteri normali nella stringa — vengono stampati nel momento in cui la "testina" di lettura li raggiunge, né prima né dopo.

---

## Conversazione 4 — È giusto usare MOV AX, 4Ch per terminare?

### Domanda

È giusto scrivere `MOV AX, 4Ch` per terminare e poi chiamare `INT 21h`?

### Risposta

Sì, è giusto! Ma c'è una piccola precisazione.

`MOV AX, 4Ch` carica il valore `004Ch` in AX, quindi:

```
AH = 00h  ← SBAGLIATO, dovrebbe essere 4Ch
AL = 4Ch
```

Stai caricando il valore nel registro sbagliato! La funzione DOS vuole `4Ch` in **AH**, non in AL.

I modi corretti per scrivere la terminazione sono:

```asm
; Modo 1 - esplicito e chiaro
MOV AH, 4Ch
MOV AL, 00h    ; exit code 0
INT 21h

; Modo 2 - compatto, equivalente
MOV AX, 4C00h  ; AH = 4Ch, AL = 00h
INT 21h
```

Con `MOV AX, 4C00h` stai caricando `4C00h` in AX tutto insieme, quindi:

```
AH = 4Ch  ✓
AL = 00h  ✓
```

**Perché spesso `MOV AX, 4Ch` sembra funzionare lo stesso?**

Perché `AL` contiene il codice di uscita del programma, che normalmente nessuno controlla. Se `AH` finisce a `00h` invece di `4Ch`, in teoria stai chiamando la funzione DOS `00h` (terminate program) che **per caso** fa una cosa simile ma è deprecata. Funziona per fortuna, non per correttezza.

---

## Conversazione 5 — AH è a 4 bit come AL?

### Domanda

Ma `AH` è a 4 bit giusto? Come `AL`. Quindi come faccio a capire che `4Ch` occupa 4 bit?

### Risposta

No, `AH` e `AL` sono entrambi a **8 bit**, non 4! Facciamo chiarezza sulla struttura dei registri.

#### Struttura del registro AX

```
AX (16 bit)
┌────────────────┬────────────────┐
│   AH (8 bit)   │   AL (8 bit)   │
│    0 0 0 0     │    0 0 0 0     │
└────────────────┴────────────────┘
```

- `AX` = 16 bit
- `AH` = 8 bit alti di AX (**H**igh)
- `AL` = 8 bit bassi di AX (**L**ow)

#### Quanto vale 4Ch?

`4C` è un numero **esadecimale**. Ogni cifra esadecimale occupa **4 bit** (chiamati nibble), quindi due cifre hex = 8 bit, che sta perfettamente in un registro a 8 bit come `AH`:

```
4    C
0100 1100
─┬── ─┬──
 │    └── 4 bit (nibble basso)
 └─────── 4 bit (nibble alto)
```

Quindi `4Ch` = `0100 1100` in binario = 8 bit = entra esattamente in `AH`.

#### Regola pratica per capire quanti bit occupa un numero hex

| Cifre hex | Bit occupati | Sta in |
|---|---|---|
| `4C` | 8 bit | AH, AL |
| `4C00` | 16 bit | AX |
| `4C000000` | 32 bit | EAX |

Quindi quando vedi `4Ch` sai subito che è un valore a 8 bit e va bene per `AH` o `AL`.