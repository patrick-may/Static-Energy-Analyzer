    .arch armv8-a
    .file	"inlinefor.c"
    .text
    .align	2
    .global	main
    .type	main, %function
main:
.LFB0:
    .cfi_startproc
    sub	sp, sp, #16
    .cfi_def_cfa_offset 16
    mov	w0, 1
    str	w0, [sp, 4]
    str	xzr, [sp, 8]
    b	.L2
.L3:
    ldr	w0, [sp, 4]
    lsl	w0, w0, 1
    str	w0, [sp, 4]
    ldr	x0, [sp, 8]
    add	x0, x0, 1
    str	x0, [sp, 8]
.L2:
    ldr	x0, [sp, 8]
    cmp	x0, 19
    bls	.L3
    mov	w0, 0
    add	sp, sp, 16
    .cfi_def_cfa_offset 0
    ret
    .cfi_endproc
.LFE0:
    .size	main, .-main
    .ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04.2) 9.4.0"
    .section	.note.GNU-stack,"",@progbits
