using System.Runtime.InteropServices;
using System.Drawing; // Nota: richiede il riferimento a System.Drawing.Common se net8.0-windows

const string DllName = "colori.dll";

[DllImport(DllName, CallingConvention = CallingConvention.Cdecl)]
static extern uint CreaColore(int r, int g, int b);

[DllImport(DllName, CallingConvention = CallingConvention.Cdecl)]
static extern int EstraiVerde(uint colore);

Console.WriteLine("╔══════════════════════════════════════════════════════════╗");
Console.WriteLine("║        Esercizio 09: Manipolazione Colori (RGB)          ║");
Console.WriteLine("╚══════════════════════════════════════════════════════════╝\n");

try
{
    // TEST 1: Creazione colore
    int r = 255, g = 128, b = 64;
    uint coloreRisultante = CreaColore(r, g, b);
    
    Console.WriteLine($"[CREAZIONE] Input: R={r}, G={g}, B={b}");
    Console.WriteLine($"[RISULTATO] Hex: 0x{coloreRisultante:X6}");
    Console.WriteLine($"[BINARIO]   {Convert.ToString(coloreRisultante, 2).PadLeft(24, '0')}");
    Console.WriteLine();

    // TEST 2: Estrazione componente
    uint coloreTest = 0xFF3366; // Rosso=FF, Verde=33, Blu=66
    int verdeEstratto = EstraiVerde(coloreTest);
    
    Console.WriteLine($"[ESTRAZIONE] Analisi colore: 0x{coloreTest:X6}");
    Console.WriteLine($"[RISULTATO]  Verde estratto: 0x{verdeEstratto:X2} ({verdeEstratto})");
    Console.WriteLine($"[VERIFICA]   {(verdeEstratto == 0x33 ? "✅ CORRETTO" : "❌ ERRORE")}");

}
catch (Exception ex)
{
    Console.WriteLine($"ERRORE: {ex.Message}");
}

Console.WriteLine("\nPremi un tasto per uscire...");
Console.ReadKey();
