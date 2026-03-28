# Test — Lezione 1: Architettura del Computer e Introduzione all'Assembly

> **Istruzioni:** Il test è composto da domande a risposta multipla (una sola risposta corretta),
> domande a risposta aperta e conversioni numeriche. Tempo consigliato: 25 minuti.

---

## Parte A — Domande a risposta multipla

**1.** Quale delle seguenti affermazioni descrive meglio l'architettura di von Neumann?

- a) Programma e dati si trovano in memorie separate
- b) Programma e dati si trovano nella stessa memoria RAM
- c) La CPU esegue istruzioni senza usare la RAM
- d) I dati sono sempre nella cache, mai nella RAM

---

**2.** Nella sigla "x86", la "x" indica:

- a) Un singolo processore specifico prodotto da Intel nel 1986
- b) Una famiglia di processori compatibili all'indietro con l'8086
- c) Il numero di registri disponibili nella CPU
- d) Il tipo di bus dati usato dal processore

---

**3.** In quale dei seguenti passaggi del ciclo Fetch-Decode-Execute la CPU **decodifica** l'istruzione?

- a) FETCH
- b) DECODE
- c) EXECUTE
- d) WRITE-BACK

---

**4.** Quale registro contiene l'indirizzo dell'istruzione che la CPU eseguirà prossimamente?

- a) ESP
- b) EBP
- c) EAX
- d) EIP

---

**5.** Quanti bit compongono una **DWORD** (Double Word)?

- a) 8
- b) 16
- c) 32
- d) 64

---

**6.** In quale anno è nato l'Intel 8086, da cui deriva la famiglia x86?

- a) 1965
- b) 1978
- c) 1985
- d) 1993

---

**7.** Il numero esadecimale `2AH` corrisponde in decimale a:

- a) 24
- b) 36
- c) 42
- d) 90

---

**8.** Quale differenza fondamentale esiste tra l'architettura von Neumann e l'architettura Harvard?

- a) Von Neumann usa transistor, Harvard no
- b) Harvard separa la memoria programma dalla memoria dati
- c) Von Neumann supporta solo 16 bit, Harvard supporta 32 bit
- d) Non esiste nessuna differenza pratica

---

**9.** Perché in questo corso si usa la versione **32-bit (IA-32)** dell'architettura x86 invece di quella 64-bit?

- a) Perché il 64-bit non esiste ancora in commercio
- b) Perché è più semplice e permette di capire i concetti fondamentali
- c) Perché MASM non supporta il 64-bit
- d) Perché C# non può interfacciarsi con DLL 64-bit

---

**10.** Un processore con bus indirizzi a 32 bit può indirizzare al massimo:

- a) 2 GB di RAM
- b) 4 GB di RAM
- c) 8 GB di RAM
- d) 16 GB di RAM

---

## Parte B — Conversioni numeriche

Converti i seguenti valori nelle basi richieste. Mostra i passaggi intermedi.

**11.** Converti il decimale **255** in:
- Binario: _______________
- Esadecimale: _______________

**12.** Converti il decimale **128** in:
- Binario: _______________
- Esadecimale: _______________

**13.** Converti da esadecimale a decimale:
- `FFH` = _______________
- `1AH` = _______________
- `80H` = _______________

**14.** Quanti **valori distinti** può rappresentare:
- Un **byte** (8 bit)? _______________
- Una **DWORD** (32 bit)? _______________

---

## Parte C — Domande a risposta aperta

**15.** *(4 punti)* Descrivi brevemente le tre fasi principali del ciclo **Fetch-Decode-Execute**. Che ruolo ha il registro EIP in questo ciclo?

> *Risposta:*
>
>
>

---

**16.** *(3 punti)* Elenca **tre motivi pratici** per cui un programmatore moderno dovrebbe conoscere l'Assembly, anche se non lo usa quotidianamente.

> *Risposta:*
>
> 1.
> 2.
> 3.

---

**17.** *(3 punti)* Spiega la differenza tra i componenti principali di una CPU: **ALU**, **CU** e **registri**. Quale dei tre "decide" quale istruzione eseguire?

> *Risposta:*
>
>
>

---

## Griglia di valutazione

| Sezione | Punti disponibili |
|---------|-----------------|
| Parte A (10 domande × 1 punto) | 10 |
| Parte B (4 esercizi × 1.5 punti) | 6 |
| Parte C (3 domande aperte) | 10 |
| **Totale** | **26** |

> Sufficienza: 16/26
