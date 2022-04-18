    ;;  This is a program that calculate the mean value from a segment of data
    section .data
    EXIT_SUCCESS equ 0
    EXIT_sys equ 60
    
    arr dd 1, 2, 3, 4, 5       ; An array
    len dd 5

    section .bss
    sum resd 1                  ; 4 bytes
    ave resd 1                  ; 4 bytes
    
    section .text
    global _start

    
    ;; stat1(arr, len, sum, ave)
    ;; arr: array of data -> address rdi
    ;; len: The length of the array -> rsi
    ;; sum: The summation of the data -> address rdx
    ;; ave: The average of the data -> address rcx
stat1:
    mov r12, 0                  ; Start the index at 0
    mov rax, 0                  ; To avoid errors
doLoop:
    add eax, dword [rdi + r12 * 4] ; Start the summation
    inc r12                        ; increment the index
    cmp r12, rsi                   ; if (r12 < arr.length) jump doLoop
    jl doLoop

    mov dword [rdx], eax        ; put the result on the direction

    cdq                         ; move eax -> edx:eax
    idiv esi                    ; divide eax = edx:eax / esi
    
    mov dword [rcx], eax        ; Put the result on the direction
    ret                         ; And return 

    
    ;; Lets execute our function
_start:
    mov rdi, arr                ; Move the direction of the arr to rdi
    mov esi, dword [len]        ; Move the len to esi
    mov rdx, sum                ; Put the result direction of the sum
    mov rcx, ave                ; Put the result direction of the average
    call stat1                  ; Now we call the function

last:
    mov rax, EXIT_sys
    mov rdi, EXIT_SUCCESS
    syscall
