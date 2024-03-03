import argparse

def generateasm(instr: str, repct: int, outfile: str):
    repct = 2_000
    outfile = "tests/" + outfile

    testasm = ("\t" + instr + "\n") * repct
    
    # boilerplate test script
    outtxt = f"""
    \t.arch	armv8-a
    \t.text
    \t.align	8
    \t.global	main
    \t.type	main, %function
    main:
    .LOOP_START:
    \t.cfi_startproc
    {testasm}
    \tb.al\t.LOOP_START
    \t.cfi_endproc
    .LOOP_END:
    \t.size main, .-main
    \t.ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04.2) 9.4.0"
    \t.section	.note.GNU-stack,"",@progbits
    """

    with open(outfile, 'w') as f:
        f.write(outtxt)

    print(f"Generated Test File for {instr}, repeated {repct}, to file {outfile}")

def main():
    # driver
    parser = argparse.ArgumentParser(description="""
    ARM ASM Test generator.
    Python metaprogramming utility for making infinite largely unrolled single instruction loops for benchmarking a system's energy per instruction.
    """)

    parser.add_argument('-o', '--output', type=str, help='output file to write to', required = True)
    parser.add_argument('-a', '--asm', type=str, help='assembly mnemonic and operands', required = True)
    parser.add_argument('-c', '--repcount', type=int, help='number of times instruction is repeated. for memory instructions, suggested to be power of 2', required = False, default = 2000)

    args = parser.parse_args()
    
    generateasm(
        instr = args.asm,
        repct = args.repcount,
        outfile = args.output
    )

if __name__ == "__main__":
    main()
