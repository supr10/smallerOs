; kernel.asm

KERNEL_OFFSET equ 0x8000

[org KERNEL_OFFSET]

;=================program================
xor si,si
print_sucess:;kernel reached sucessfully
mov ah,0x0E
mov al,[boot_sucess+si]
int 0x10
inc si
cmp byte [boot_sucess+si],0
jne print_sucess
xor ah,ah
int 0x16


logo:
mov ah,0x00
mov al,0x13
int 0X10
;write logo
mov ah,0x0c
mov cx,20
mov dx,cx
write_logo_x:
int 0x10
inc cx
cmp cx,40
jne write_logo_x
write_logo_y:
inc dx
mov cx,20
cmp dx,40
jne write_logo_x


xor ah,ah
int 0x16


start:
mov ah,0x0
mov al,0x3
int 0x10
xor si,si

log1:
mov ah,0x0E
mov al,[lgn+si]
int 0x10
inc si
cmp byte [lgn+si],0
jne log1

login:
mov ah,0x0
;first number
xor ah,ah
int 0x16
cmp byte al,'0'
jne login_failure
;second number
xor ah,ah
int 0x16
cmp byte al,'0'
jne login_failure
;third number
xor ah,ah
int 0x16
cmp byte al,'0'
jne login_failure
;fourth number
xor ah,ah
int 0x16
cmp byte al,'0'
jne login_failure
je login_sucess

login_failure:
xor si,si
.print:
mov ah,0x0e
mov al,[denied+si]
int 0x10
inc si
cmp byte [denied+si],0
jne .print
je login

login_sucess:
xor si,si
.print:
mov ah,0x0E
mov al,[granted+si]
int 0x10
inc si
cmp byte [granted+si],0
jne .print
je mainloop
;=========================================
;===============main loop=================
;=========================================

mainloop:
mov ah,0x0E
mov al,0xa
int 0x10
mov al,0x0D
int 0x10
mov al,'>'
int 0x10
xor ah,ah
xor al,al
int 0x16
cmp byte al,'w' ;write command
je write_mode
mov [50],byte al
jne unknown

write_mode:
mov ah,0
int 0x16
mov ah,0x0E
int 0x10
cmp byte al,0xa
je .down
cmp byte al,"!"
je mainloop
jne write_mode
.down:
mov ah,0x0E
mov al,0xa
int 0x10
mov al,0x0D
int 0x10
jmp write_mode


unknown:
xor si,si
mov ah,0x0E
.print:
mov al,[unk+si]
int 0x10
inc si
cmp byte [unk+si],0
jne .print
unknown2:
mov al,byte [50]
int 0x10
mov al,0xa
int 0x10
mov al,0x0d
int 0x10
jmp mainloop

jmp $
;===============data==================
boot_sucess db "sucess!",0xa,0x0d,0
lgn db "please enter pre-shared key:",0xa,0x0d,0
denied db "invalid key. Please try again:",0xa,0x0d,0
granted db "access granited. Welcome, user.",0xa,0x0d,0
unk db "unknown command: "
;=================end============
times 2048-($-$$) db 0  ; Fill the rest of the sector with zeros
