# 隐含规则
.SUFFIXES: .s 
.PHONY:clean

#宏定义
INCPATH=obj/

mbr:mbr/*.s
	@nasm -f elf64 -g -F dwarf -l $(INCPATH)$@.lst -O0 -o $(INCPATH)$@.o $^
	@ld $(INCPATH)$@.o -o $(INCPATH)$@
	@echo $@ make success.
	@$(INCPATH)$@

#清理文件
clean:
	@rm -rf $(INCPATH)*.o $(INCPATH)*.lst
