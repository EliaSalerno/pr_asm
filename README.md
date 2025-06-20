# ASSEMBLY... ROBA DA MATTI

### Impariamo ad usare assembly mediante esercitazioni

```
Ho creato un container in docker, sfruttando un ubuntu 32 bit.
Operazioni:
 - update upgrade autoremove;
 - install git, nano, gcc, nasm, gas;
 - create directory: prima_prova;

```
### > Prima prova (history)
Ho creato un programma che inverte un vettore inserito da tastira in c, 
poi ho compilato il c con gcc e con il medesimo compilatore ho assemblato lo stesso file. 

### > Primo test (history2)
Finito male la compilazione del file .s deve essere effettuata con gas. 
Da questo passaggio si crea il file .o (oggetto).

### > Secondo test (history3)
Ho scoperto che sia gas che nasm lavorano male con le librerie di c,
problema che invece non ha gcc. Infatti lavorando solo con gcc si puo'
tranquillamente superare il problema dettato dal c su assembly
