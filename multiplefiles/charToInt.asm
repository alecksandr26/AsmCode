    ;; So inside of this program I'm going to create
    ;; A function that converts string to integer
    section .data
    NULL equ 0
    LF equ 0xa

    
    section .text
    ;; This is how is going to be my function
    global charToInt

    ;;  It returns the int value from the string
    ;; int charToInt(char *string)
    ;; string: is the address for the characters to rdi
    ;; and return the number into the rax register 
charToInt:
    push rbp
    mov rbp, rsp
    sub rsp, 24                 ; We need like 24 bytes for the variables
    mov r9, rdi                 ; I move the address to r9 register
    mov rdi, 0                  ; I put the rdi register as the index
    mov qword [rbp - 8], 1     ; The number that will be multiply
    mov qword [rbp - 16 ], 0   ; Where we are going to store the result

    ;; So here we calculate the amount of the number
firstLoop:  
	mov cl, byte [r9+rdi]       ; I get one byte
	cmp ecx, LF				; If it is the jump line jump
	je endFirstloop				; Here we jump to finish to multiply
    cmp rcx, NULL           ; Or if it is the NULL character jump 
    je endFirstloop
	mov eax, dword [rbp - 8]
	mov ebx, 0xa
	mul ebx						; eax * ebx -> eax:edx
	mov dword [rbp - 8], eax
	mov dword [rbp - 4], edx
	inc rdi						; here increment the index
	jmp firstLoop				; Repeat the cycle
    
    
endFirstloop:
	;;  Here we need to dived the number
	mov ebx, 10					; We need to have the 10
	mov rax, qword [rbp - 8] 	; Here we get the number
	div ebx						; so basically rax/ebx -> rax
	mov qword [rbp - 8], rax	; So again we put the number back
	mov rdi, 0					; Here we initlize the index
	mov rax, 0					; Here we need to reset the rax register
    
secondLoop:	
	mov al, byte [r9+rdi]	; Get the byte of data
	
	cmp eax, LF				; Here we check if is the jump line
	je endSecondLoop
    cmp eax, NULL               ; Also check if it is not the null character
    je endSecondLoop

	sub eax, "0"				; Here we get the original number
	mov ebx, dword [rbp - 8]	; We bring the number to be mul
	mul ebx						; eax * ebx -> eax:edx
	
	mov dword [rbp - 24], eax	; Here we move the number to the temp
	mov dword [rbp - 20], edx
	mov rax, qword [rbp - 24]	; We take back the temp number
	
	add qword [rbp - 16], rax ; And yeah we just add the result	
	
	mov ebx, 10
	mov rax, qword [rbp - 8]	; bring again the number to mul
	div ebx						; eax / ebx -> eax
	
	mov qword [rbp - 8], rax	; move the divide number to his place
	inc rdi						; Here we increment the index
	
	jmp secondLoop				; repeat the cycle

    
endSecondLoop:               ; Here we just return from the function
    mov rax, qword [rbp - 16]  ; I take back the result to the return value 
    add rsp, 24
    pop rbp
    ret
