[org 0x7c00]

start:
mov ah,0x0
mov al,0x03
int 0x10
xor si,si
print_boot:
mov ah,0x0E
mov al,[boot_message+si]
int 0x10
inc si
cmp byte [boot_message+si],0
jne print_boot
; Set up segments
xor ax, ax
mov ds, ax
mov es, ax
mov ss, ax
mov sp, 0x7c00  ; Set stack pointer

; Load kernel into memory
mov ah, 0x02  ; BIOS read function
mov al, 4     ; Number of sectors to read
mov ch, 0     ; Cylinder number
mov dh, 0     ; Head number
mov cl, 2     ; Sector number
mov bx, 0x8000  ; Load kernel at 0x8000
int 0x13      ; BIOS interrupt

    ; Jump to kernel
jmp 0x8000
boot_message db "booting...",0xa,0x0D,0
times 510-($-$$) db 0  ; Fill the rest of the boot sector with zeros
dw 0xaa55              ; Boot signature

