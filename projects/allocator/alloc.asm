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


    ;; Constants of the heap
    
    ;; Capacity of the free address
    HEAP_FREE_CAPACITY equ 8192         ; 8 kilo bytes
    HEAP_FREE_CAPACITY_SIZE equ 1024     ; the size of each 1024

    ;; Variables
    size dd 0

    curr_brk dq NULL             ; address of the current heap

    ;; Message errors for free
    free_error_msg db "Error: Invalid address to free", LF, NULL
    free_error_msg_len equ $ - free_error_msg

    ;; Message errors for heap insert function 
    heap_insert_error_msg db "Error: Not enough space for free address", LF, NULL
    heap_insert_error_msg_len equ $ - heap_insert_error_msg

    ;; heap variables
    
    ;; the amount of free chucks that we have
    heap_size_free dq 0

    
    section .bss                ; the variables 
    
    init_brk resq 1             ; the initial address of the heap 
    free_heap resq 1            ; the address where we store the memory
    new_brk resq 1              ; the new address of the heap

    ;; heap variables
    
    heap_root_addr resq 1            ; 8 bytes for the heap root address

    section .text
    
    ;; These are the public methods 
    global alloc
    global free


    ;; Some extra functions needed



    ;; void *__heap_get_child(void *parent, unsigned char child_type)
    ;; parent -> rdi        the parent index 
    ;; child_type -> rdx    1 if the child is the left or 2 if the child is the right
    ;; __heap_get_child: Return the index of the child depending if it is the right child or the left child
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
    ;; child -> rdi     The index of the buffer
    ;; __heap_get_parent: Return the parent index of the children index
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

    ;; short __heap_get_chunk_size(void *addr)
    ;; addr -> rdi          The address of the chuck of memory
    ;; __heap_get_chunk_size: Return the size of the chunk of memory
__heap_get_chuck_size:
    
    ;; Get the size two bytes
    mov rax, 0
    mov ax, word [rdi-2]         ; get the size of the chunk
    
    ret
    

    ;; void *__heap_get_address(unsigned long index)
    ;; index -> rdi the index 
    ;; __heap_get_address: Calculate the address of some index
__heap_get_address:
    push rbp
    mov rbp, rsp
    sub rsp, 8
    mov qword [rsp], 8
    
    mov rax, rdi
    mul qword [rsp]
    
    add rax, qword [init_brk]

    ;;  Get the address
    mov rax, qword [rax]
    pop rbp
    ret


    ;; long __heap_compare_sizes(long parent_index, long child_index)
    ;; parent_index -> rdi
    ;; child_index -> rsi
    ;; __heap_compare_sizes: Return -1 if parent_size < child_size or 0 if parent_size == child_size
    ;; 1 if parent_size > child_size.
__heap_compare_sizes:
    
    ;; Get the parent chunk size
    call __heap_get_address
    mov rdi, rax                ; Move the address to rdi
    call __heap_get_chuck_size
    mov rbx, rax                ; Now move the size to rb

    
    mov rdi, rsi                ; move the index of the child node
    ;; Get the child size
    call __heap_get_address
    mov rdi, rax
    call __heap_get_chuck_size  ; Now get the chunk size

    ;; Now compare the sizes
    cmp rax, rbx                ; if (child_size > parent_size)
    ja __heap_compare_sizes_if
    cmp rax, rbx                ; else if (child_size == parent_size)
    je __heap_compare_sizes_else_if
    mov rax, -1                 ; else
    ret
    
__heap_compare_sizes_if:
    mov rax, 1
    ret                         ; And return
    
__heap_compare_sizes_else_if:
    mov rax, 0
    ret
        
    


    ;; void *__heap_extract()
    ;; __heap_extract: Return the address of the greater chunk of memory
__heap_extract:
    push rbp,
    mov rbp, rsp

    

    
    
    pop rbp
    ret


    ;; void __heap_insert(void *addr)
    ;; addr -> rdi   The new address to insert 
    ;; __heap_insert: To insert a new chunk of memory
__heap_insert:
    push rbp
    mov rbp, rsp

    mov rax, qword [heap_size_free] ; mov the amount to rax
    cmp rax, HEAP_FREE_CAPACITY_SIZE
    je __heap_insert_error      ; Out of capacity

    ;; First insert the node
    mov rax, 8
    mul qword [heap_size_free]  ; calculate the position of the new address
    add rax, qword [init_brk]   ; calculate the address
    mov qword [rax], rdi        ; put the new address

    ;; Now calculate the parent address 
    mov rdi, qword [heap_size_free]
    call __heap_get_parent

    ;; save the index
    mov r8, rax

    
    
__heap_insert_loop:
    cmp rdi, 0                   ; if (child_index > 0)
    je __heap_insert_end_loop
    ;; now compare if the children is lesser than
    
    
    
__heap_insert_end_loop:         ; end of the loop
    

    jmp __heap_insert_last
    
__heap_insert_error:            ; If we get an error close the program

    ;; Print out of capcity
    mov rax, SYS_write
    mov rdi, STDOUT
    mov rsi, heap_insert_error_msg
    mov rdx, heap_insert_error_msg_len
    syscall

    ;; Exit from the promgram with error
    mov rax, SYS_exit
    mov rdi, EXIT_FAILURE
    syscall
    
__heap_insert_last: 
    
    inc qword [heap_size_free]  ; Increment the size of the heap
    
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
    
    
    
    
