# hardwaretest

`asmtestgen.py` is a command line utility for generating large unrolled assembly loops of a single instruction. 
It is built with argparse, so a simple `$> python asmtestgen.py -h` will explain further use

`testrunner.sh` is a shell script that takes in a path to an assembly file and performs compilation and testing of the file

The `/tests` folder contains all assembly files used to test and produce energy-per-instruction values on the testbench.
