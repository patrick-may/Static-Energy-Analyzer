	.arch armv8-a
	.file	"struct.c"
	.text
	.align	2
	.global	main
	.type	main, %function
main:
.LFB0:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	mov	w0, 1
	str	w0, [sp, 12]
	mov	w0, 1
	str	w0, [sp, 16]
	mov	w0, 1
	str	w0, [sp, 20]
	mov	w0, 1
	str	w0, [sp, 24]
	mov	w0, 1
	str	w0, [sp, 28]
	mov	w0, 1
	str	w0, [sp, 32]
	mov	w0, 1
	str	w0, [sp, 36]
	mov	w0, 1
	str	w0, [sp, 40]
	mov	w0, 4
	str	w0, [sp, 8]
	mov	w0, 0
	add	sp, sp, 48
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04.2) 9.4.0"
	.section	.note.GNU-stack,"",@progbits
