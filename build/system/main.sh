#!/bin/bash

echo "Starting compilation..."

nasm -f elf64 -o $OUT/obj/main.o $TOP/main.asm
ld -o $OUT/bin/main $OUT/obj/main.o

echo "Compilation completed."
