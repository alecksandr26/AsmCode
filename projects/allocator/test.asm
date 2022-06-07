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

    two dq 2


    section .bss
    addr resq 1

    section .text
    global _start
_start:
    ;; running a new test
    mov rbx, 0
    

loop:
    cmp rbx, 100
    je done_loop

    mov rdi, rbx
    inc rdi
    call alloc
    mov qword [addr], rax

    cmp rax, NULL               ; rax == null ; jump error 
    je error                    ; if there is an error print this
    
    ;;  allocate the number
    mov byte [rax], dil

    ;; if (rax % 2 == 0)
    mov rax, rdi
    div qword [two]
    inc rbx 
    cmp rdx, NULL
    jne loop

    ;; otherwire we free the memory
    mov rdi, qword [addr]
    call free

    jmp loop
    


done_loop:
    
    jmp last                    ; finish the program is anything comes wrong

error:
    mov rax, SYS_write
    mov rdi, STDOUT
    mov rsi, alloc_error_msg
    mov rdx, alloc_error_msg_len
    syscall

    mov rax, SYS_exit
    mov rdi, EXIT_FAILURE
    syscall
    
last:                           ; get out 
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall
    
