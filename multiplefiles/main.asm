    ;; This is an example of how we can have multiple files inse of my project
    section .data

    ;;  I define my constants 
    SYS_exit equ 60
    EXIT_SUCCESS equ 0

    ;; My data for the function
    arr dd 1, 2, 3, 4, 5
    len dd 5

    section .bss
    sum resd 1                  ; 4 bytes
    ave resd 1                  ; 4 bytes 

    ;; Here I put the function that I'm going to use I recommend to copi and paste
    ;; the documentation 
    ;; stat1(int arr, int len, int sum, int ave)
    ;; arr: array of data -> address rdi
    ;; len: The length of the array -> rsi
    ;; sum: The summation of the data -> address rdx
    ;; ave: The average of the data -> address rcx
    extern stat1

    section .text
    global _start
    
_start:
    mov rdi, arr                ; I pass the array address
    mov esi, dword [len]        ; I put the the len data
    mov rdx, sum                ; The address of the sum
    mov rcx, ave                ; I pass the address of ave
    call stat1                  ; And I call the function 
    
last:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall

    
