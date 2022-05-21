    ;; simple program to do loops and work with floating valus
    section .data
    
    ;;  my constants
    SYS_exit equ 60
    EXIT_SUCCESS equ 0
    EXIT_FAILURE equ 1

    SYS_write equ 1
    STDOUT equ 1

    NULL equ 0
    LF equ 10

    ;; my variables
    msg1 db "Are equal", LF, NULL
    len1 equ $-msg1
    
    msg2 db "Not equal", LF, NULL
    len2 equ $-msg2

    msg3 db "Lesser", LF, NULL
    len3 equ $-msg3

    msg4 db "Greater", LF, NULL
    len4 equ $-msg4

    x dq 1.0
    y dq 2.0

    section .bss                ; my variables for the program 
    res resq 1                    ; 8 bytes

    
    section .text
    global _start
_start:
    mov rax, SYS_write          ; I prepare the syscall
    mov rdi, STDOUT
    
    ;;  to comparate
    movsd xmm0, qword [y]       ; I move the 10.p5
    ucomisd xmm0, qword [x]      ; if (xmm0 == x)
    je printMsg1

    ucomisd xmm0, qword [x]     ; if (xmm0 != 0)
    jne printMsg2

    ucomisd xmm0, qword [x]    ; unsigned,  if (xmm0 < x)
    jb printMsg3

    ucomisd xmm0, qword [x]     ; unsigned, if (xmm0 > x)
    ja printMsg4

    ;;  there are also
    ;; jbe: for <=
    ;; jae: for >=
    ;; and also for 4 bytes values there is "ucomiss"

    jmp last                    ; doesn't print anythingx
    
    
printMsg1:                      ; print are equal
    mov rsi, msg1
    mov rdx, len1
    jmp printingMsg

printMsg2:
    mov rsi, msg2
    mov rdx, len2
    jmp printingMsg
    
printMsg3:
    mov rsi, msg3
    mov rdx, len3
    jmp printingMsg

printMsg4:
    mov rsi, msg4
    mov rdx, len4

printingMsg:
    syscall
    
last:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall
    
    

    
