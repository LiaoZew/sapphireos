;stack top addr
sp_base_addr equ 0x7c00

;text display config
fontfmt equ 00001010b
page_base_addr equ 0xb800
row_offset equ 10	;(80*2)>>4=10

;loader config
loader_start_sector equ 0x1
loader_base_addr equ 0x500
loader_sector_cnt equ 1
loader_base_reg equ 0x1f2

;gdt config
desc_g_4k equ 1b
desc_d_32 equ 1b
desc_l equ 0b
desc_avl equ 0b
desc_limit_code2 equ 1111b
desc_limit_data2 equ desc_limit_code2
desc_limit_video2 equ 0000b
desc_p equ 1b
desc_dpl_0 equ 00b
desc_dpl_1 equ 01b
desc_dpl_2 equ 10b
desc_dpl_3 equ 11b
desc_s_sys equ 0b
desc_s_user equ 1b
desc_type_code equ 1000b
desc_type_data equ 0010b

desc_high_code equ desc_g_4k<<23 \
	| desc_d_32<<22 \
	| desc_l<<21 \
	| desc_avl<<20 \
	| desc_limit_code2<<16 \
	| desc_p<<15 \
	| desc_dpl_0<<13 \
	| desc_s_user<<12 \
	| desc_type_code<<8
desc_high_data equ desc_g_4k<<23 \
	| desc_d_32<<22 \
	| desc_l<<21 \
	| desc_avl<<20 \
	| desc_limit_data2<<16 \
	| desc_p<<15 \
	| desc_dpl_0<<13 \
	| desc_s_user<<12 \
	| desc_type_data<<8
desc_high_video equ desc_g_4k<<23 \
	| desc_d_32<<22 \
	| desc_l<<21 \
	| desc_avl<<20 \
	| desc_limit_video2<<16 \
	| desc_p<<15 \
	| desc_dpl_0<<13 \
	| desc_s_user<<12 \
	| desc_type_data<<8 

desc_low_code equ 0x0000ffff
desc_low_data equ 0x0000ffff
desc_low_video equ 0x80000007	;设定为文本显示器显存区域

;selector config
rpl_0 equ 00b
rpl_1 equ 01b
rpl_2 equ 10b
rpl_3 equ 11b
ti_gdt equ 0b
ti_ldt equ 1b
