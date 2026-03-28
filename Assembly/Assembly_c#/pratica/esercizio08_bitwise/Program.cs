using System.Runtime.InteropServices;

const string DllName = "bitwise.dll";

[DllImport(DllName, CallingConvention = CallingConvention.Cdecl)]
static extern uint InvertiBit(uint val);

[DllImport(DllName, CallingConvention = CallingConvention.Cdecl)]
static extern int IsolaBit(uint val, int posizione);

Console.WriteLine("╔══════════════════════════════════════════════════════════╗");
Console.WriteLine("║           Esercizio 08: Operazioni Bitwise               ║");
Console.WriteLine("╚══════════════════════════════════════════════════════════╝\n");

try
{
    // TEST 1: Inversione (NOT)
    uint num = 0x0000FFFF;
    uint inv = InvertiBit(num);
    Console.WriteLine($"[NOT] Valore originale: {Convert.ToString(num, 2).PadLeft(32, '0')}");
    Console.WriteLine($"[NOT] Valore invertito: {Convert.ToString(inv, 2).PadLeft(32, '0')}");
    Console.WriteLine();

    // TEST 2: Isolare un bit
    uint valore = 0b1010; // 10 in decimale (bit 1 e 3 accesi)
    Console.WriteLine($"[BIT] Analisi di {valore} (binario: {Convert.ToString(valore, 2)})");
    for (int i = 0; i < 4; i++)
    {
        int stato = IsolaBit(valore, i);
        Console.WriteLine($"      Bit {i}: {(stato == 1 ? "ACCESO (1)" : "SPENTO (0)")}");
    }
}
catch (Exception ex)
{
    Console.WriteLine($"ERRORE: {ex.Message}");
}

Console.WriteLine("\nPremi un tasto per uscire...");
Console.ReadKey();
