using System.Runtime.InteropServices;

// --- CONFIGURAZIONE DLL ---
const string DllName = "conta.dll";

Console.WriteLine("╔══════════════════════════════════════════════════════════╗");
Console.WriteLine("║        Esercizio 06: Conta Occorrenze Carattere          ║");
Console.WriteLine("╚══════════════════════════════════════════════════════════╝\n");

// IMPORTANTE: CharSet.Ansi per convertire le stringhe .NET in stringhe C (1 byte per char)
[DllImport(DllName, CallingConvention = CallingConvention.Cdecl, CharSet = CharSet.Ansi)]
static extern int ContaCarattere(string s, char c);

try
{
    // Esempi di test
    var testCases = new (string testo, char cerca)[] {
        ("banana", 'a'),
        ("supercalifragilistichespiralidoso", 'i'),
        ("Asemblatore x86", 'A'),
        ("test", 'z'),
        ("", 'a')
    };

    foreach (var (testo, cerca) in testCases)
    {
        Console.WriteLine($"[TEST] Testo: \"{testo}\" | Cerco: '{cerca}'");
        
        int risultato = ContaCarattere(testo, cerca);
        
        // Verifica con C# LINQ
        int atteso = testo.Count(x => x == cerca);
        
        string status = (risultato == atteso) ? "✅ OK" : "❌ ERRORE";
        Console.WriteLine($"       Risultato: {risultato} | Atteso: {atteso} -> {status}\n");
    }
}
catch (DllNotFoundException)
{
    Console.WriteLine($"[ERRORE] Impossibile trovare '{DllName}'.");
    Console.WriteLine("Esegui 'compila.bat' prima di avviare il test.");
}
catch (Exception ex)
{
    Console.WriteLine($"[ERRORE INATTESO] {ex.Message}");
}

Console.WriteLine("\nPremi INVIO per uscire...");
Console.ReadLine();
