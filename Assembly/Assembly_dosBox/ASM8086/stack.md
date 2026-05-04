Lavorare sullo stack in assembly 16-bit (architettura x86/8086) è fondamentale e indispensabile per la gestione del flusso di programma, delle procedure e dei dati locali. Lo stack è un'area di memoria di tipo LIFO (Last In, First Out) che cresce verso indirizzi di memoria più bassi. [1, 2, 3, 4, 5] 
Ecco i motivi principali per cui è necessario gestirlo:
## 1. Gestione delle Procedure (CALL e RET)
Quando si chiama una procedura (CALL), il processore salva automaticamente l'indirizzo di ritorno (IP o CS:IP) sullo stack. [6] 

* Perché lavorarci: L'istruzione RET preleva questo indirizzo per tornare al punto di chiamata. Se lo stack viene corrotto (es. non si puliscono i dati inseriti), il programma salterà a un indirizzo errato, causando quasi sicuramente un crash. [6, 7] 

## 2. Passaggio di Parametri
Lo stack è il metodo standard per passare argomenti alle funzioni. [8] 

* Esempio: Prima di una CALL, si usano le istruzioni PUSH per inserire i valori (16-bit) da passare alla procedura.
* Pulizia: Il chiamante (caller) solitamente deve rimuovere i parametri inseriti dopo che la funzione è terminata, solitamente tramite un ADD SP, n (spostando lo stack pointer). [1] 

## 3. Salvataggio del Contesto (Registri)
Se una procedura utilizza registri (es. AX, BX, SI) il cui valore serve al codice chiamante, è buona norma salvarli all'inizio della procedura e ripristinarli alla fine.

* PUSH / POP: Si usa PUSH reg all'inizio e POP reg alla fine per preservare i dati. [1] 

## 4. Allocazione di Variabili Locali
Lo stack viene utilizzato per allocare temporaneamente memoria per le variabili locali di una funzione. [2, 9] 

* Come si fa: Si decrementa lo SP (Stack Pointer) per "spazio" sullo stack e si accede a tali dati tramite BP (Base Pointer). [1, 10] 

## Punti Chiave nel 16-bit

* Operazioni a 16-bit: Nell'8086, le istruzioni PUSH e POP lavorano solo su word a 16-bit (2 byte).
* Stack Pointer (SP): Indica la cima dello stack.
* Segmento di Stack (SS): Il registro SS punta al segmento di memoria dedicato allo stack. [1, 11] 

In sintesi, senza una corretta gestione dello stack, le procedure non funzionerebbero e i dati verrebbero sovrascritti, rendendo impossibile la programmazione strutturata.

[1] [https://www.youtube.com](https://www.youtube.com/watch?v=ibQyLShL-6I)
[2] [https://www.ibm.com](https://www.ibm.com/docs/it/xl-fortran-aix/16.1.0?topic=conventions-stack#:~:text=Lo%20stack%20%C3%A8%20una%20parte%20della%20memoria,indirizzi%20pi%C3%B9%20alti%20a%20indirizzi%20pi%C3%B9%20bassi.)
[3] [https://www.storchi.org](https://www.storchi.org/lecturenotes/lgi/5/fifth.pdf#:~:text=Lo%20stack%20e%27%20una%20porzione%20dinamica%20di,basso%2C%20cioe%27%20verso%20indirizzi%20via%20via%20minori.)
[4] [https://www.lenovo.com](https://www.lenovo.com/it/it/glossary/stack/#:~:text=Uno%20stack%20%C3%A8%20una%20struttura%20di%20dati,nello%20stack%20%C3%A8%20il%20primo%20che%20esci.)
[5] [https://www.storchi.org](https://www.storchi.org/lecturenotes/lgi/5/fifth.pdf#:~:text=Lo%20stack%20e%27%20una%20porzione%20dinamica%20di,di%20gestione%20interna%20e%27%20di%20tipo%20LIFO.)
[6] [https://www.ramsite.altervista.org](http://www.ramsite.altervista.org/comprogr/asmbase/masmtut/capitolo25.html)
[7] [https://new345.altervista.org](http://new345.altervista.org/SIS/Procedura_STACK.pdf#:~:text=L%27area%20in%20cui%20avviene%20il%20salvataggio%20e,della%20successiva%20istruzione%20da%20eseguire%29%20sullo%20stack.)
[8] [https://www.giobe2000.it](https://www.giobe2000.it/Tutorial/Schede/06-Stack/602.asp)
[9] [https://it.emcelettronica.com](https://it.emcelettronica.com/tecniche-di-stima-e-riduzione-dello-stack-nei-sistemi-embedded#:~:text=La%20memoria%20comunemente%20denominata%20stack%20%C3%A8%20una,salvati%20al%20momento%20della%20invocazione%20delle%20subroutines.)
[10] [https://cfpt.altervista.org](http://cfpt.altervista.org/es/3dinf/es2%20/IL%20LINGUAGGIO%20ASSEMBLY.pdf)
[11] [https://www.ingmonti.it](https://www.ingmonti.it/libri/Parte2/11%20Stack.pdf)
