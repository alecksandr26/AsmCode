    ;; This is the main function to test our code

    ;; These are the functios
    extern alloc
    extern free

    
    section .data
    ;; Constants
    SYS_exit equ 60
    EXIT_SUCCESS equ 0
    EXIT_FAILURE equ 1

    SYS_write equ 1
    STDOUT equ 1

    NULL equ 0x0
    LF equ 0xa
    
    ;; my variables
    alloc_error_msg db "Error: trying to allocate memory", LF, NULL
    alloc_error_msg_len equ $ - alloc_error_msg


    section .bss

    section .text
    global _start
_start:
    mov rdi, 650000             ; put a lot of memory
    call alloc

    cmp rax, NULL               ; rax == null ; jump error
    je error                    ; if there is an error print this 
    jmp last                    ; otherwire we jump to finish the program

error:
    mov rax, SYS_write
    mov rdi, STDOUT
    mov rsi, alloc_error_msg
    mov rdx, alloc_error_msg_len
    syscall
    
last:                           ; get out 
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall
    
