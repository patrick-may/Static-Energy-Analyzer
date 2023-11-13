    .arch armv8-a
    .file	"jump.c"
    .text
    .section	.rodata
    .align	3
.LC0:
    .string	"X is true"
    .align	3
.LC1:
    .string	"X is false"
    .text
    .align	2
    .global	main
    .type	main, %function
main:
.LFB0:
    .cfi_startproc
    stp	x29, x30, [sp, -32]!
    .cfi_def_cfa_offset 32
    .cfi_offset 29, -32
    .cfi_offset 30, -24
    mov	x29, sp
    mov	w0, 1
    str	w0, [sp, 28]
    ldr	w0, [sp, 28]
    cmp	w0, 0
    beq	.L2
    adrp	x0, .LC0
    add	x0, x0, :lo12:.LC0
    bl	puts
    b	.L3
.L2:
    adrp	x0, .LC1
    add	x0, x0, :lo12:.LC1
    bl	puts
.L3:
    mov	w0, 0
    ldp	x29, x30, [sp], 32
    .cfi_restore 30
    .cfi_restore 29
    .cfi_def_cfa_offset 0
    ret
    .cfi_endproc
.LFE0:
    .size	main, .-main
    .ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04.2) 9.4.0"
    .section	.note.GNU-stack,"",@progbits
