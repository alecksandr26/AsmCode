    ;; This is an example of how we can create a print function in asm

    section .data
    EXIT_SUCCESS equ 0
    EXIT_syscall equ 60

    STDOUT equ 1
    WRITE_SYS equ 1

    LF db 10, NULL                   ; new line or line feed
    NULL equ 0                  ; The null value

    ;; Data to test to my function its important to put the NULL value
    ;; to know when stop the stream of data
    message1 db "Hello there", NULL
    message2 db "Another test", NULL
    message3 db "The last one test", NULL


    section .text
    global _start

    ;;  This is my function

    ;; void print_string (char *msg)
    ;; msg: Is rdi register
_print_string:
    ;; First we need to get the length of the string
    mov rsi, rdi ; here I move the address to the rsi
    
    mov rdx, 1                  ; set the couter in zero
    push rsi
    mov rax, 0                  ; Its important to clear before start doing our stuff
    
_print_do_loop:
    mov al, byte [rsi]          ; take the first data
    cmp rax, NULL                     ; now we need to when we get to the end
    je _print_end_loop                ; if (rax == NULL) jump to _print_end_loop
    inc rdx                           ; Here we increment the couters and jump back
    inc rsi
    jmp _print_do_loop
    
_print_end_loop:
    pop rsi                     ; Here we catch again the address
    
    ;; Now we know what is the length of the string
    ;; lets print it we already have the address in rsi
    mov rax, WRITE_SYS
    mov rdi, STDOUT
    syscall
    ret                         ; Get out from the function
    
    
_start:
    ;; lets test our function
    mov rdi, message1
    call _print_string

    mov rdi, LF
    call _print_string

    mov rdi, message2
    call _print_string
    
    mov rdi, LF
    call _print_string

    mov rdi, message3
    call _print_string

    mov rdi, LF
    call _print_string
    

last:
    mov rax, EXIT_syscall
    mov rdi, EXIT_SUCCESS
    syscall
    


    
