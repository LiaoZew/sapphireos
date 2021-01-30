# 隐含规则
.SUFFIXES: .s 
.PHONY:clean

#宏定义
OBJPATH=obj/
IMG=mbr.bin
SUBDIRS= mbr qemu

all:$(SUBDIRS)

#编译
mbr:mbr/*.s
	@nasm -i include $()-f bin -g -l $(OBJPATH)$@.lst\
	 -O0 -o $(OBJPATH)$@.bin $^
	@echo $@ make success.

#虚拟机
qemu:
	qemu-system-x86_64 -drive file=$(OBJPATH)$(IMG)\
	,format=raw -monitor stdio

#清理文件
clean:
	@rm -rf $(OBJPATH)*.o $(OBJPATH)*.lst $(OBJPATH)*.bin
