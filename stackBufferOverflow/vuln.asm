    ;; This is an vulnearable binary
    ;; It is just a simple program to check a password
    section .data
    ;; This are my constants
    SYS_exit equ 60
    EXIT_SUCCESS equ 0

    EOF equ 0x5
    NULL equ 0
    LF equ 0xa

    ;; To output 
    SYS_write equ 1
    STDOUT equ 1

    ;; To input
    SYS_read equ 0
    STDIN equ 0

    ;; The key to compare
    key db "password", NULL

    ;; The printable variabels
    okMsg db "Access!!!", LF, NULL
    errorMsg db "Not Access!!!", LF, NULL
    
    section .bss

    section .text
    
    ;; getPass: Copy the password to a register
    ;; This is a vulnerable program 
    ;; cpyPass(char *address, char *pass)
    ;; address: Is the direction where We are going to store the password
    ;; pass: Is the direction from the password 
cpyPass:
    push rbp
    mov rbp, rsp
    sub rsp, 1                  ; One byte to stored the input
    
startLoopCpyPass:
    ;; Get one byte
    mov al, byte [rsi]          ; the argv[1] address get the password
    mov byte [rdi], al     ; Put the byte into the address
    inc rsi
    inc rdi
    cmp al, NULL               ; If it is NULL char 
    jne startLoopCpyPass

endLoopCpyPass:
    add rsp, 1
    pop rbp
    ret

    ;; checkAuth: A function that gets the password and compare with the key
    ;; And return 0 if is correct or -1 if not 
    ;; int checkAuth(char *key, char *pass)
    ;; key: is the rdi register is an address
    ;; pass: is the rsi register is the password address
checkAuth:
    push rbp
    mov rbp, rsp            
    sub rsp, 20                 ; to store the password and the key

    mov r10, rdi                ; Save the key on that address 
    mov rdi, rsp                ; pass the address
    call cpyPass                ; execute the getPass function
    mov rdi, r10                ; catch again the address of the key
    mov rsi, rsp                ; To catch the address of the recived password
    
startCheck:
    mov al, byte [rdi]          ; One byte from key
    mov bl, byte [rsi]          ; One byte from pass
    cmp al, bl
    jne difCheck                ; if (al != bl) jmp
    cmp al, NULL                  ; finishing the iteration
    je endCheck
    inc rdi
    inc rsi
    jmp startCheck              ; iterate again
    
endCheck:
    mov rax, 0x0                ; put the return 0
    cmp bl, NULL                 ; now we compare
    je endCheckAuth 
    
difCheck:
    mov rax, 0xff               ; return -1

endCheckAuth:   
    add rsp, 20
    pop rbp
    ret

    ;; printText: Its just a function to prints the data 
    ;; void printText(char *string)
    ;; string: Is the rdi register
printText:
    push rbp
    mov rbp, rsp
    mov rsi, rdi                ; I move the address to rsi
    
    mov rax, SYS_write          ; the sys call
    mov rdi, STDOUT             ; the file descriptor
    mov rdx, 1
    
startPrintText: 
    syscall
    cmp byte [rsi], NULL        ; if it is the null byte
    je endPrintText
    inc rsi                     ; I increase the address
    jmp startPrintText

endPrintText:
    pop rbp
    ret

    
    global _start
_start:
    ;; the first rsp 8 bytes are for argc
    ;; the second rsp 8 bytes are for a pointer of the program name argv[0]
    ;; from that the next bytes are for arguments
    mov rax, qword [rsp + 16]   ; Here we get the char address of argv[1]
    mov rsi, rax
    mov rdi, key                ; I pass the address
    call checkAuth

    cmp rax, 0x0                ; If return == 0 then ok
    jne error                   ; if return == -1 then error
    mov rdi, okMsg
    jmp callPrintText           ; just I call printText
    
error:
    mov rdi, errorMsg              ; Put the address of error

callPrintText:
    call printText
last:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall
    
    
    
