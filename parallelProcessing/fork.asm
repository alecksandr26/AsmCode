    ;; we are going to use fork syscall to create a subprocess
    ;; which we can create parallel processing
    
    section .data
    ;; constatns
    SYS_exit equ 60            ; sys_write
    EXIT_FAILURE equ 1
    EXIT_SUCCESS equ 0

    SYS_write equ 1
    STDOUT equ 1

    ;; This is value for SYS_fork
    SYS_fork equ 57

    ;; nanosleep syscall
    SYS_nanosleep equ 35

    LF equ 10
    NULL equ 0

    ;; do the syscall
    SYS_wait4 equ 61

    ;; my varaibles
    msg db "Inside a fork", LF, NULL
    len equ $-msg

    msg2 db "Outside of a fork", LF, NULL
    len2 equ $-msg2

    msg3 db "Done!!!", LF, NULL
    len3 equ $-msg3

    ;;  one second
    sec dq 1
    sec2 dq 3

    status dd 1                 ; 4 bytes

    section .bss
    
    ;; the id of the process
    pid resq 1                  ; were we are going to store the pid
    
    section .text
    global _start
_start:
    mov rax, SYS_fork
    syscall

    ;;  from here we are going to start executing another process
    cmp rax, 1                  ; if (rax >= 1)
    jae executeFork

    
    ;; mow we print a message
    mov rax, SYS_write
    mov rdi, STDOUT
    mov rsi, msg2
    mov rdx, len2
    syscall

    ;; wait a little bit to finish at the same time
    mov rax, SYS_nanosleep
    mov rdi, sec
    mov rsi, 0
    syscall

    ;; now we wait that the process finished
    mov rax, SYS_wait4
    mov rdi, qword [pid]        ; move the pid value
    mov rsi, status
    syscall

    
    ;; mow we print another message
    mov rax, SYS_write
    mov rdi, STDOUT
    mov rsi, msg3
    mov rdx, len3
    syscall
    
    jmp last
    
    ;; executing the fork
executeFork:
    ;; now we are going to store the pid
    mov qword [pid], rax

__wait:   
    ;; wait a little bit to finish at the same time
    mov rax, SYS_nanosleep
    mov rdi, sec2
    mov rsi, 0
    syscall
    
    mov rax, SYS_write
    mov rdi, STDOUT
    mov rsi, msg
    mov rdx, len
    syscall

    
    
last:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall
    
