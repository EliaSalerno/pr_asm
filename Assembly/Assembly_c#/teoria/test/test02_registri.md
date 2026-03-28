# Test — Lezione 2: I Registri del Processore x86

> **Istruzioni:** Il test è composto da domande a risposta multipla, domande di completamento
> e domande a risposta aperta. Tempo consigliato: 30 minuti.

---

## Parte A — Domande a risposta multipla

**1.** Quanti registri **general-purpose** da 32 bit sono presenti nell'architettura x86-32?

- a) 4
- b) 6
- c) 8
- d) 16

---

**2.** Quale registro viene usato **per convenzione** come accumulatore e per restituire il valore di ritorno di una funzione?

- a) EBX
- b) ECX
- c) EAX
- d) EDI

---

**3.** Dato `EAX = 0x12345678`, qual è il valore di **AL**?

- a) `0x12`
- b) `0x34`
- c) `0x56`
- d) `0x78`

---

**4.** Dato `EAX = 0x12345678`, qual è il valore di **AH**?

- a) `0x12`
- b) `0x34`
- c) `0x56`
- d) `0x78`

---

**5.** Dato `EAX = 0x12345678`, qual è il valore di **AX**?

- a) `0x1234`
- b) `0x5678`
- c) `0x3456`
- d) `0x0012`

---

**6.** Se esegui `mov al, 0xFF` mentre `EAX = 0x12340000`, qual è il nuovo valore di EAX?

- a) `0x000000FF`
- b) `0x1234FF00`
- c) `0x123400FF`
- d) `0xFF000000`

---

**7.** Quale registro contiene sempre **l'indirizzo di cima dello stack**?

- a) EBP
- b) ESP
- c) ESI
- d) EIP

---

**8.** Quale flag viene impostato a 1 quando il **risultato di un'operazione è zero**?

- a) SF (Sign Flag)
- b) CF (Carry Flag)
- c) OF (Overflow Flag)
- d) ZF (Zero Flag)

---

**9.** Il registro **EIP** può essere modificato direttamente con `mov eip, eax`?

- a) Sì, come qualsiasi registro
- b) No, si può modificare solo con istruzioni di salto (`jmp`, `call`, `ret`)
- c) Sì, ma solo in modalità privilegiata
- d) No, EIP è di sola lettura e non cambia mai

---

**10.** Quali tra questi registri sono **callee-saved** (la funzione chiamata deve preservarli)?

- a) EAX, ECX, EDX
- b) EBX, ESI, EDI
- c) ESP, EIP
- d) EAX, EBX

---

**11.** Dopo l'istruzione `sub eax, eax`, quale flag viene impostato a 1?

- a) CF
- b) OF
- c) ZF
- d) SF

---

**12.** Quale dei seguenti registri **non** ha sottoregistri a 8 bit accessibili direttamente?

- a) EAX
- b) EBX
- c) ESI
- d) ECX

---

## Parte B — Completamento

Completa le frasi o le celle della tabella.

**13.** Completa la tabella dei sottoregistri:

| 32-bit | 16-bit (bassa) | 8-bit alto | 8-bit basso |
|--------|----------------|-----------|------------|
| EAX    | AX             | AH        | AL         |
| EBX    | ___            | ___       | ___        |
| ECX    | ___            | ___       | ___        |
| EDX    | ___            | ___       | ___        |
| ESI    | ___            | —         | —          |
| EDI    | ___            | —         | —          |

**14.** Completa la sequenza di operazioni e indica il valore di EAX dopo ogni istruzione:

```asm
mov eax, 0          ; EAX = ___________
mov al,  0FFH       ; EAX = ___________
mov ah,  0A0H       ; EAX = ___________
```

**15.** Il flag **SF** (Sign Flag) viene impostato a 1 quando _________________________.

**16.** Il flag **CF** (Carry Flag) viene impostato a 1 quando _________________________.

---

## Parte C — Domande a risposta aperta

**17.** *(4 punti)* Spiega perché i registri sono **molto più veloci** della RAM per la CPU. Quanti registri general-purpose ha un processore x86-32?

> *Risposta:*
>
>
>

---

**18.** *(3 punti)* Cosideriamo la distinzione tra registri **caller-saved** e **callee-saved**. Spiega la differenza: chi si preoccupa di salvare EAX prima di una chiamata a funzione? E chi si preoccupa di salvare EBX?

> *Risposta:*
>
>
>

---

**19.** *(3 punti)* Un tuo collega scrive il seguente codice Assembly. Individua e spiega l'**errore concettuale**:

```asm
mov al, 255        ; al = 0xFF
; qui qualcuno vuole poi usare EAX come se fosse rimasto 0x00000000
```

> *Risposta:*
>
>
>

---

## Griglia di valutazione

| Sezione | Punti disponibili |
|---------|-----------------|
| Parte A (12 domande × 1 punto) | 12 |
| Parte B (4 esercizi × 1.5 punti) | 6 |
| Parte C (3 domande aperte) | 10 |
| **Totale** | **28** |

> Sufficienza: 17/28
