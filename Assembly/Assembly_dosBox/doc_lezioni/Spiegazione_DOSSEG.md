# La direttiva DOSSEG in Assembly 8086

La direttiva `DOSSEG`, che si trova all'inizio di molti programmi Assembly per MS-DOS (spesso insieme a `.MODEL SMALL`), è un'istruzione destinata direttamente al **Linker** (il programma `LINK.EXE`).

Ecco nel dettaglio cosa significa e perché si usa.

## Il problema dell'ordine dei segmenti

In Assembly, i programmi sono divisi in "Segmenti":
1. **Segmento di Codice (`.CODE`)**: dove risiedono le istruzioni eseguibili.
2. **Segmento Dati (`.DATA`)**: dove vengono dichiarate le variabili.
3. **Segmento di Stack (`.STACK`)**: la memoria temporanea.

Senza direttive specifiche, l'Assemblatore e il Linker potrebbero inserire questi segmenti nel file `.exe` finale in ordine sparso (o semplicemente nell'ordine in cui sono stati scritti nel file di testo sorgente).

Tuttavia, il sistema operativo **MS-DOS preferisce che la memoria dei programmi sia organizzata in un modo specifico e standardizzato** quando vengono caricati in RAM e avviati.

## Cosa fa la direttiva DOSSEG

La direttiva `DOSSEG` impone al linker di ignorare l'ordine testuale dei segmenti nel codice sorgente e di forzare un **Ordinamento Standard** (Standard Segment Ordering) stabilito da Microsoft per i programmi MS-DOS.

Questo ordinamento standard fa sì che, in memoria, i segmenti siano disposti rigorosamente in quest'ordine (dal basso verso l'alto):

1. **Segmenti di Codice**: Tutti i segmenti contenenti codice eseguibile (tipicamente quelli con classe 'CODE') vengono posizionati per primi.
2. **Segmenti Extra / Altri segmenti**: Segmenti generici non appartenenti a DGROUP.
3. **DGROUP (Data Group)**: Alla fine viene posizionato in un blocco unico il "Gruppo Dati", che al suo interno è ordinato rigorosamente in:
   * **Dati inizializzati (`.DATA`)**: Le variabili con un valore di partenza assegnato.
   * **Dati non inizializzati (`.BSS` o dati generici)**: Variabili senza un valore prestabilito.
   * **Stack (`.STACK`)**: Il segmento di stack viene posto *obbligatoriamente alla fine* del gruppo dati.

## È davvero necessario usarlo?

Oggi, quando si utilizzano le "direttive semplificate" offerte dal MASM (come `.MODEL SMALL`), l'assemblatore gestisce l'ordinamento in modo quasi automatico. 

Tuttavia, storicamente, la direttiva `DOSSEG` veniva inclusa per **garantire la massima compatibilità e stabilità**. In particolare, assicurarsi che lo Stack fosse posizionato alla fine dello spazio Dati preveniva errori di memoria, bug complessi o problemi quando si collegava il codice Assembly con moduli scritti in altri linguaggi (come il C).

In sintesi, scrivere `DOSSEG` equivale a dire: *"Ehi Linker, assembla questo eseguibile .EXE esattamente con la struttura standard che piace a MS-DOS"*.
