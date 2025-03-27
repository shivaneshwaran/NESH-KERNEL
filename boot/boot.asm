[BITS 32]  ; GRUB loads us directly into Protected Mode

section .multiboot
align 4
multiboot_header:
    dd 0x1BADB002   ; Multiboot magic number
    dd 0x0          ; Flags
    dd -(0x1BADB002 + 0x0) ; Checksum

section .text
global _start
extern kernel_entry  ; Declare kernel entry point

_start:
    cli                 ; Disable interrupts
    lgdt [gdt_descriptor] ; Load GDT

    ; Set segment registers
    mov eax, gdt_data
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, stack_top  ; Set stack pointer

    call kernel_entry  ; Correctly call kernel_entry

halt_loop:
    cli   ; Disable interrupts
    hlt   ; Halt CPU
    jmp halt_loop  ; Prevent reboot

section .data
gdt_start:
    dq 0x0000000000000000   ; Null descriptor
gdt_code:
    dq 0x00CF9A000000FFFF   ; Code segment descriptor
gdt_data:
    dq 0x00CF92000000FFFF   ; Data segment descriptor
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

section .bss
align 16
stack resb 4096
stack_top:
