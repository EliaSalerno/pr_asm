# Verifica 1: Architettura x86 e Linguaggio Assembly

**Studente:** __________________________  **Data:** _______________

**Argomenti:** Architettura di Von Neumann, Registri, Memoria (Little-Endian), Modalità di Indirizzamento, Storia x86 e Micro-architettura (Lezioni 1-3 + Approfondimenti).

---

### Sezione 1: Architettura e Storia del Processore

**1. Nell'architettura di Von Neumann, qual è la caratteristica distintiva rispetto all'architettura Harvard?**
   - A) La CPU e la RAM sono integrate nello stesso chip.
   - B) Programma (istruzioni) e dati risiedono nella stessa memoria fisica.
   - C) Esistono bus separati per dati e istruzioni.
   - D) La CPU non utilizza registri interni.

**2. Spiega brevemente la differenza tra un'architettura CISC (come x86) e una RISC (come ARM) in termini di esecuzione delle istruzioni e presenza del micro-sequencer.**
_______________________________________________________________________________________
_______________________________________________________________________________________

**3. Calcola l'indirizzo fisico in Modalità Reale (x86-16) sapendo che il registro di segmento `CS` è `0x2000` e l'Instruction Pointer `IP` è `0x1500`.** *(Mostra il calcolo)*
_______________________________________________________________________________________

**4. Perché l'architettura a 64 bit è oggi chiamata "AMD64" o "x86-64" anche sui processori Intel?**
   - A) Perché Intel ha acquistato AMD nel 2003.
   - B) Perché AMD ha progettato l'estensione a 64 bit compatibile con x86, mentre il progetto IA-64 di Intel (Itanium) era incompatibile.
   - C) Perché Intel ha abbandonato completamente il marchio x86 nel 2003.
   - D) Perché i processori a 64 bit funzionano solo con schede madri AMD.

---

### Sezione 2: Registri e Ciclo di Esecuzione

**5. Qual è la funzione del Micro-sequencer all'interno della Control Unit?**
   - A) Eseguire i calcoli aritmetici tra due registri.
   - B) Tradurre un'istruzione Assembly complessa in una sequenza di micro-operazioni ($\mu op$).
   - C) Gestire solo il clock del sistema.
   - D) Sostituire la RAM durante le operazioni di I/O.

**6. Se il registro `EAX` contiene il valore `0x12345678`, quale sarà il contenuto dei seguenti sottoregistri?**
   - `AX`: ____________________
   - `AH`: ____________________
   - `AL`: ____________________

**7. Descrivi i tre flag principali del registro EFLAGS coinvolti nelle operazioni di confronto:**
   - **ZF (Zero Flag):** _________________________________________________
   - **SF (Sign Flag):** _________________________________________________
   - **CF (Carry Flag):** _________________________________________________

**8. Durante il ciclo Fetch-Decode-Execute, quale registro viene aggiornato automaticamente per puntare alla prossima istruzione?**
   - A) EAX
   - B) EBP
   - C) EIP
   - D) ESP

---

### Sezione 3: Memoria e Indirizzamento

**9. Little-Endian: Rappresenta come il valore DWORD `0xDEADBEEF` viene memorizzato in RAM a partire dall'indirizzo `0x1000`.**
   - `0x1000`: [________]
   - `0x1001`: [________]
   - `0x1002`: [________]
   - `0x1003`: [________]

**10. Indica la modalità di indirizzamento usata nelle seguenti istruzioni MASM:**
   - `mov eax, 100` : __________________________________
   - `mov ebx, ecx` : __________________________________
   - `mov edx, [var]` : __________________________________
   - `mov eax, [ebx + esi*4]` : __________________________________

**11. Qual è la differenza fondamentale tra le istruzioni `mov eax, x` e `mov eax, [x]` in MASM?**
_______________________________________________________________________________________
_______________________________________________________________________________________

---

### Sezione 4: Esercizio Pratico e Conversioni

**12. Conversioni Rapide:**
   - Converti il numero decimale **42** in Binario ed Esadecimale. ____________________
   - Quanti byte compongono una **DWORD**? ______
   - Quanti bit compongono una **WORD**? ______

**13. Analisi Micro-operazioni:**
   L'istruzione `PUSH EAX` viene scomposta dal micro-sequencer in più passaggi. Ordina correttamente le seguenti micro-operazioni (scrivi 1, 2, 3...):
   - [ ] Invio del contenuto di EAX sul bus verso la memoria.
   - [ ] Incremento di EIP per la prossima istruzione.
   - [ ] Sottrazione di 4 dal registro ESP ($ESP \leftarrow ESP - 4$).
   - [ ] Attivazione del segnale di scrittura in memoria (`MEM_WRITE`).

---

### Sezione 5: Domanda Bonus (Ragionamento)

**14. Se un processore ha un bus indirizzi a 32 bit, può indirizzare teoricamente 4 GB di RAM. Se passiamo a un bus a 36 bit (tecnologia PAE), quanta RAM può indirizzare?** *(Esprimi il risultato in GB)*
_______________________________________________________________________________________
