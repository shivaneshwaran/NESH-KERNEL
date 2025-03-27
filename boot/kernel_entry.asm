[BITS 32]
global kernel_entry
extern kernel_main

section .text
kernel_entry:
    mov esp, stack_top  ; Set up stack
    call kernel_main    ; Jump to C kernel
    hlt

section .bss
align 16
stack resb 4096
stack_top:
