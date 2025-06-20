	.file	"file.c"
	.section	.rodata
.LC0:
	.string	"Metti sto numero: "
.LC1:
	.string	"%d"
.LC2:
	.string	"\nIl tuo fantastico array di numeri: "
.LC3:
	.string	"%d "
	.align 4
.LC4:
	.string	"\nIl tuo array invertito: "
	.text
	.globl	main
	.type	main, @function
main:
.LFB2:
	.cfi_startproc
	leal	4(%esp), %ecx
	.cfi_def_cfa 1, 0
	andl	$-16, %esp
	pushl	-4(%ecx)
	pushl	%ebp
	.cfi_escape 0x10,0x5,0x2,0x75,0
	movl	%esp, %ebp
	pushl	%ecx
	.cfi_escape 0xf,0x3,0x75,0x7c,0x6
	subl	$52, %esp
	movl	%gs:20, %eax
	movl	%eax, -12(%ebp)
	xorl	%eax, %eax
	movl	$0, -56(%ebp)
	jmp	.L2
.L3:
	subl	$12, %esp
	pushl	$.LC0
	call	printf
	addl	$16, %esp
	leal	-52(%ebp), %eax
	movl	-56(%ebp), %edx
	sall	$2, %edx
	addl	%edx, %eax
	subl	$8, %esp
	pushl	%eax
	pushl	$.LC1
	call	__isoc99_scanf
	addl	$16, %esp
	addl	$1, -56(%ebp)
.L2:
	cmpl	$9, -56(%ebp)
	jle	.L3
	subl	$12, %esp
	pushl	$.LC2
	call	printf
	addl	$16, %esp
	movl	$0, -56(%ebp)
	jmp	.L4
.L5:
	movl	-56(%ebp), %eax
	movl	-52(%ebp,%eax,4), %eax
	subl	$8, %esp
	pushl	%eax
	pushl	$.LC3
	call	printf
	addl	$16, %esp
	addl	$1, -56(%ebp)
.L4:
	cmpl	$9, -56(%ebp)
	jle	.L5
	subl	$12, %esp
	pushl	$.LC4
	call	printf
	addl	$16, %esp
	movl	$9, -56(%ebp)
	jmp	.L6
.L7:
	movl	-56(%ebp), %eax
	movl	-52(%ebp,%eax,4), %eax
	subl	$8, %esp
	pushl	%eax
	pushl	$.LC3
	call	printf
	addl	$16, %esp
	subl	$1, -56(%ebp)
.L6:
	cmpl	$0, -56(%ebp)
	jns	.L7
	movl	$0, %eax
	movl	-12(%ebp), %ecx
	xorl	%gs:20, %ecx
	je	.L9
	call	__stack_chk_fail
.L9:
	movl	-4(%ebp), %ecx
	.cfi_def_cfa 1, 0
	leave
	.cfi_restore 5
	leal	-4(%ecx), %esp
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE2:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 5.4.0-6ubuntu1~16.04.12) 5.4.0 20160609"
	.section	.note.GNU-stack,"",@progbits
