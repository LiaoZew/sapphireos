%include 'boot.asm'
[BITS 16]
	org 0x7c00
	jmp _start16

_start16:
	;init regs	
	mov ax,0
	mov ss,ax
	mov sp,0x7c00
	mov ds,ax
	mov es,ax
	;get video mode
	;mov ah,0x0f
	;int 0x10
	;set text mode
	;mov ah,0
	;mov al,3
	;int 0x10
	;set display page 0
	mov ah,5
	mov al,0
	int 0x10
	;clear screen
	call get_cursor
	mov ah,0x06	
	mov cx,0
	mov dx,0x184f
	int 0x10

	;print string
	mov dx,0
	call set_cursor
	mov al,0x0b
	call set_fontcolor
	mov si,msg
	call tmp_print16

	mov al,0x0a
	call set_fontcolor
	mov si,msg2
	call tmp_print16

	;get memory map
	call get_mem_map 
	mov al,0x0a
	call set_fontcolor
	mov si,msg4
	call tmp_print16

	;read hard disk	
	mov bx,loader_base_addr
	mov di,0
	mov si,1
	call read_disk16
	mov dx,[loader_base_addr]
	mov cx,dx
	shr cx,9
	and dx,0x1ff
	cmp dx,0
	jnz .f
	dec cx
.f:
	cmp cx,0
	jz .h
.g:
	call read_disk16
	loop .g
.h:
	jmp loader_base_addr+2

;al = background color
set_background:
	push bx
	mov bx,0
	mov bl,al
	mov ah,0x0b
	int 0x10
	pop bx
	ret
;al fontcolor
set_fontcolor:
	push bx
	push cx
	push dx
	mov bh,al
	call get_cursor
	mov ch,al
	mov dh,al
	mov cl,0
	mov dl,0x4f
	mov ax,0x600
	int 0x10
	pop dx
	pop cx
	pop bx
	ret
;input si:msg base addr
;BH = page number
;BL = foreground color (graphics modes only)
tmp_print16:
	push bx
	mov ah,0x0e
	mov bh,0x00
	;mov bl,0x83
	cld
.a:
	lodsb
	or al,al
	jz .b
	int 0x10
	loop .a
.b:	
	pop bx
	ret


set_cursor:
	push bx
	mov ah,0x02
	mov bh,0x00
	int 0x10
	pop bx
	ret
get_cursor:
	push bx
	push cx
	push dx
	mov ah,3
	mov bh,0
	int 0x10
	mov al,dh
	pop dx
	pop cx
	pop bx
	ret
;DS:BX= memory base addr
;DI:SI = sector start count
read_disk16:
	push cx
	push dx
	call waitdisk
	mov dx,0x1f2 ;
	mov al,1
	out dx,al
	inc dx ;
	mov ax,si
	out dx,al
	inc dx ;
	mov al,ah
	out dx,al
	inc dx ;
	mov ax,di
	out dx,al
	inc dx ;
	mov al,0xe0
	or al,ah
	out dx,al
	inc dx
	mov al,0x20
	out dx,al

	call waitdisk
	mov dx,0x1f0
	mov cx,256
.e:
	in ax,dx
	mov [bx],ax
	add bx,2
	loop .e
	;not consider si->di problem
	inc si
	pop dx
	pop cx
	ret


waitdisk:
	push dx
	mov dx,0x1f7
.c:
	in al,dx
	and al,0xc0
	cmp al,0x40
	jnz .c
	pop dx
	ret

get_mem_map:
	push bx
	push dx
	push es
	push di
	mov dword [ADRS_count],0
	xor ebx,ebx
	mov edx,0x534d4150
	mov ax,0
	mov es,ax
	mov di,ADRS
.i
	mov eax,0xe820
	mov ecx,20
	int 0x15
	jc .j
	add di,20
	inc dword [ADRS_count]
	cmp ebx,0
	jnz .i
	jmp .k
.j
	mov al,0x0c
	call set_fontcolor
	mov si,msg3
	call tmp_print16
	hlt
	jmp $
.k
	pop di
	pop es
	pop dx
	pop bx
	ret	

	msg db 'SAPPHIRE 0S',0x0d,0x0a,0x00
	msg2 db '1 mbr: hello,zev!',0x0d,0x0a,0x00
	msg3 db 'memory map error',0x0d,0x0a,0x00
	msg4 db 'mem read ok',0x0d,0x0a,0x00
	
	times 510-($-$$) db 0
	dw 0xaa55