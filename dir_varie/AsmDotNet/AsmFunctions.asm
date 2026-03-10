.386
.model flat, stdcall
option casemap:none

PUBLIC AddNumbers

.code
AddNumbers PROC a:DWORD, b:DWORD
    mov eax, a
    add eax, b
    ret 8
AddNumbers ENDP
END