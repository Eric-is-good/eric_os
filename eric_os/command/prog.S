	.file	"prog.c"
	.text
	.globl	han
	.type	han, @function
han:
.LFB0:
	.cfi_startproc
	pushl	%edi
	.cfi_def_cfa_offset 8
	.cfi_offset 7, -8
	pushl	%esi
	.cfi_def_cfa_offset 12
	.cfi_offset 6, -12
	pushl	%ebx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movl	16(%esp), %eax
	movl	20(%esp), %edi
	movl	24(%esp), %esi
	cmpl	$1, %eax
	jne	.L2
	subl	$12, %esp
	.cfi_def_cfa_offset 28
	pushl	%edi
	.cfi_def_cfa_offset 32
	call	putch
	movl	%esi, (%esp)
	call	putch
	movl	$10, (%esp)
	call	putch
	addl	$16, %esp
	.cfi_def_cfa_offset 16
.L1:
	popl	%ebx
	.cfi_remember_state
	.cfi_restore 3
	.cfi_def_cfa_offset 12
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 8
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 4
	ret
.L2:
	.cfi_restore_state
	leal	-1(%eax), %ebx
	pushl	%esi
	.cfi_def_cfa_offset 20
	pushl	32(%esp)
	.cfi_def_cfa_offset 24
	pushl	%edi
	.cfi_def_cfa_offset 28
	pushl	%ebx
	.cfi_def_cfa_offset 32
	call	han
	movl	%edi, (%esp)
	call	putch
	movl	%esi, (%esp)
	call	putch
	movl	$10, (%esp)
	call	putch
	pushl	%edi
	.cfi_def_cfa_offset 36
	pushl	%esi
	.cfi_def_cfa_offset 40
	pushl	52(%esp)
	.cfi_def_cfa_offset 44
	pushl	%ebx
	.cfi_def_cfa_offset 48
	call	han
	addl	$32, %esp
	.cfi_def_cfa_offset 16
	jmp	.L1
	.cfi_endproc
.LFE0:
	.size	han, .-han
	.globl	main
	.type	main, @function
main:
.LFB1:
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
	subl	$4, %esp
	call	getint
	pushl	$67
	pushl	$66
	pushl	$65
	pushl	%eax
	call	han
	addl	$16, %esp
	movl	$0, %eax
	movl	-4(%ebp), %ecx
	.cfi_def_cfa 1, 0
	leave
	.cfi_restore 5
	leal	-4(%ecx), %esp
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE1:
	.size	main, .-main
	.ident	"GCC: (GNU) 7.1.0"
