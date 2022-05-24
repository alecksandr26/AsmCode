    ;; This is an program example to know how to create
    ;; memory frames from the heap we use the brk syscall
    ;; this syscall returns a new address frame if success
    ;; otherwise return the current address if don't success
    ;; the syscall brk is not the same from brk function at c 
    
    section .data
    ;; my constatns
    
    SYS_exit equ 60
    EXIT_SUCCESS equ 0
    EXIT_FAILURE equ 1

    NULL equ 0x0
    LF equ 0xa

    ;; my variables

    ;; the brk address always it is going to start at 0x0 address
    initial_break dq NULL
    current_break dq NULL
    new_break dq NULL
    
    SYS_brk equ 12
    
    
    section .bss
    
    section .text
    global _start
_start:
    ;; As it says, the brk() system call returns current break address
    ;; if failed. If success, brk() returns new break address

    ;; get the current address
    mov rax, SYS_brk
    mov rdi, 0                  ; invalid address
    syscall
    mov qword [current_break], rax ; get the address
    mov qword [initial_break], rax ; get the address
    

    
last:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall
