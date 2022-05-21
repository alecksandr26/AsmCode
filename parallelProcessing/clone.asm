    ;; This is a program that will use the clone function
    ;; that will create paralel subrutines

    ;;  these are the functions that we are going to use
    extern clone
    extern waitpid
    
    section .data
    ;; constants
    SYS_exit equ 60
    EXIT_SUCCESS equ 0
    EXIT_FAILURE equ 1
    
    SYS_write equ 1
    STDOUT equ 1

    LF equ 10
    NULL equ 0

    ;; To create a child process we use it is similar to fork
    SIGCHLD equ 17              ; To get a regular process with another id

    ;; To know the id of a process
    SYS_getpid equ 39

    ;; nanosleep syscall to wait
    SYS_nanosleep equ 35

    BUFFSIZE equ 1024

    ;; my variables

    hw db "Hello world!!", LF, NULL
    len equ $-hw

    hw2 db "Hello after two seconds!!", LF, NULL
    len2 equ $-hw2

    msg db "out from thread!!", LF, NULL
    msglen equ $-msg

    ;; 5 seconds
    sec dq 2
    sec2 dq 1
    sec3 dq 3

    section .bss
    buff resb 1024              ; for memory frame for thread

    status resd 1               ; int value

    section .text
    global main
    

    ;; printHello: Is the function that will print a hello world
    ;; void printHello()
printHello:
    mov rax, SYS_write
    mov rdi, STDOUT
    mov rsi, hw
    mov rdx, len
    syscall
    
    mov rax, SYS_nanosleep
    mov rdi, sec
    mov rsi, 0
    syscall
    
    mov rax, SYS_write
    mov rdi, STDOUT
    mov rsi, hw2
    mov rdx, len2
    syscall
    

    ;;  now we do an infinite loop
infiniteLoop:
    nop
    jmp infiniteLoop
    
    ret
    
main:
    
    ;; instead of use call like a secuancial program we run a thread
    ;; witht the function clone
    ;; int clone(int (*fn)(void *), void *stack, int flags, void *arg, ...
    ;;  pid_t *parent_tid, void *tls, pid_t *child_tid);
    ;; also clone is like a thread so its need his own memory frame
    mov rdi, printHello         ; the function 
    mov rsi, buff
    add rsi, BUFFSIZE - 1       ; to get the head of the memory
    mov rdx, SIGCHLD
    mov rcx, NULL               ; no arguemtns
    call clone

    mov rax, SYS_nanosleep
    mov rdi, sec2
    mov rsi, 0
    syscall
    

    ;; sys write function 
    mov rax, SYS_write
    mov rdi, STDOUT
    mov rsi, msg
    mov rdx, msglen
    syscall

    ;; move the child process id
    mov r9, rax

    mov rdi, r9                 ; with the wait syscall
    mov rsi, status
    mov rdx, NULL
    call waitpid

    mov rax, SYS_nanosleep
    mov rdi, sec3
    mov rsi, 0
    syscall
        
last:
    mov rax, SYS_exit           ; quit the program
    mov rdi, EXIT_SUCCESS
    syscall
    
