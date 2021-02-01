# 隐含规则
.SUFFIXES: .s 
.PHONY:clean

#宏定义
OBJPATH=obj/
IMG=sapphireos.img
SUBDIRS= mbr qemu

all:$(SUBDIRS)

#编译
mbr:mbr/*.s
	@nasm -i include -f bin -g -l $(OBJPATH)$@.lst\
	 -O0 -o $(OBJPATH)$@.bin $^
	@echo $@ make success.
	@dd if=$(OBJPATH)$@.bin of=$(OBJPATH)$(IMG) \
	 conv=notrunc
	@echo $@ write img

loader:loader/*.s
	@nasm -i include -f bin -g -l $(OBJPATH)$@.lst\
	 -O0 -o $(OBJPATH)$@.bin $^
	@echo $@ make success.
	@dd if=$(OBJPATH)$@.bin of=$(OBJPATH)$(IMG) \
	 seek=100 conv=notrunc
	@echo $@ write img

#虚拟机
qemu:
	@qemu-system-x86_64 \
	-drive file=$(OBJPATH)$(IMG),format=raw \
	-monitor stdio

bochs:
	@bochs -f bochsrc	

#清理文件
clean:
	@rm -rf $(OBJPATH)*.o $(OBJPATH)*.lst $(OBJPATH)*.bin
