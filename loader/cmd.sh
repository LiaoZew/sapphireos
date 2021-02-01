#!/bin/zsh

nasm -f bin -O0 -o 1.bin loader.s
dd if=./1.bin of=../obj/sapphireos.img seek=1 conv=notrunc
