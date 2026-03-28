using System.Runtime.InteropServices;

// --- CONFIGURAZIONE DLL ---
// Assicurati che il nome della DLL coincida con quello generato dal tuo .asm
const string DllName = "funzione.dll";

Console.WriteLine("╔══════════════════════════════════════════════════════════╗");
Console.WriteLine("║                 Assembly Function Tester                 ║");
Console.WriteLine("╚══════════════════════════════════════════════════════════╝\n");

// --- DICHIARAZIONE FUNZIONE ---
// Importiamo la funzione definita in Assembly. 
// Ricorda: in Assembly la funzione deve essere esportata (es. EXPORT:_MiaFunzione)
[DllImport(DllName, CallingConvention = CallingConvention.Cdecl)]
static extern int MiaFunzione(int a, int b);

try
{
    // --- TEST 1: Valori semplici ---
    int val1 = 10;
    int val2 = 20;
    
    Console.WriteLine($"[TEST] Chiamata a MiaFunzione({val1}, {val2})...");
    int risultato = MiaFunzione(val1, val2);
    
    Console.WriteLine($"[RISULTATO] Assembly dice: {risultato}");
    Console.WriteLine($"[VERIFICA] C# si aspetta: {val1 + val2}");
    
    if (risultato == (val1 + val2))
        Console.WriteLine("✅ TEST SUPERATO!");
    else
        Console.WriteLine("❌ TEST FALLITO.");

}
catch (DllNotFoundException)
{
    Console.WriteLine($"ERROR: Impossibile trovare '{DllName}'.");
    Console.WriteLine("Assicurati di aver eseguito 'compila.bat' e che la DLL sia nella cartella dell'eseguibile.");
}
catch (Exception ex)
{
    Console.WriteLine($"ERRORE INATTESO: {ex.Message}");
}

Console.WriteLine("\nPremi un tasto per uscire...");
Console.ReadKey();
