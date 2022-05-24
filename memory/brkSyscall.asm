    ;; This is an program example to know how to create
    ;; memory frames with two syscalls
    ;; brk and sbrk
    section .data
    ;; my constatns
    
    SYS_exit equ 60
    EXIT_SUCCESS equ 0
    EXIT_FAILURE equ 1

    SYS_brk equ 12
    
    
    section .bss
    
    section .text
    global _start
_start:
    
last:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall
