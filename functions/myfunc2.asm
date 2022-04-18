    ;; This is the same function sum in assembler but make it in another way
    section .data
    
    EXIT_SUCCESS equ 0
    EXIT_sys equ 60
    
    num1 dd 2                   ; double word
    num2 dd 4                   ; double word

    section .bss
    res resd 1                  ; res = 4 bytes = double word


    section .text
    global _start


    ;; func into an stack
    ;; return value
    ;; args......
    ;; rip
    ;; rbp
    ;; local variables......
    
    ;; int sum (int arg1, int arg2)
sum:
    push rbp
    mov rbp, rsp
    mov eax, dword [rbp + 16]    ; arg1
    add eax, dword [rbp + 20]   ; arg2
    pop rbp
    ret
    

_start:
    push rbp
    mov rbp, rsp
    sub rsp, 8                  ; reserb 8 bytes for two variables

    mov eax, dword [num2]
    mov dword [rbp - 4], eax    ; arg2
    mov eax, dword [num1]
    mov dword [rbp - 8], eax    ; arg1
    
    call sum                    ; push rip 8 bytes
    
    mov dword [res], eax        ; eax is the return value
    
    pop rbp


last:
    mov rax, EXIT_sys
    mov rdi, EXIT_SUCCESS
    syscall
    

    
    
    
    

    
