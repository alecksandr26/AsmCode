	;; This program only works for positive integers
	
	section .data
	NULL equ 0
	EXIT_SUCCESS equ 0
	SYS_exit equ 60

	;; Here we are going to put the data
	charNum db "2022",0xa,NULL


	;;  Here we are going to reserve some bytes
	section .bss
	intNum resq 1				; Here is where we are going to stored the value
	numToMul resq 1 			; Here we are going to allocate the number to multiply
	tempNum resq 1				; A simple temp variable to save the current data

	section .text
	global _start

_start:
	;;  First is how long is the string 
	mov rdi, 0					; Here we define our index
	mov qword [numToMul], 1					; The number that we are going to multiply
	mov qword [intNum], 0

	;;  So here we iterate the number
firstLoop:
	mov cl, byte [charNum+rdi]
	cmp ecx, 0xa				; If it is the jump line
	je endFirstloop				; Here we jump to finish to multiply
    cmp rcx, NULL
    je endFirstloop
	mov eax, dword [numToMul]
	mov ebx, 0xa
	mul ebx						; eax * ebx -> eax:edx
	mov dword [numToMul], eax
	mov dword [numToMul+4], edx
	inc rdi						; here increment the index
	jmp firstLoop				; Repeat the cycle
	

endFirstloop:
	;;  Here we need to dived the number
	mov ebx, 10					; We need to have the 10
	mov rax, qword [numToMul] 	; Here we get the number
	div ebx						; so basically rax/ebx -> rax
	mov qword [numToMul], rax	; So again we put the number back
	mov rdi, 0					; Here we initlize the index
	mov rax, 0					; Here we need to reset the rax register
	
	
secondLoop:	
	mov al, byte [charNum+rdi]	; Get the byte of data
	mov ebx, 0xa
	
	cmp eax, ebx				; Here we check if is the jump line
	je last

	sub eax, "0"				; Here we get the original number
	mov ebx, dword [numToMul]	; We bring the number to be mul
	mul ebx						; eax * ebx -> eax:edx
	
	mov dword [tempNum], eax	; Here we move the number to the temp
	mov dword [tempNum + 4], edx
	mov rax, qword [tempNum]	; We take back the temp number
	
	add qword [intNum], rax ; And yeah we just add the result	
	
	mov ebx, 10
	mov rax, qword [numToMul]	; bring again the number to mul
	div ebx						; eax / ebx -> eax
	
	mov qword [numToMul], rax	; move the divide number to his place
	inc rdi						; Here we increment the index
	
	jmp secondLoop				; repeat the cycle
	

last:
	mov rax, SYS_exit
	mov rdi, EXIT_SUCCESS
	syscall
