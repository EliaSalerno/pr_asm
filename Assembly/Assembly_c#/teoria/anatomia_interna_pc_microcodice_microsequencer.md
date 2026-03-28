# Anatomia Interna della CPU: Microcodice e Micro-sequencer

Nelle architetture moderne (specialmente x86), le istruzioni Assembly non vengono eseguite direttamente dai circuiti, ma vengono tradotte in operazioni più semplici. Questo processo è gestito dal binomio **Micro-sequencer** e **Control Store**.

## 1. Il Micro-sequencer: Il "Cervello del Cervello"

Il **micro-sequencer** è l'unità logica all'interno della *Control Unit* incaricata di generare gli indirizzi delle micro-istruzioni necessarie per completare un comando Assembly.

### Funzioni Principali

* **Generazione dell'Indirizzo:** Riceve l'istruzione decodificata e punta alla prima riga di microcodice nel **Control Store**.
* **Gestione del Flusso:** Decide la micro-operazione ($\mu op$) successiva basandosi su incrementi, salti condizionati o flag di stato (es. Zero, Carry).
* **Chiusura del Ciclo:** Una volta terminata la sequenza, invia il segnale di *Fetch* per caricare la prossima istruzione dalla RAM.

---

## 2. Il Microcodice: Dove Risiede?

Il microcodice non è un software accessibile all'utente, ma è integrato fisicamente nel processore.

* **Control Store (ROM):** Una memoria a sola lettura interna al die della CPU dove sono "scolpite" le sequenze di micro-operazioni.
* **SRAM di Patch:** Una piccola porzione di memoria volatile dove il BIOS/OS carica aggiornamenti per correggere bug hardware (es. vulnerabilità *Spectre*).
* **Accessibilità:** È proprietario e criptato; non può essere letto o modificato direttamente senza firme digitali del produttore (Intel/AMD).

---

## 3. Esempio Pratico: Esecuzione di `PUSH EAX`

Per capire come interagiscono, analizziamo cosa succede "sotto il cofano" quando eseguiamo una singola istruzione Assembly di inserimento nello stack.

### La sequenza delle Micro-operazioni ($\mu op$)

Il micro-sequencer scompone `PUSH EAX` in questa coreografia di segnali elettrici:

| Step | Operazione | Descrizione Tecnica |
| --- | --- | --- |
| **1** | **Decremento ESP** | L'ALU sottrae 4 (o 8) byte dallo Stack Pointer: $ESP \leftarrow ESP - 4$. |
| **2** | **Indirizzamento** | Il valore di $ESP$ viene inviato al *Memory Address Register* (MAR). |
| **3** | **Copia Dati** | Il contenuto di $EAX$ viene spostato sul bus verso il *Memory Data Register* (MDR). |
| **4** | **Scrittura** | Viene attivato il segnale `MEM_WRITE` per scrivere il dato nella Cache/RAM. |
| **5** | **Next Instruction** | Viene incrementato l'Instruction Pointer ($EIP$) per la prossima istruzione. |

---

## Differenze tra Architetture

> ### **CISC (Intel/AMD)**
> 
> 
> Utilizzano un micro-sequencer complesso perché le istruzioni sono di lunghezza variabile e compiono molte azioni (come l'esempio `PUSH` sopra).
> ### **RISC (ARM/Apple M5)**
> 
> 
> Spesso **non hanno un micro-sequencer**. Le istruzioni sono talmente semplici che sono "cablate" (*hardwired*) direttamente nei circuiti. Il programmatore deve scrivere manualmente le singole operazioni di sottrazione e store.

