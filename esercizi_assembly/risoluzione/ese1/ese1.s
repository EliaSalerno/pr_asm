	.file	"ese1.c"
	.intel_syntax noprefix
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	push	ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	mov	ebp, esp
	.cfi_def_cfa_register 5
	sub	esp, 16
	mov	DWORD PTR [ebp-12], 0
	mov	DWORD PTR [ebp-8], 0
	mov	DWORD PTR [ebp-4], 0
	mov	DWORD PTR [ebp-12], 4
	mov	DWORD PTR [ebp-8], 5
	mov	edx, DWORD PTR [ebp-12]
	mov	eax, DWORD PTR [ebp-8]
	add	eax, edx
	mov	DWORD PTR [ebp-4], eax
	mov	eax, 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 5.4.0-6ubuntu1~16.04.12) 5.4.0 20160609"
	.section	.note.GNU-stack,"",@progbits
