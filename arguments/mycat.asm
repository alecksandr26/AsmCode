    ;; My Simple program like cat program
    section .data
    
    ;; my contants 
    SYS_exit equ 60
    EXIT_SUCCESS equ 0
    EXIT_FAILURE equ 1
    
    LF equ 0xa
    NULL equ 0x0
    EOF equ -1
    
    SYS_write equ 1
    STDOUT equ 1
    
    SYS_read equ 0
    STDIN equ 0

    SYS_open equ 2
    O_RDONLY equ 0

    SYS_close equ 3

    SYS_lseek equ 8

    BUF_SIZE equ 1024

    ;; my variables
    errorArgMsg db "Error: Just need one file", LF, NULL
    errorFileMsg db "Error: Error opening the file", LF, NULL
    
    
    section .bss
    char resb 1024                 ; my buffer

    section .text
    global _start

    ;; reloadBuffer: Reset the buffer
    ;; void reloadBuffer()
reloadBuffer:
    push rbx
    mov rbx, 0
    
reloadLoop:
    cmp rbx, BUF_SIZE
    je reloadDone
    mov byte [char + rbx], 0x0  ; I set the byte as zero
    inc rbx
    jmp reloadLoop
    
reloadDone:
    pop rbx                     ; I get the rbx
    ret
    
    ;; printString: just prints a line of characters
    ;; void printString(char *str)
    ;; str = address -> rdi
printString:
    push rdx                    ; First I save this register
    mov rdx, 0x0

strLoop:                        ; starts the loop to know how many strings
    cmp byte [rdi + rdx], LF
    je strDone
    inc rdx
    jmp strLoop
    
strDone:                        ; finish the loop and print the line
    inc rdx                     ; to get the new line
    mov rax, SYS_write
    mov rsi, rdi
    mov rdi, STDOUT
    syscall                     ; And print the string
    pop rdx
    ret                         ; Finish executing the function


    ;; printFile: print each line of the file
    ;; void printFile(char *filename)
    ;; filename = address -> rdi
printFile:
    push rbp
    mov rbp, rsp                ; create a frame of memory to allocate each line

    ;; first open the file 
    mov rax, SYS_open           ; Already have the rdi value
    mov rsi, O_RDONLY
    syscall
    
    cmp rax, -2                ; If there is an error
    jne startReading
    mov rdi, errorFileMsg
    call printString
    
    mov rax, SYS_exit
    mov rdi, EXIT_FAILURE       ; exit with failure
    syscall
    
startReading:
    mov r10, rax                ; move the file descriptor
    mov rdx, BUF_SIZE           ; the buffer size
    
    
loopReading:    
    ;; first we need to know the amount of characters
    mov rax, SYS_read           ; move the read
    mov rdi, r10                ; the file descriptor
    mov rsi, char               ; give the address
    syscall                     ; do the syscall
    
    cmp rax, 0x0
    jl closeFile
    
    cmp byte [char], 0x0             ; if (rax < 0)
    je closeFile              ; jump 
    
    mov rax, SYS_write          ; write
    mov rdi, STDOUT
    mov rsi, char
    syscall
    
    
    cmp rax, 0x0                ; If something come wrong
    jl closeFile                ; if (rax < 0)

    ;; after printing I reload the buffer
    call reloadBuffer

    jmp loopReading
    
closeFile:
    mov rax, SYS_close          ; close the file
    mov rdi, r10                ; put the file descriptor
    syscall
        
    pop rbp                     ; finish the execution of the fuction
    ret
    
    
_start:
    ;; get the address of the arguments
    cmp qword [rsp], 0x2
    je notErrorArgs
    mov rdi, errorArgMsg
    call printString
    mov rax, SYS_exit
    mov rdi, EXIT_FAILURE
    syscall
    
notErrorArgs:                   ; there wasn't errors we read the argument
    mov rdi, rsp   ; read the first
    add rdi, 16
    mov rdi, qword [rdi]        ; gettint the name of file
    call printFile              ; just print the file

        
last:                           ; close the program
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall
