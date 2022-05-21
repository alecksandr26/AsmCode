    ;; Simple program to manipulate floats
    section .data
    ;;  my  constants
    SYS_exit equ 60
    EXIT_SUCCESS equ 0
    EXIT_FAILURE equ 1

    ;; my vars
    num dq 1.5              
    num2 dq 0.5

    n dd 2.6
    n2 dd 0.5

    x dd 1.5
    y dd 2.0

    x1 dq 2.5
    x2 dq 2.0

    square dq 25.0
    square2 dd 36.0
    
    section .bss
    r resq 1                    ; 8 bytes
    res resd 1                  ; 4 bytes
    
    section .text
    global _start
_start:
    ;;  for adding
    movsd xmm0, qword [num]     ; moving 8 bytes
    addsd xmm0, qword [num2]    ; adding 0.5
    movsd qword [r], xmm0       ; moving the result

    movss xmm0, dword [n]       ; moving 4 bytes
    addss xmm0, dword [n2]       ; adding 0.5
    movss dword [res], xmm0     ; moving the result


    ;; now to subtract
    movsd xmm0, qword [num]     ; lets subtract 8 bytes
    subsd xmm0, qword [num2]
    movsd qword [r], xmm0

    movss xmm0, dword [n]       ; lets subtract 4 bytes
    subss xmm0, dword [n2]
    movss dword [r], xmm0

    ;;  for multiple
    movss xmm0, dword [x]       ; moving the x 1.5
    mulss xmm0, dword [y]       ; multiplying
    movss dword [r], xmm0       ; move the res

    movsd xmm0, qword [x1]      ; movint the 2.5
    mulsd xmm0, qword [x2]      ; multiplying
    movsd qword [res], xmm0     ; moving the result

    ;; now the division
    movss xmm0, dword [r]       ; moving the result
    divss xmm0, dword [y]
    movss dword [r], xmm0

    movsd xmm0, qword [res]     ; easy
    movsd xmm0, qword [x1]
    movsd qword [res], xmm0     

    ;; and finally square root
    sqrtss xmm0, dword [square2]
    sqrtsd xmm0, qword [square]
    
last:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall
