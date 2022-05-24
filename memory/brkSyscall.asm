    ;; This is an program example to know how to create
    ;; memory frames from the heap we use the brk syscall
    ;; this syscall returns a new address frame if success
    ;; otherwise return the current address if don't success
    ;; the syscall brk is not the same from brk function at c 
    
    section .data
    ;; my constatns
    
    SYS_exit equ 60
    EXIT_SUCCESS equ 0
    EXIT_FAILURE equ 1

    NULL equ 0x0
    LF equ 0xa

    ;; my variables

    ;; the brk address always it is going to start at 0x0 address
    initial_break dq NULL
    current_break dq NULL
    
    SYS_brk equ 12
    
    
    section .bss
    
    section .text
    global _start
_start:
    ;; As it says, the brk() system call returns current break address
    ;; if failed. If success, brk() returns new break address

    ;; get the current address
    mov rax, SYS_brk
    mov rdi, 0                  ; invalid address
    syscall
    mov qword [current_break], rax ; get the address
    mov qword [initial_break], rax ; get the address

    ;; from this address we can allocate memory
    ;; how ??? easy, just do again the syscall
    mov rax, SYS_brk
    mov rdi, [current_break]    ; put like argument the new address
    add rdi, 8                  ; move the address 8 bytes
    syscall

    
    ;; allocate just a simple number
    mov qword [current_break], 10 ; putting a 10 value
    
    ;; now we have a frame
    mov qword [current_break], rax ; update the current break

    ;; now to free that memory we need to run again the syscall brk
    mov rax, SYS_brk
    mov rdi, qword [current_break] ; move the break
    sub rdi, 8                     ; move the address 8 bytes down
    syscall                        ; do the syscall
    ;; now we free the memory

    mov qword [current_break], rax ; assign again the current break

last:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall
