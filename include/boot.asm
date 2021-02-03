;
;	loader addr
;

loader_base_addr equ 0x800

;
;	mamory map
;
ADRS equ 0x500
ADRS_count equ 0x400	;bios data area


;
;  define about gdt
;

; %1 = base
; %2 = limit
; %3 = attr
%macro descriptor 3
	dw (%2&0xffff)
	dw (%1&0xffff)
	db ((%1>>16)&0xff)
	dw (%2 & 0x0f00) | (%3 & 0xf0ff)
	db ((%1>>24)&0xff)
%endmacro

;gdt attribute
da_default equ da_limit_4k | da_32 | da_inmem \
	| da_dpl0 | da_user
da_default2 equ da_32 | da_inmem \
	| da_dpl0 | da_user
da_limit_4k equ 1<<15	;1 or 4kb
da_32 equ 1<<14	;16bits or 32 bits opration
da_long equ 1<<13 ; use 64bits code
da_avl equ 1<<12 ; i not know how to use
da_inmem equ 1<<7
da_dpl0 equ 0<<5
da_dpl1 equ 1<<5
da_dpl2 equ 2<<5
da_dpl3 equ 3<<5
da_user equ 1<<4	;0 system segment
da_r equ 0<<1	;only read
da_wr equ 1<<1	;write and read
da_er equ 2<<1 ;only read and extend down
da_ewr equ 3<<1 ;write and read and extend down
da_x equ 4<<1	;only exec
da_xr equ 5<<1	;exec and read
da_xc equ 6<<1 ;only exec and confirm
	;what is confirm(low dpl can use high dpl segment)
da_xcr equ 7<<1 ;exec and read and confirm

;selector attribute
sa_default equ sa_rpl0 | sa_tig
sa_rpl0 equ 0
sa_rpl1 equ 1
sa_rpl2 equ 2
sa_rpl3 equ 3
sa_tig equ 0<<2 ;use gdt
sa_til equ 1<<2 ;use ldt