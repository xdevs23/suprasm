#!/bin/bash

export TOP="$(pwd)"
export OUT="$TOP/out"

mkdir -p $OUT/bin
mkdir -p $OUT/obj
mkdir -p $OUT/lib

source build/system/main.sh
