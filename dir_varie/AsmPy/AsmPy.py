import ctypes

dll=ctypes.CDLL('./AsmPy.dll')

dll.somma.argtypes=(ctypes.c_int,ctypes.c_int)
dll.somma.restype=ctypes.c_int
a=input("Inserire il primo valore da sommare: ")
a=int(a)
b=input("Inserire il secondo valore da sommare: ")
b=int(b)
print(dll.somma(a,b))
print("Somma effettuata con successo!")