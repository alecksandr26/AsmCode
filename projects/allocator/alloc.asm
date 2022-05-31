    ;; This is a code project where I create my own malloc in nasm

    section .data
    ;; Constants
    SYS_exit equ 60
    EXIT_FAILURE equ 1
    
    SYS_brk equ 12

    SYS_write equ 1
    STDOUT equ 1

    ;; Capacity of the free address
    FREE_CAPACITY equ 8192         ; 8 kilo bytes
    FREE_CAPACITY_SIZE equ 1024     ; the size of each 1024

    NULL equ 0
    LF equ 0xa

    ;; Variables
    size dd 0

    ;; the amount of free chucks that we have
    size_free dd 0

    curr_brk dq NULL             ; address of the current heap

    
    free_error_msg db "Error: Invalid address to free", LF, NULL
    free_error_msg_len equ $ - free_error_msg

    ;; heap variables
    
    

    section .bss                ; the variables 
    
    init_brk resq 1             ; the initial address of the heap
    free_heap resq 1            ; the address where we store the memory
    new_brk resq 1              ; the new address of the heap  

    section .text
    
    ;; These are the public methods 
    global alloc
    global free



    ;; void *__heap__extract()
    ;; __heap_extract: Return the address of the greater chunk of memory
__heap__extract:
    push rbp,
    mov rbp, rsp



    
    pop rbp
    ret



    ;; void __heap__insert()
    ;; __heap__insert: To insert a new chunk of memory
__heap__insert:
    push rbp
    mov rbp, rsp

    
    pop rbp
    ret
    
    
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
    jne __alloc__else
    ;; this means that it is the first time running an alloc

    ;; get the address of the heap 
    mov qword [free_heap], rax

    ;; try to create our frame of memory for free address 
    mov rdi, rax
    mov rax, SYS_brk    
    add rdi, FREE_CAPACITY 
    syscall

    cmp rax, qword [free_heap]                ; if this is true there is an error
    je __alloc__error
    
    
    ;; get the initial brk address
    mov qword [init_brk], rax
__alloc__else:
    
    
    ;; getting the current address
    mov qword [curr_brk], rax
    mov qword [new_brk], rax

    ;; get again the size
    mov edi, dword [rbp-8]

    ;; create the new chuck of memory and incremenet the size of chunks 
    add qword [new_brk], rdi
    inc dword [size]

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
    mov word [rax], di          ; put the size of chuck
    
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

    sub rdi, 2                  ; subtract by 2
    cmp rax, rdi                ; if (rax < rdi)
    jb __free__error

    
    ;; get the initial address
    mov rax, qword [init_brk]

    cmp rdi, rax                ; if (rdi < rax)
    jb __free__error

    ;; first calculate the size of the free heap buffer
    mov eax, 8             
    mul dword [size_free]              ; multiply the size with 8 bytes

    ;; lets move the pointer
    mov r8, qword [free_heap]  ; get the address of the buffer
    add r8, rax                ; move the address of the buffer

    ;; Now this is problematic this will become O(N) and we need O(logN)
    mov qword [r8], rdi        ; allocate the free address
    inc dword [size_free]       ; increment the size of the free heap
    
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
    
    
    
    
