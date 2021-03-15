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

	;protected-mode init segment, and set stack segment,furture

	mov dl,0x0a
	mov cx,6 ;line num
	call tmp_print32

	call setup_page
	sgdt[gdtdisc]
	mov ebx,[gdtdisc+2]
	or dword [ebx+0x18+4],0xc0000000


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

setup_page:
	push ecx
	push ebx
	push eax
	mov ecx,4096
	mov esi,0
.clear_page_dir:
	mov byte [pdt_base_addr+esi],0
	inc esi
	loop .clear_page_dir
.create_pde:
	mov ebx,pdt_entry_addr
	mov eax,pdt_entry_addr | pt_default
	mov [pdt_base_addr+0],eax
	mov [pdt_base_addr+0xc00],eax
	mov eax,pdt_base_addr
	mov [pdt_base_addr+page_size-4],eax

	mov ecx,256
	mov esi,0
	mov eax,pt_default
.create_pte:
	mov [ebx+esi],eax
	add eax,page_size
	add esi,4
	loop .create_pte
	
	mov eax,pdt_base_addr | pt_default | page_size*2
	mov ebx,pdt_base_addr
	mov ecx,254
	mov esi,0xc00
.create_kernel_pde:
	add esi,4
	mov [ebx+esi],eax
	add eax,page_size
	loop .create_kernel_pde

	pop eax
	pop ebx
	pop	ecx
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