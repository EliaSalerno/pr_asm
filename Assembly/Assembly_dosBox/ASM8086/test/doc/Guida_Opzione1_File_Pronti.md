# Soluzione 1: Uso dei file pre-estratti (Consigliata)

Questa è la soluzione più comoda, in quanto ho già scaricato per te le versioni originali a 16-bit degli anni '90 di `MASM.EXE` e `LINK.EXE` direttamente all'interno della tua cartella di progetto, pronti all'uso.

I file si trovano già nel percorso:
`C:\Users\elias\Desktop\Assembly\ASM8086\tools`

## Procedura passo-passo

### 1. Scarica e installa DOSBox
Se non lo hai ancora fatto, scarica l'emulatore gratuito dal sito ufficiale e installalo:
[Download DOSBox (Windows)](https://www.dosbox.com/download.php?main=1)

### 2. Configura DOSBox temporaneamente e compila
Una volta aperto **DOSBox**, ti troverai davanti a una schermata nera con la scritta `Z:\>`.
Digita esattamente questi comandi:

**A. Collega la tua cartella al disco virtuale "C" di DOSBox:**
```text
mount c "C:\Users\elias\Desktop\Assembly\ASM8086"
```
*(Premi invio, dovrebbe apparire un messaggio "Drive C is mounted as...")*

**B. Spostati nel disco virtuale C:**
```text
c:
```

**C. Aggiungi i tool al PATH così DOSBox li riconosce ovunque:**
```text
set PATH=%PATH%;c:\tools
```

**D. Vai nella cartella dell'esercizio (ad esempio "primo"):**
```text
cd primo
```

**E. Compila fialmente il codice (Masm, Link ed esecuzione):**
```text
masm primo.asm;
link primo.obj;
primo.exe
```
*(Nota il punto e virgola `;` alla fine di masm e link: serve per dire a MASM di usare le impostazioni predefinite senza farti domande a schermo).*

Se hai scritto il listato `primo.asm` correttamente, lanciando `primo.exe` dovresti veder spuntare il tuo magico **"Hello, World!"** a schermo.
