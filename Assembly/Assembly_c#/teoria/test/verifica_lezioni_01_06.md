# Test di Verifica: Fondamenti di Assembly x86 (Lezioni 1-6)

**Studente:** _________________________________ **Data:** _______________

---

## Parte 1: Architettura e Rappresentazione (Teoria)

**1. Considera un valore memorizzato in un registro `EAX` di 32 bit. Quanti byte occupa?**
   a) 1 byte
   b) 2 byte
   c) 4 byte
   d) 8 byte

**2. Descrivi brevemente cosa succede durante la fase di "FETCH" nel ciclo della CPU.**
   ________________________________________________________________________________
   ________________________________________________________________________________

**3. Converti il numero decimale 20 in Esadecimale e Binario:**
   - Esadecimale: ___________
   - Binario:     ___________

**4. Quale registro funge da "puntatore all'istruzione successiva" (Instruction Pointer)?**
   a) EAX
   b) ESP
   c) EIP
   d) EBP

---

## Parte 2: Registri e Memoria (Analisi)

**5. Qual è la differenza principale tra i registri `EAX` e `ESP`?**
   ________________________________________________________________________________
   ________________________________________________________________________________

**6. Se `EAX` contiene il valore `0x000000FF`, quale sarà il suo valore dopo l'istruzione `INC EAX`?**
   ________________________________________________________________________________

**7. Perché lo Stack viene definito una struttura LIFO? Cosa significa questo termine in pratica?**
   ________________________________________________________________________________
   ________________________________________________________________________________

---

## Parte 3: Lo Stack Frame e Calling Convention (Logica)

**8. Nella convenzione `cdecl`, chi è responsabile della pulizia dei parametri dallo stack dopo una chiamata?**
   a) La funzione chiamata (Assembly)
   b) Il chiamante (C# / C++)
   c) Il Sistema Operativo
   d) Il Garbage Collector

**9. Osserva il seguente frammento di codice:**
   ```asm
   push ebp
   mov ebp, esp
   mov eax, [ebp + 8]
   ```
   **Cosa viene caricato nel registro `EAX`?**
   a) L'indirizzo di ritorno
   b) L'EBP salvato
   c) Il primo parametro della funzione
   d) La prima variabile locale

**10. Di quanti byte si sposta lo Stack Pointer (`ESP`) dopo un'istruzione `PUSH EBX` in un sistema a 32 bit?**
   a) +4
   b) -4
   c) +8
   d) -8

---

## Parte 4: Esercizio di Lettura Codice

**11. Cosa restituisce in `EAX` questa funzione se chiamata con i parametri (10, 5)?**
   ```asm
   Mistero PROC
     push ebp
     mov ebp, esp
     mov eax, [ebp + 8]
     mov ecx, [ebp + 12]
     sub eax, ecx
     inc eax
     pop ebp
     ret
   Mistero ENDP
   ```
   **Risultato:** ___________

---

## Esercizio Pratico (Opzionale/Lab)
Scrivi un'istruzione Assembly che sposti il valore `42` nel registro `EBX` e poi lo sommi al contenuto di `EAX`.

________________________________________________________________________________
________________________________________________________________________________
