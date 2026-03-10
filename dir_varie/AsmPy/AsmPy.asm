.386
.model flat, stdcall
option casemap:none

PUBLIC somma

.code
somma PROC a:DWORD, b:DWORD
      mov eax, a
      add eax, b
      ret 8
somma ENDP
END