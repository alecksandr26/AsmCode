    ;; This is an small program to read data

    section .data
    EXIT_SUCCESS equ 0
    EXIT_syscall equ 60

    ;;  This is the standard code of receive the data
    STDIN equ 0
    READ_SYS equ 0              ; This is the code of read syscall

    NULL equ 0                  ; The null value
    LF equ 0xa                  ; the new line

    section .bss
    data resb 20                ; Here I resrbe 20 byte for the data

    
    section .text
    global _start

    ;; void _input_string (char *data)
    ;; data: is the rdi with the addres where stored the data
_input_string:
    push rdi                    ; To save the address
    mov rsi, rdi                ; Here we copy the address
    mov rdx, 0x1                ; We are going to read byte per byte
    mov rax, 0
    
_do_loop:
    mov rax, READ_SYS           ; Prepare the syscall
    mov rdi, STDIN              ; The standard descriptor of read
    syscall                     ; And now we do the syscall
    mov al, byte [rsi]          ; Take the readed byte
    cmp rax, LF        ; If the byte is null
    je _end_loop
    inc rsi                     ; Here we increment the address
    jmp _do_loop
    
_end_loop:
    mov byte [rsi], LF          ; Here I move the new line to the string
    pop rdi                     ; catch the address
    ret                         ; Return back
    
_start:
    ;;  Lets test our input function
    mov rdi, data               ; Lets put the address
    call _input_string          ; call the function 
    

last:
    mov rax, EXIT_syscall
    mov rdi, EXIT_SUCCESS
    syscall
    
