	.file	"ese2.c"
	.intel_syntax noprefix
	.section	.rodata
.LC0:
	.string	"Primo numero: "
.LC1:
	.string	"%d"
.LC2:
	.string	"Secondo numero: "
	.align 4
.LC3:
	.string	"rix per i valori invertiti %d %d"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	lea	ecx, [esp+4]
	.cfi_def_cfa 1, 0
	and	esp, -16
	push	DWORD PTR [ecx-4]
	push	ebp
	.cfi_escape 0x10,0x5,0x2,0x75,0
	mov	ebp, esp
	push	ecx
	.cfi_escape 0xf,0x3,0x75,0x7c,0x6
	sub	esp, 20
	mov	eax, DWORD PTR gs:20
	mov	DWORD PTR [ebp-12], eax
	xor	eax, eax
	mov	DWORD PTR [ebp-24], 0
	mov	DWORD PTR [ebp-20], 0
	mov	DWORD PTR [ebp-16], 0
	sub	esp, 12
	push	OFFSET FLAT:.LC0
	call	printf
	add	esp, 16
	sub	esp, 8
	lea	eax, [ebp-24]
	push	eax
	push	OFFSET FLAT:.LC1
	call	__isoc99_scanf
	add	esp, 16
	sub	esp, 12
	push	OFFSET FLAT:.LC2
	call	printf
	add	esp, 16
	sub	esp, 8
	lea	eax, [ebp-20]
	push	eax
	push	OFFSET FLAT:.LC1
	call	__isoc99_scanf
	add	esp, 16
	mov	edx, DWORD PTR [ebp-24]
	mov	eax, DWORD PTR [ebp-20]
	add	eax, edx
	mov	DWORD PTR [ebp-24], eax
	mov	edx, DWORD PTR [ebp-24]
	mov	eax, DWORD PTR [ebp-20]
	sub	edx, eax
	mov	eax, edx
	mov	DWORD PTR [ebp-20], eax
	mov	edx, DWORD PTR [ebp-24]
	mov	eax, DWORD PTR [ebp-20]
	sub	edx, eax
	mov	eax, edx
	mov	DWORD PTR [ebp-24], eax
	mov	edx, DWORD PTR [ebp-20]
	mov	eax, DWORD PTR [ebp-24]
	sub	esp, 4
	push	edx
	push	eax
	push	OFFSET FLAT:.LC3
	call	printf
	add	esp, 16
	mov	eax, 0
	mov	ecx, DWORD PTR [ebp-12]
	xor	ecx, DWORD PTR gs:20
	je	.L3
	call	__stack_chk_fail
.L3:
	mov	ecx, DWORD PTR [ebp-4]
	.cfi_def_cfa 1, 0
	leave
	.cfi_restore 5
	lea	esp, [ecx-4]
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 5.4.0-6ubuntu1~16.04.12) 5.4.0 20160609"
	.section	.note.GNU-stack,"",@progbits
