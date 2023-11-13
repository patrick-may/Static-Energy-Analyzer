	.arch armv8-a
	.file	"switch.c"
	.text
	.align	2
	.global	main
	.type	main, %function
main:
.LFB0:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	mov	w0, 2
	str	w0, [sp, 12]
	ldr	w0, [sp, 12]
	cmp	w0, 2
	beq	.L8
	ldr	w0, [sp, 12]
	cmp	w0, 2
	bgt	.L3
	ldr	w0, [sp, 12]
	cmp	w0, 0
	beq	.L9
	ldr	w0, [sp, 12]
	cmp	w0, 1
	beq	.L10
.L3:
	mov	w0, -1
	b	.L7
.L8:
	nop
	b	.L6
.L9:
	nop
	b	.L6
.L10:
	nop
.L6:
	mov	w0, 0
.L7:
	add	sp, sp, 16
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04.2) 9.4.0"
	.section	.note.GNU-stack,"",@progbits
