    ;;  This is an example of how works an sys call
    section .data
    EXIT_SUCCESS equ 0
    EXIT_syscall equ 60

    STDOUT equ 1                ; This is the standart code of set to out
    WRITE_SYS equ 1             ; And this is the code to make a syscall to send data to someone

    msg db "Hello World", 0xa, 0 ; this is the data to send
    l dq 13                      ; we need the amount of bytes

    
    section .text
    global _start

_start:
    ;;  Now here we are going to do another syscall
    ;;  a syscall use these registers as arguments
    ;; rax call codennn
    ;; rdi 1
    ;; rsi 2
    ;; rdx 3
    ;; rcx 4
    ;; r9 5
    ;; r9 6

    ;;  Now here we want to do the sys call
    mov rax, WRITE_SYS
    mov rdi, STDOUT             ; where we want to send the stream of data
    mov rsi, msg                ; the address of that data
    mov rdx, qword [l]          ; the amount of data in bytes
    syscall                     ; call the system


last:                           ; Here we are doig a syscall
    mov rax, EXIT_syscall       ; Here we pass the code of the sys call
    mov rdi, EXIT_SUCCESS
    syscall

    
