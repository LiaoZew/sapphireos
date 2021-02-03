%include "boot.asm"
[bits 16]
	org loader_base_addr
	loader_size dw (loader_end_addr-loader_base_addr)
	jmp start


start:
	lgdt [gdtdisc]	;load gdt
	cli	;disable interrupt (or clear)
	in al,0x92	;trun on a20
	or al,0x02
	out 0x92,al
	mov eax,cr0	;sift to preodect mode
	or eax,1
	mov cr0,eax
	jmp dword selec_code_r0:start32	;clear pipe-line and jump

[bits 32]
start32:
	;test bios int can use. vuetify protect mode
	;mov al,0x0a
	;call set_fontcolor
	;mov si,msg2
	;call tmp_print16
	mov dl,0x0a
	mov cx,4 ;line num
	call tmp_print32
	jmp $

tmp_print32:
	push ds
	push es
	push esi
	push edi
	mov eax,selec_video_r0
	mov es,eax
	mov eax,selec_data_r0
	mov ds,eax
	mov eax,0xa0
	mul cl
	mov edi,eax
	mov esi,msg2
	mov ah,dl
.c:
	lodsb
	or al,al
	jz .d
	stosw
	jmp .c
.d:
	pop edi
	pop esi
	pop es
	pop ds
	ret

[bits 16]
gdt:
	descriptor 0,0,0	;null
	descriptor 0,0xffffff,da_default | da_x ;code 0-4G
	descriptor 0,0xffffff,da_default | da_wr ;data 0-4G
	descriptor 0xb8000,0x7fff,da_default2 | da_wr ;video 8*4K
gdtdisc:
	dw (gdtdisc-gdt-1)
	dd gdt
;gdt selector
selec_code_r0 equ (0x0001<<3) | sa_default
selec_data_r0 equ (0x0002<<3) | sa_default
selec_video_r0 equ (0x0003<<3) | sa_default



data:
	msg2 db "2 loader in protect",0x00	;
	msg3 db 0
loader_end_addr: