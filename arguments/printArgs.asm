    ;; This is a simple program which print the args
    section .data
    SYS_exit equ 60
    EXIT_SUCCESS equ 0
    EXIT_FAILURE equ -1

    EOF equ 0x5
    NULL equ 0
    LF equ 0xa

    ;; To output
    SYS_write equ 1
    STDOUT equ 1

    LF equ 0xa
    NULL equ 0x0

    ;;  some variables
    newLine db LF, NULL

    needOneArg db "We need at least one argument", LF, NULL
    
    section .bss

    section .text
    
    global _start


_start:
    ;; by convention
    ;; rsp  = argc
    ;; rsp = argv
    mov r12, qword [rsp]                ; by default is the number of arguments
    cmp r12, 0x2                        ; To now if there is one argument
    jl printError                       ; if (r12 < 0x2)
    mov r13, rsp
    add r13, 8                 ; To get argv[0] address
    jmp printArgument                   ; print the argument

printError:
    mov rdi, needOneArg
    call printString            ; call to print the error
    
    mov rax, SYS_exit           ; Stop the program 
    mov rdi, EXIT_FAILURE
    syscall

    ;;  now we are going to print the arguments
printArgument:
    ;; prepare before the loop
    mov rbx, 1
    
printLoop:
    mov rdi, qword [r13 + rbx * 8] ; start from address argv[0] + rbx * 8 bytes 
    call printString               ; and print the string

    mov rdi, newLine
    call printString
    inc rbx
    cmp rbx, r12                ; to know if we already print all the arguments
    jl printLoop


last:                           ; done the example 
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall



    global pritnString
printString:
    push rbp
    mov rbp, rsp
    push rbx
    
    ;;  count character into the string
    mov rbx, rdi 
    mov rdx, 0
strCountLoop:
    cmp byte [rbx], NULL        ; Iterate until we get a null data
    je strCountDone
    inc rbx
    inc rdx
    jmp strCountLoop

strCountDone:
    cmp rdx, 0
    je ptrDone

    ;;  Call Os to output string
    mov eax, SYS_write
    mov rsi, rdi
    mov edi, STDOUT
    syscall

ptrDone:
    pop rbx
    pop rbp
    ret
    
