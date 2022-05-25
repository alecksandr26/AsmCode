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
    

    section .bss
    curr_brk resq 1             ; address of the current heap
    new_brk resq 1              ; address of the new heap
    top_brk resq 1              ; address of the top of the heap
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

    ;; create the memory frame doing the brk syscall
    
    cmp edi, CAPAICTY
    ja error_alloc

    add dword [size], edi       ; add the amount of bytes to the size
    
    jmp last_alloc
    
    
error_alloc:
    mov rax, NULL                 ; putting a null address

last_alloc:
    pop rbp
    ret
    

    ;; void free(void *addr)
    ;; addr -> rdi              ; the address of the page of memory to free
    ;; free: free a block of memory
free:


    ;; void collect()
    ;; collect: simple garbage collector to the heap
collect:
    
    
    
    
