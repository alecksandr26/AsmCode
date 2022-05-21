    ;; Simple program of float movements
    section .data

    ;; my constants
    SYS_exit equ 60
    EXIT_SUCCESS equ 0
    EXIT_FAILURE equ 1

    ;; variables
    pi dd 3.14                  ; 4 bytes
    e dq 2.71828                ; 8 bytes
    
    section .bss
    f resq 1                ; 8 bytes
    res resd 1              ; 4 bytes

    num resq 1                  ; integer 8 bytes
    num2 resd 1                 ; integer 4 bytes
    
    section .text
    global _start
_start:
    ;; This is how we can move
    ;; we need to use "xmm" registers
    ;; there are from xmm0 - xmm15
    ;; these registers are 64 bit 
    movss xmm0, dword [pi]       ; movss is for 4 bytes
    movsd xmm1, qword [e]        ; movsd is for 8 bytes
    movsd qword [f], xmm1    ; moving the e letter

    ;; To convert 32 bit floating register to 64 bit
    cvtss2sd xmm0, dword [pi]    ; converting the pi data to 64 bit

    ;; now from 64 bit to 32 bit
    cvtsd2ss xmm0, qword [e] ; moving 64 bits to 32 bits

    ;; the value will be rounded 
    cvtss2si eax, xmm0  ; converting 32 bit float to integer

    ;;  converting 64 bit float to long integer
    ;;  also will be rounded
    cvtsd2si rax, qword [e]    ; converting 64 bit float value to 64 bit long integer
    
    
    
    
   
last:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall
    


    
