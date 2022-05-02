    ;; This is a program that connects the input and output like a pipe
    section .data
    ;; Declare constants
    
    SYS_exit equ 60
    EXIT_SUCCESS equ 0

    STDIN equ 0
    SYS_read equ 0

    STDOUT equ 1
    SYS_write equ 1

    LF equ 0xa
    NULL equ 0

    section .bss
    char resb 1                 ; just we want like 1 byte

    section .text
    global _start

_start:
    mov rsi, char               ; Here I prepare the direction
    mov rdx, 0x1                ; And also the amount
    
readIn:
    mov rax, SYS_read
    mov rdi, STDIN
    syscall
    mov al, byte [char]
    cmp al, LF
    je finishRead                     ; Here We finish the program
    mov rax, SYS_write
    mov rdi, STDOUT
    syscall
    jmp readIn                  ; I jump to the readIn

finishRead:
    mov rax, SYS_write
    mov rdi, STDOUT
    syscall
    
last:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall





    
    
