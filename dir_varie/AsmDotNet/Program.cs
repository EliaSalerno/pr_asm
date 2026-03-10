using System;
using System.Runtime.InteropServices;

class Program
{
	[DllImport("AsmFunctions.dll",CallingConvention = CallingConvention.StdCall)]
	public static extern int AddNumbers(int a, int b);

	static void Main()
	{
		Console.WriteLine(AddNumbers(5, 7));
	}
}