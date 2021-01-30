
# 隐含规则
.SUFFIXES: .s 

hello:mbr/mbr.s
	@nasm -f elf64 -g -F dwarf -l obj/hello.lst -O0 -o obj/hello.o mbr/mbr.s 
	@ld obj/hello.o -o obj/hello
	@obj/hello


	