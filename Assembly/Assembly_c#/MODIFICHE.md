# MODIFICHE — Corso Assembly x86 (Assembly_c#)

Elenco di tutte le correzioni applicate, organizzate per area. Ogni blocco include:
**File**, **Problema**, **Correzione** e (dove utile) la **prova** verificata a runtime.

> Tutte le correzioni sono state verificate compilando/linkando con `ml.exe`/`link.exe`
> (VS 2022 MSVC 14.38) ed eseguendo i progetti con `dotnet` (verifica end-to-end).

---

<details>
<summary><b>1. Pipeline MASM → DLL (compila.bat) — errore LNK2001 / DLL da 0 byte</b></summary>

**File:** `pratica/esercizio01_somma/compila.bat`, `esercizio02_massimo`, `esercizio03_fattoriale`,
`esercizio04_array`, `esercizio05_stringa`, `esercizio06_conta_carattere`, `esercizio07_stack_frame`,
`template_progetto/compila.bat`

**Problema**
- Tutti gli script usavano `link ... /EXPORT:_Nome`. Con `.MODEL FLAT, C` MASM genera già il simbolo
  `_Nome` nell'oggetto; il linker x86 aggiunge un ulteriore `_` ai nomi `/EXPORT`, quindi
  `/EXPORT:_Somma` cercava `__Somma` → **LNK2001**, DLL da 0 byte (es. `esercizio01_somma/somma.dll`,
  che era effettivamente di 0 byte).
- Mancava inoltre un entry point per le DLL (`__DllMainCRTStartup` non risolto quando si collega senza CRT).

**Correzione**
- Export **senza underscore**: `link /DLL /SUBSYSTEM:WINDOWS /EXPORT:Somma /OUT:somma.dll somma.obj`.
- Aggiunto **`/NOENTRY`**: così non serve alcuna `DllMain` né la libreria CRT (nessun warning LNK4086).
- Script uniformati con blocco `[1/3]…[3/3]` e controlli `errorlevel` (la mancata copia ora è segnalata).

**Prova**
- Tutte le 9 DLL compilate e linkate correttamente (1536 byte ciascuna, export verificati con
  `dumpbin /EXPORTS`: `Somma`, `Massimo`, `Fattoriale`, `SommaArray`, `LunghezzaStringa`,
  `ContaCarattere`, `CalcolaMedia`, `InvertiBit + IsolaBit`, `CreaColore + EstraiVerde`).

</details>

<details>
<summary><b>2. Posizione della DLL per il P/Invoke di .NET</b></summary>

**File:** tutti i `compila.bat` sopra indicati

**Problema**
- .NET cerca le DLL nella cartella dell'eseguibile (`bin\Debug\net8.0-windows\`), **non** nella root del
  progetto. Gli esercizi 1-5 copiavano la DLL solo in `csharp_runner\` (root) → `DllNotFoundException`.
- Esercizi 6 e 7 copiavano in `bin\x86\Debug\net8.0-windows\`, cartella che il progetto **non genera**
  mai (l'output reale è `bin\Debug\net8.0-windows\` senza `x86`).

**Correzione**
- Esercizi 1-5: copia in `..\..\csharp_runner\` **e** in `..\..\csharp_runner\bin\Debug\net8.0-windows\`
  (creata se assente).
- Esercizi 6-9: copia in `bin\Debug\net8.0-windows\` del proprio progetto.
- Template: entrambe le cartelle `bin\x86\...` e `bin\Debug\...`, con creazione automatica.

**Prova**
- `dotnet run` su `csharp_runner` esegue **tutti** i 5 test con esito ✅ (Somma=42, Massimo, Fattoriale 1..10,
  SommaArray=150, LunghezzaStringa 0..11).
- `dotnet run` su esercizi 6-9: ContaCarattere OK, CalcolaMedia=75 ✅, IsolaBit/InvertiBit OK, CreaColore
  `0xFF8040`/EstraiVerde `0x33` ✅.

</details>

<details>
<summary><b>3. Esercizi 7, 8, 9 incompleti (file mancanti)</b></summary>

**File**

| Cartella | Modifica |
|----------|----------|
| `pratica/esercizio07_stack_frame/` | **Aggiunto** `MediaTest.csproj` (mancava del tutto → `dotnet run` impossibile) |
| `pratica/esercizio08_bitwise/` | **Aggiunti** `compila.bat` e `BitwiseTest.csproj` (mancavano) |
| `pratica/esercizio09_colori_rgb/` | **Aggiunti** `compila.bat` e `ColoriTest.csproj` (mancavano) |

I `.csproj` sono identici a `template_progetto/TestRunner.csproj` (`net8.0-windows` + `<PlatformTarget>x86</PlatformTarget>`).

</details>

<details>
<summary><b>4. bitwise.asm — istruzione inesistente e codice morto</b></summary>

**File:** `pratica/esercizio08_bitwise/bitwise.asm`

**Problema**
- `IsolaBit` conteneva `mov eax, [ebp+12]` … poi `chr eax, cl` → istruzione **inesistente**
  (`error A2008: syntax error`), quindi il file **non assemblava**.
- Subito dopo ricaricava `eax`/`ecx` (codice morto) e lasciava commenti contradictori sullo shift.

**Correzione**
- Rimossa l'istruzione invalida e il blocco morto; `IsolaBit` ora usa solo maschera dinamica
  `mov edx,1` / `shl edx,cl` / `and eax,edx` (con commento chiaro).

**Prova**
- `ml /c /coff bitwise.asm` → OK; export `InvertiBit` + `IsolaBit`; test C# esegue NOT e IsolaBit correttamente.

</details>

<details>
<summary><b>5. errore concettuale: "mov eax, x carica l'indirizzo"</b></summary>

**File**
- `teoria/lezione03_memoria.md` (§3.4.3 e esercizio di consolidamento n.4)
- `teoria/test/test03_memoria.md` (Q6, Q7, Q16)
- `teoria/test/README.md` (chiave Test 3 + risposta di verifica_1 Q11)

**Problema**
- La lezione e i test affermavano che in MASM `mov eax, x` (senza `[]`) carica l'**indirizzo**. È falso:
  in MASM `mov eax, x` ≡ `mov eax, [x]` (stessa istruzione, `A1 ...`); l'indirizzo si ottiene solo con
  `lea eax, x` o `mov eax, OFFSET x` (verificato al disassemblatore).
- Il README delle chiavi (verifica_1 Q11) riconosceva però che sono equivalenti → **autocontraddizione**.

**Correzione**
- §3.4.3 riscritto con i casi corretti e nota "differenza rispetto al C".
- Test03 Q6 (equivalenza MASM), Q7 (cos'è `lea`), Q16 (trova l'errore nella frase del collega).
- Chiavi aggiornate: Test 3 → `…6-b, 7-c…`; verifica_1 Q11 riscritta (equivalenza + `lea`/`OFFSET`).

</details>

<details>
<summary><b>6. Narrativa "serve il prefisso _ nel nome" (calling convention)</b></summary>

**File**
- `teoria/lezione06_calling_convention.md` (§6.3, §6.5, §6.8, esercizio 5)
- `teoria/test/test06_calling_convention.md` (Q7, Q13, Q14, Q15)
- `template_progetto/README.md`, `template_progetto/Program.cs`

**Problema**
- Si insegnava di scrivere il prefisso `_` a mano/nell'export. In realtà con `.MODEL FLAT, C` lo aggiunge
  MASM e nel `/EXPORT` va messo **senza underscore** (vedi punto 1). I test chiedevano di scrivere
  `PUBLIC _Prodotto` / `_Prodotto PROC` che con la modalità C produrrebbe `__Prodotto`.

**Correzione**
- §6.5 riscritto (i 3 passi corretti + nota esplicativa su LNK2001 e `/NOENTRY`), §6.8 tabella aggiornata,
  §6.3 schema `call NomeFunzione`, esercizio 6.9 `Massimo`.
- Test06: Q7 riformulata (export senza underscore), Q13 `Prodotto` (niente `_`), Q14/Q15 rinominati.
- Template: README e commento in Program.cs corretti.

</details>

<details>
<summary><b>7. test05 Q13 — diagramma dello stack sbilanciato di 4 byte</b></summary>

**File:** `teoria/test/test05_stack.md`

**Problema**
- Con `ESP = 0x1020` _"prima della chiamata"_, il diagramma metteva EBP a 0x1014 e la variabile locale a
  0x1010: mancavano **4 byte** (l'indirizzo di ritorno di `call` va contato tra parametri e push ebp).

**Correzione**
- Punto di partenza portato a `ESP = 0x1024` e diagramma completo e coerente:
  `0x1010 → var locale (EBP-4)`, `0x1014 → EBP salvato`, `0x1018 → indirizzo di ritorno`,
  `0x101C → parametro a=3`, `0x1020 → parametro b=7`, `0x1024 → frame chiamante`.
  Aggiunto suggerimento esplicito sul conteggio (8 + 4 + 4 byte).

</details>

<details>
<summary><b>8. Chiave verifica_1 Q13 — ordine micro-operazioni PUSH</b></summary>

**File:** `teoria/test/README.md`

**Problema**
- La chiave indicava l'ordine "3, 4, 1, 2", etichettando in modo errato le opzioni e **contraddicendo
  la propria nota** che stabilisce l'ordine corretto (Dec ESP → Invio EAX → MEM_WRITE → Inc EIP).

**Correzione**
- Chiave allineata alla nota: **3** (Sottrazione ESP), **1** (Invio EAX), **4** (Segnale scrittura),
  **2** (Incremento EIP).

</details>

<details>
<summary><b>9. Tipografia e piccole imprecisioni nella teoria</b></summary>

**File**
- `teoria/lezione02_registri.md` — "quals è" → **"qual è"** (esercizio 1).
- `teoria/lezione05b_pratica_stack.md` — `shr eax, 1` → **`sar eax, 1`** per la divisione per 2 della
  media (coerente con `esercizio07/media.asm`, che già usava `sar`); aggiunta nota esplicativa.
- `teoria/test/test03_memoria.md` — "litte-endian" → **"little-endian"** (Q12).

</details>

<details>
<summary><b>10. Sito web (site/) — contenuti rotti e obsoleti</b></summary>

**File**
- `site/index.html`
- `site/js/main.js`
- `site/js/content.js` (rigenerato)

**Problema**
- Fence di codice rotti nei contenuti pratica: "`\u0007sm" e "`\batch" al posto di ``` `` ```asm ``` ``
  e ``` `` ```batch ``` `` → i blocchi non venivano renderizzati (5 occorrenze asm + 5 batch).
- Card "Laboratorio" pagina Dashboard chiamava `loadContent('pratica_es_somma')` (chiave inesistente)
  → il click non faceva nulla.
- Contenuti vecchi: mancavano `lezione05b`, `lezione07`, `approfondimento_applicazioni_bit`,
  tutti i `test`, gli esercizi 06-09 e il template; la "Guida Generale" era una copia obsoleta del README.

**Correzione**
- `content.js` **rigenerato automaticamente** dai sorgenti reali (README.md, tutte le lezioni/i test,
  e i file reali di ogni esercizio: `compila.bat`, `.asm`, `Program.cs`, `SCHEDA_ESERCIZIO.md`).
  Con questo approccio il sito non può più "desincronizzarsi" dal codice del corso.
  Validata con Node.js: 20 voci in "teoria", 10 in "pratica", senza caratteri di controllo residui.
- **Esclusi** dal sito (riservati al docente): `teoria/test/README.md` (chiavi) e
  `teoria/test/SOLUZIONI_verifica_01_06.md`.
- `index.html` → card Laboratorio agganciata a `pratica_esercizio01_somma`.
- `main.js` → "Guida Generale" non viene duplicata nel menu Teoria (evita id `nav-overview` doppi).

</details>

<details>
<summary><b>11. README del corso e coerenza documentale</b></summary>

**File:** `README.md`

**Correzione**
- Albero della struttura aggiornato (cartella `Assembly_c#/`, file `.md` mancanti, `ContaCarattere`
  al posto di `ContaOccorrenze`, nota sul runner 1-5).
