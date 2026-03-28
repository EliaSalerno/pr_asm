using System.Runtime.InteropServices;
using System.Linq;

// Imposta la codifica della console su UTF-8 per visualizzare correttamente i simboli dei bordi (box-drawing)
Console.OutputEncoding = System.Text.Encoding.UTF8;

Console.WriteLine("╔══════════════════════════════════════════════════════════╗");
Console.WriteLine("║        Assembly Runner — Funzioni in Assembly x86        ║");
Console.WriteLine("╚══════════════════════════════════════════════════════════╝");
Console.WriteLine();

// =============================================================================
// ESERCIZIO 1 — Somma di due interi
// =============================================================================
// [DllImport] carica la DLL esterna. 
// CallingConvention.Cdecl: lo stack viene pulito dal chiamante (C#), tipico dei linguaggi C/C++.
[DllImport("somma.dll", CallingConvention = CallingConvention.Cdecl)]
static extern int Somma(int a, int b);

Console.WriteLine("─── Esercizio 1: Somma ──────────────────────────────────────");
Console.WriteLine("    Chiamo la funzione Assembly: int Somma(int a, int b)");

try
{
    int a = 15, b = 27;
    // Chiamata alla funzione residente nella DLL Assembly
    int risultato = Somma(a, b);
    Console.WriteLine($"    Somma({a}, {b}) = {risultato}");
    Console.WriteLine($"    Verifica C#:     {a + b}  → {(risultato == a + b ? "✅ CORRETTO" : "❌ ERRORE")}");
}
catch (DllNotFoundException)
{
    Console.WriteLine("    ⚠️  somma.dll non trovata! Esegui prima compila.bat nell'esercizio 1.");
}
Console.WriteLine();


// =============================================================================
// ESERCIZIO 2 — Massimo tra due interi
// =============================================================================
[DllImport("massimo.dll", CallingConvention = CallingConvention.Cdecl)]
static extern int Massimo(int a, int b);

Console.WriteLine("─── Esercizio 2: Massimo ────────────────────────────────────");
Console.WriteLine("    Chiamo la funzione Assembly: int Massimo(int a, int b)");

try
{
    var coppie = new (int, int)[] { (10, 20), (99, 3), (7, 7), (-5, -1) };
    foreach (var (x, y) in coppie)
    {
        int ris = Massimo(x, y);
        int atteso = Math.Max(x, y);
        Console.WriteLine($"    Massimo({x,3}, {y,3}) = {ris,3}  {(ris == atteso ? "✅" : "❌")}");
    }
}
catch (DllNotFoundException)
{
    Console.WriteLine("    ⚠️  massimo.dll non trovata! Esegui prima compila.bat nell'esercizio 2.");
}
Console.WriteLine();


// =============================================================================
// ESERCIZIO 3 — Fattoriale
// =============================================================================
[DllImport("fattoriale.dll", CallingConvention = CallingConvention.Cdecl)]
static extern int Fattoriale(int n);

Console.WriteLine("─── Esercizio 3: Fattoriale ─────────────────────────────────");
Console.WriteLine("    Chiamo la funzione Assembly: int Fattoriale(int n)");

try
{
    for (int n = 0; n <= 10; n++)
    {
        int ris = Fattoriale(n);
        long atteso = CalcolaFattoriale(n);
        Console.WriteLine($"    {n,2}! = {ris,7}  {(ris == atteso ? "✅" : "❌")}");
    }
}
catch (DllNotFoundException)
{
    Console.WriteLine("    ⚠️  fattoriale.dll non trovata! Esegui prima compila.bat nell'esercizio 3.");
}
Console.WriteLine();

// Funzione helper locale per il test del fattoriale
static long CalcolaFattoriale(int n)
{
    long r = 1;
    for (int i = 2; i <= n; i++) r *= i;
    return r;
}


// =============================================================================
// ESERCIZIO 4 — Somma di un array
// =============================================================================
// Le DLL native non sanno cosa sia un oggetto 'int[]' di C#. Dobbiamo passare 
// l'indirizzo della memoria dell'array (puntatore). 
[DllImport("somma_array.dll", CallingConvention = CallingConvention.Cdecl)]
static extern int SommaArray(IntPtr array, int lunghezza);

Console.WriteLine("─── Esercizio 4: Somma Array ────────────────────────────────");
Console.WriteLine("    Chiamo la funzione Assembly: int SommaArray(int* array, int lunghezza)");

try
{
    int[] numeri = { 10, 20, 30, 40, 50 };
    int sommaAttesa = numeri.Sum();

    // Il blocco 'unsafe' ci permette di usare i puntatori (*) in C#
    unsafe
    {
        // 'fixed' impedisce al Garbage Collector (GC) di spostare l'array in memoria 
        // mentre la funzione Assembly lo sta leggendo.
        fixed (int* ptr = numeri)
        {
            // Passiamo l'indirizzo fisico castato a IntPtr
            int ris = SommaArray((IntPtr)ptr, numeri.Length);
            Console.WriteLine($"    Array: [{string.Join(", ", numeri)}]");
            Console.WriteLine($"    Somma Assembly: {ris}  {(ris == sommaAttesa ? "✅" : "❌")}");
        }
    }
}
catch (DllNotFoundException)
{
    Console.WriteLine("    ⚠️  somma_array.dll non trovata! Esegui prima compila.bat nell'esercizio 4.");
}
Console.WriteLine();


// =============================================================================
// ESERCIZIO 5 — Lunghezza stringa
// =============================================================================
// Le stringhe in C# sono UTF-16 (2 byte per carattere). In Assembly usiamo 
// ASCII (1 byte). CharSet.Ansi converte automaticamente la stringa C# in byte.
[DllImport("lunghezza_stringa.dll", CallingConvention = CallingConvention.Cdecl,
           CharSet = CharSet.Ansi)]
static extern int LunghezzaStringa(string s);

Console.WriteLine("─── Esercizio 5: Lunghezza Stringa ──────────────────────────");
Console.WriteLine("    Chiamo la funzione Assembly: int LunghezzaStringa(char* s)");

try
{
    string[] parole = { "ciao", "Assembly", "informatica", "", "x" };
    foreach (var parola in parole)
    {
        int ris = LunghezzaStringa(parola);
        int atteso = parola.Length;
        Console.WriteLine($"    LunghezzaStringa(\"{parola}\") = {ris}  {(ris == atteso ? "✅" : "❌")}");
    }
}
catch (DllNotFoundException)
{
    Console.WriteLine("    ⚠️  lunghezza_stringa.dll non trovata! Esegui prima compila.bat nell'esercizio 5.");
}

Console.WriteLine();
Console.WriteLine("══════════════════════════════════════════════════════════════");
Console.WriteLine("  Premi INVIO per uscire...");
Console.ReadLine();
