    ;;  This is the same function of sum but make it in another way
    section .data
    EXIT_SUCCESS equ 0
    EXIT_sys equ 60
    
    num1 dd 2
    num2 dd 4


    section .bss
    res resd 1

    section .text

    global _start
    
    ;; int sum(int arg1, int arg2)
sum:
    mov eax, edi                ; arg1
    add eax, esi                ; arg2
    ret
    

_start:
    mov edi, dword [num1]
    mov esi, dword [num2]
    call sum


last:
    mov rax, EXIT_sys
    mov rdi, EXIT_SUCCESS
    syscall


    
