    ;; This is the main function to test our code

    ;; These are the functios
    extern alloc
    extern free

    
    section .data
    ;; Constants
    SYS_exit equ 60
    EXIT_SUCCESS equ 0
    EXIT_FAILURE equ 1


    section .bss

    section .text
    global _start
_start:
    
    
last:                           ; get out 
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall
    
