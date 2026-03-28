using System.Runtime.InteropServices;

const string DllName = "media.dll";

[DllImport(DllName, CallingConvention = CallingConvention.Cdecl)]
static extern int CalcolaMedia(int a, int b);

Console.WriteLine("╔══════════════════════════════════════════════════════════╗");
Console.WriteLine("║        Esercizio 07: Analisi Variabili Locali             ║");
Console.WriteLine("╚══════════════════════════════════════════════════════════╝\n");

try
{
    int x = 100;
    int y = 50;
    
    Console.WriteLine($"[TEST] Chiamata a CalcolaMedia({x}, {y})...");
    int ris = CalcolaMedia(x, y);
    
    Console.WriteLine($"[RISULTATO] Media: {ris}");
    Console.WriteLine($"[VERIFICA] C# aspetta: {(x + y) / 2}");
    
    if (ris == (x + y) / 2)
        Console.WriteLine("\n✅ TEST SUPERATO!");
    else
        Console.WriteLine("\n❌ TEST FALLITO.");

    Console.WriteLine("\n--- CONSIGLIO PER LO STUDENTE ---");
    Console.WriteLine("Apri questo progetto in Visual Studio, metti un breakpoint");
    Console.WriteLine("in Assembly e osserva come [ebp-4] memorizza il valore.");
}
catch (Exception ex)
{
    Console.WriteLine($"ERRORE: {ex.Message}");
}

Console.WriteLine("\nPremi un tasto per uscire...");
Console.ReadKey();
