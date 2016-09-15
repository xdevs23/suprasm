#!/bin/bash

LOCALDIR="$TOP/build/system"

echo "Reading product details..."
source $LOCALDIR/product.functions
source $TOP/product.details

if [ "$1" == "debug" ]; then
     echo -e "Starting debug...\n"
     $OUT/bin/$PRODUCT_OUT_FILENAME
     echo -e "\n\n-------------------\nDebug end"
     return $?
fi

echo "Starting compilation..."

nasm -f elf64 -o $OUT/obj/$PRODUCT_OUT_FILENAME.o $TOP/$PRODUCT_SRC_DIR/$PRODUCT_MAIN_SRC_FILE
ld -o $OUT/bin/$PRODUCT_OUT_FILENAME $OUT/obj/$PRODUCT_OUT_FILENAME.o

echo "Compilation completed."
