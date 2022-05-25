    ;; This is a code project where I create my own malloc in nasm

    section .data
    ;; Constants
    SYS_brk equ 12
    SYS_write equ 1
    STDOUT equ 1

    ;; Capacity of the heap
    CAPAICTY equ 640000         ; 64 kilo bytes

    NULL equ 0
    LF equ 0xa

    ;; Variables
    size dd 0

    curr_brk dq NULL             ; address of the current heap
    new_brk dq NULL              ; address 

    section .bss
    

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

    ;; check the capacity
    cmp edi, CAPAICTY
    ja error_alloc

    ;; save the size
    mov dword [rbp-8], edi

    ;; get the current address of the brk
    mov rax, SYS_brk
    mov rdi, new_brk
    syscall

    ;; getting the current address
    mov qword [curr_brk], rax
    mov qword [new_brk], rax

    ;; get again the size
    mov rdi, qword [rbp-8]

    ;; create the new frame
    add qword [new_brk], rdi
    add dword [size], edi

    ;; set the new address
    mov rax, SYS_brk
    mov rdi, qword [new_brk]
    syscall

    ;; compare if somethings come wrong trying to move the break addres
    cmp rax, qword [curr_brk]
    je error_alloc

    ;; put the return value 
    mov rax, qword [curr_brk]
    
    jmp last_alloc
    
error_alloc:
    mov rax, NULL                 ; putting a null address

last_alloc:
    add rsp, 8
    pop rbp
    ret
    

    ;; void free(void *addr)
    ;; addr -> rdi              ; the address of the page of memory to free
    ;; free: free a block of memory
free:


    ;; void collect()
    ;; collect: simple garbage collector to the heap
collect:
    
    
    
    
