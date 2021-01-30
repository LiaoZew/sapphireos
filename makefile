
# 隐含规则
.SUFFIXES: .s 

hello:mbr/mbr.s
	nasm -f elf64 mbr/mbr.s
	ld hello.o -o hello
	./hello