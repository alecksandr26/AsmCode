    ;; This is a code project where I create my own malloc in nasm

    section .data
    ;; Constants
    SYS_exit equ 60
    EXIT_FAILURE equ 1
    
    SYS_brk equ 12

    SYS_write equ 1
    STDOUT equ 1

    ;; Capacity of the free address
    FREE_CAPAICTY equ 8192         ; 8 kilo bytes

    NULL equ 0
    LF equ 0xa

    ;; Variables
    size dd 0

    curr_brk dq NULL             ; address of the current heap
    new_brk dq NULL              ; the new address of the heap

    
    free_error_msg db "Error: Invalid address to free", LF, NULL
    free_error_msg_len equ $ - free_error_msg
    

    section .bss
    init_brk resq 1             ; the initial address of the heap

    section .text
    global alloc
    global free

    
    ;; void *alloc(unsigned amount_bytes)
    ;; amount_bytes -> edi      ; the amount of bytes that we want
    ;; alloc: return the amount the address of the page of the memory that we want
alloc:
    push rbp
    mov rbp, rsp
    sub rsp, 8                  ; Create the frame to store the amount_bytes

    ;; can't receive zero amount_bytes
    cmp edi, NULL
    je __alloc__error

    ;; increment the real capcity by two bytes
    add edi, 2

    ;; save the size
    mov dword [rbp-8], edi

    ;; get the current address of the brk
    mov rax, SYS_brk
    mov rdi, new_brk
    syscall

    cmp qword [curr_brk], NULL
    jne __alloc_else

    ;; this means that it is the first time running an alloc
    add rax, FREE_CAPAICTY 

    ;; get the initial brk address
    mov qword [init_brk], rax

__alloc_else:
    ;; getting the current address
    mov qword [curr_brk], rax
    mov qword [new_brk], rax

    ;; get again the size
    mov edi, dword [rbp-8]

    ;; create the new chuck of memory and incremenet the size of chunks 
    add qword [new_brk], rdi
    inc dword [size]

    ;; set the new break address
    mov rax, SYS_brk
    mov rdi, qword [new_brk]
    syscall

    ;; compare if somethings come wrong trying to move the break addres
    cmp rax, qword [curr_brk]
    je __alloc__error

    
    ;; put the return value 
    mov rax, qword [curr_brk]

    ;; take two bytes and put the size of chuck these are metadata
    mov di, word [rbp - 8]
    sub di, 2
    mov word [rax], di
    ;; increment the address by 2
    add rax, 2
    
    jmp __alloc__last
    
__alloc__error:
    mov rax, NULL                 ; putting a null address

__alloc__last:
    mov rdi, qword [rbp-8]
    sub rdi, 2
    
    add rsp, 8
    pop rbp
    ret
    

    ;; void free(void *addr)
    ;; addr -> rdi              ; the address of the page of memory to free
    ;; free: free a chunk of memory
free:
    push rbp
    mov rbp, rsp

    ;; verified the address 

    ;; get the current address
    mov rax, qword [curr_brk]
    
    cmp rax, rdi                ; if (rax < rdi)
    jb __free__error

    
    ;; get the initial address
    mov rax, qword [init_brk]

    cmp rdi, rax                ; if (rdi < rax)
    jb __free__error

    mov r8w, word [rdi - 2] ; get the size of the chuck

    


    
    jmp __free__last
    
__free__error:                   ; If we receive an invalid address
    mov rax, SYS_write
    mov rdi, STDOUT
    mov rsi, free_error_msg
    mov rdx, free_error_msg_len
    syscall
    
    ;; quit the program
    mov rax, SYS_exit
    mov rdi, EXIT_FAILURE
    syscall
    
__free__last:    
    pop rbp
    ret
    
    


    ;; void collect()
    ;; collect: simple garbage collector to the heap
collect:
    
    
    
    
