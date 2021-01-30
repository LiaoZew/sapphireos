%include "boot.inc"
SECTION .mbr vstart=0x7c00
    jmp $
    mov ax,cs
	mov ds,ax
    mov es,ax
	mov ss,ax
    mov sp,sp_base_addr
	mov ax,page_base_addr
	mov gs,ax

    ;清屏
    mov ax,0x0600
    mov bx,0x0700
    mov cx,0
    mov dx,0x184f
    int 0x10

    mov cx, 0x0
    mov al,fontfmt
prfmbr:		;打印字符串
    mov di, cx
    mov dl,[di + string]
    sub dl,0
    jz prfmbrend
    add di,di
    mov byte [gs:di],dl
    add di,1
    mov byte [gs:di],al
    add cx,1
    jmp prfmbr
prfmbrend:

	call rdisk
	jmp loader_base_addr

rdisk:		;读取硬盘加载器
	mov dx,loader_base_reg
	mov al,loader_sector_cnt
	out dx,al

	mov eax,loader_start_sector
	mov cx,3
rdisklp:
	inc dx
	out dx,al
	shr eax,8
	loop rdisklp

	and al,0x0f
	or al,0xe0
	inc dx
	out dx,al
	inc dx
	mov al,0x20
	out dx,al

nrdy:		;等待磁盘准备好数据
	nop
	in al,dx
	and al,0x88
	cmp al,0x08
	jnz nrdy

	mov ax,loader_sector_cnt
	mov dx,256
	mul dx
	mov cx,ax
	mov dx,loader_base_reg-2

	mov bx,loader_base_addr
go_on_read:
	in ax,dx
	mov [bx],ax
	add bx,2
	loop go_on_read

	ret

	string db "1 MBR: hello,zev!", 0
    times 510-($-$$) db 0
    db 0x55,0xaa
