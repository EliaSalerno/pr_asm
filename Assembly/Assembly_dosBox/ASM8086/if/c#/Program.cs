using System;

int num=0;
Console.Write("Inserire un numero: ");
num=int.Parse(Console.ReadLine());
if (num>10)
 ﻿Console.WriteLine("Numero maggiore di 10!");
else if (num<10)
 Console.WriteLine("Numero minore di 10!");
else
 Console.WriteLine("Hai inserito il numero 10!");
