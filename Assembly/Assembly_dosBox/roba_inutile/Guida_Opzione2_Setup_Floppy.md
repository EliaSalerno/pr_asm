# Soluzione 2: Installare MASM 6.0 dai Floppy Disk originali

Questa soluzione ricostruisce l'esperienza originale degli anni '90. Hai scaricato i fie per l'ambiente **MASM 6.0**, ma sono in formato **.IMG**. Queste sono **immagini esatte dei Floppy Disk da 3.5 pollici** che Microsoft vendeva.

Per usare questo metodo dovrai effettuare una vera e propria vecchia installazione di Microsoft DOSBox.

## Procedura passo-passo

### 1. Prepara la cartella e DOSBox
* Se non l'hai fatto, installa [DOSBox](https://www.dosbox.com/download.php?main=1).
* Per comodità, rinomina la cartella con i file IMG in un percorso più breve, senza parentesi e senza spazi. Ad esempio puoi usare: `C:\Users\elias\Desktop\Assembly\masm_floppy` (dove l'ho già creata io e copiati i dischi per evitare errori di percorso in DOSBox).

### 2. Esegui il setup dei floppy dentro DOSBox
Una volta aperto **DOSBox**, ti ritrovi in Z:\>. Esegui i seguenti comandi con precisione:

**A. Monta il disco `C:` del vecchio PC:**
Si consiglia di usare la tua cartella Assembly principale (così vi avrai i programmi e il compilatore assieme).
```text
mount c "C:\Users\elias\Desktop\Assembly\ASM8086"
```

**B. Monta tutti e 7 i floppy disk contemporaneamente come disco `A:` (Drive dei dischetti) dentro DOSBox:**
```text
imgmount a "C:\Users\elias\Desktop\Assembly\masm_floppy\disk01.img" "C:\Users\elias\Desktop\Assembly\masm_floppy\disk02.img" "C:\Users\elias\Desktop\Assembly\masm_floppy\disk03.img" "C:\Users\elias\Desktop\Assembly\masm_floppy\disk04.img" "C:\Users\elias\Desktop\Assembly\masm_floppy\disk05.img" "C:\Users\elias\Desktop\Assembly\masm_floppy\disk06.img" "C:\Users\elias\Desktop\Assembly\masm_floppy\disk07.img" -t floppy
```

**C. Spostati nel drive A (il primo dischetto montato) per avviare il Setup:**
```text
a:
setup.exe
```

### 3. Segui il Microsoft Setup
A questo punto partirà lo storico "Microsoft Setup" azzurro. Segui semplicemente le istruzioni a schermo per avviare l'installazione. Ti chiederà dove installare MASM (accetta tranquillamente `C:\MASM` in quanto sarà sul tuo disco virtuale).

> **IMPORTANTE: Il cambio di dischi**  
> Durante l'installazione, il Setup ti scriverà un messaggio del tipo `Inserisci il Disco 2...`.
> NON devi chiudere DOSBox per farlo. Ti basta **premere la combinazione di tasti `CTRL + F4`** sulla tastiera: DOSBox capirà immediatamente e scambierà l'immagine `disk01.img` con la successiva passata in lista nel comando imgmount, perciò `disk02.img`. Segui premendo finché non ti servirà il disco 7, finisce l'installazione.

Fatto! Ritroverai i tuoi eseguibili in `c:\masm` e potrai usarli in DOSBox. Se usi questi file, ricordati anche di aggiungerli al `PATH` o usare il loro percorso intero quando li richiami dal DOS.
