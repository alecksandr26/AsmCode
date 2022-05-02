    ;;  this is my code that I want to include to my main file
    ;;  we need to put in global the function stat1

    section .data

    section .bss
    
    
    
    section .text
    ;;  Like this 
    global stat1

    
    ;; stat1(int arr, int len, int sum, int ave)
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
