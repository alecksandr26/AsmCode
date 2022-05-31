    ;; This is a code project where I create my own malloc in nasm

    section .data
    ;; Constants
    SYS_exit equ 60
    EXIT_FAILURE equ 1
    
    SYS_brk equ 12

    SYS_write equ 1
    STDOUT equ 1

    NULL equ 0
    LF equ 0xa

    ;; Variables
    size dd 0

    curr_brk dq NULL             ; address of the current heap
    
    free_error_msg db "Error: Invalid address to free", LF, NULL
    free_error_msg_len equ $ - free_error_msg

    ;; heap variables

    ;; Capacity of the free address
    HEAP_FREE_CAPACITY equ 8192         ; 8 kilo bytes
    HEAP_FREE_CAPACITY_SIZE equ 1024     ; the size of each 1024

    ;; the amount of free chucks that we have
    heap_size_free dd 0

    

    section .bss                ; the variables 
    
    init_brk resq 1             ; the initial address of the heap
    free_heap resq 1            ; the address where we store the memory
    new_brk resq 1              ; the new address of the heap

    ;; heap variables
    
    heap_addr resq 1            ; 8 bytes for the heap root address

    section .text
    
    ;; These are the public methods 
    global alloc
    global free


    ;; Some extra functions needed

    ;; short __heap_get_chunk_size(void *addr)
    ;; addr -> rdi          The address of the chuck of memory
    ;; __heap_get_chunk_size: Return the size of the chunk of memory
__heap_get_chuck_size:
    
    ;; Get the addres of the chunk
    mov r8, qword [rdi]
    
    ;; Get the size two bytes
    mov rax, 0
    mov ax, word [r8-2]         ; get the size of the chunk
    
    ret

    ;; void *__heap_get_child(void *parent, unsigned char child_type)
    ;; parent -> rdi        the parent address 
    ;; child_type -> rdx    1 if the child is the left or 2 if the child is the right
    ;; __heap_get_child: Return address of the child depending if it is the right child or the left child
__heap_get_child:
    push rbp
    mov rbp, rsp
    sub rsp, 8
    
    mov qword [rsp], 2          ; set the number 2
    
    mov rax, rdi                ; Moving parent address to rax
    mul qword [rsp]             ; multiply with 2

    add rax, rdx                ; sum rax + (2 or 1) depending 

    add rsp , 8
    pop rbp
    ret

    ;; void *__heap_get_parent(void *child)
    ;; child -> rdi     The address of the child node
    ;; __heap_get_parent: Return the parent address of the children address
__heap_get_parent:
    push rbp
    mov rbp, rsp
    sub rsp, 8

    mov qword [rsp], 2          ; set the number 2

    mov rax, rdi                ; move the child address to rax
    sub rax, 1                  ; subtract by 1
    div qword [rsp]             ; get the parent address

    add rsp, 8
    pop rbp
    ret
    


    ;; void *__heap_extract()
    ;; __heap_extract: Return the address of the greater chunk of memory
__heap_extract:
    push rbp,
    mov rbp, rsp



    
    pop rbp
    ret



    ;; void __heap_insert()
    ;; __heap_insert: To insert a new chunk of memory
__heap_insert:
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
    je __alloc_error

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

    ;; get the address of the heap 
    mov qword [free_heap], rax

    ;; try to create our frame of memory for free address 
    mov rdi, rax
    mov rax, SYS_brk    
    add rdi, HEAP_FREE_CAPACITY
    syscall

    cmp rax, qword [free_heap]                ; if this is true there is an error
    je __alloc_error
    
    
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

    mov rax, SYS_brk
    mov rdi, qword [new_brk]
    syscall

    ;; compare if somethings come wrong trying to move the break addres
    cmp rax, qword [curr_brk]
    je __alloc_error
    
    ;; put the return value 
    mov rax, qword [curr_brk]

    ;; take two bytes and put the size of chuck these are metadata
    mov di, word [rbp - 8]
    sub di, 2
    mov word [rax], di          ; put the size of chuck
    
    ;; increment the address by 2
    add rax, 2
    
    jmp __alloc_last
    
__alloc_error:
    mov rax, NULL                 ; putting a null address

__alloc_last:
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
    jb __free_error

    
    ;; get the initial address
    mov rax, qword [init_brk]

    cmp rdi, rax                ; if (rdi < rax)
    jb __free_error

    ;; first calculate the size of the free heap buffer
    mov eax, 8             
    mul dword [heap_size_free]              ; multiply the size with 8 bytes

    ;; lets move the pointer
    mov r8, qword [free_heap]  ; get the address of the buffer
    add r8, rax                ; move the address of the buffer

    ;; Now this is problematic this will become O(N) and we need O(logN)
    mov qword [r8], rdi        ; allocate the free address
    inc dword [heap_size_free]       ; increment the size of the free heap
    
    jmp __free_last
    
__free_error:                   ; If we receive an invalid address
    mov rax, SYS_write
    mov rdi, STDOUT
    mov rsi, free_error_msg
    mov rdx, free_error_msg_len
    syscall
    
    ;; quit the program
    mov rax, SYS_exit
    mov rdi, EXIT_FAILURE
    syscall
    
__free_last:
    pop rbp
    ret
    
    


    ;; void collect()
    ;; collect: simple garbage collector to the heap
collect:
    
    
    
    