- Sezione "Novità: Template di Progetto": export **senza underscore** + copia in `bin\Debug\net8.0-windows\`.
- Nuova sezione **"Punti chiave della pipeline"**: x86 (`PlatformTarget`), link senza `_` + `/NOENTRY`,
  dove P/Invoke cerca davvero la DLL.
- Tabella lezioni/esercizi: riga #6 estesa a Conta Carattere (es. 4-6).

</details>

---

## `# Risultati della verifica end-to-end`

| Verifica | Esito |
|---|---|
| `ml /c /coff` su tutti i 9 sorgenti (incluso `bitwise.asm`, prima falliva) | ✅ |
| `link /DLL /NOENTRY /EXPORT:...` su tutti (niente LNK2001 con `/EXPORT:_`) | ✅ |
| `dumpbin /EXPORTS` → nomi esportati coincidono con i `[DllImport]` C# | ✅ |
| `dotnet run` `csharp_runner` (es. 1-5) | ✅ tutti i test |
| `dotnet run` esercizi 06, 07, 08, 09 | ✅ tutti i test |
| `dotnet run` template_progetto | ✅ (`MiaFunzione` = 30) |
| `site/js/content.js` parse Node.js (20+10 chiavi, nessun residuo `\u0007`) | ✅ |

## ⚠️ Note operative
- `.bat` riscritti salvati con terminazioni `CRLF` (richieste da cmd.exe).
- File binari rigenerati (`.obj`, `.dll`, `.exp`, `.lib`) sostituiti con le versioni valide.
- Suggerimento (non applicato, decisione didattico-gestionale): aggiungere un **`.gitignore`** per
  `bin/` e `obj/` per evitare che gli artefatti di build finiscano nel repository.