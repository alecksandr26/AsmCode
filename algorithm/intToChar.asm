	;;  This is an small program to convert integer to char	
	section .data
	NULL equ 0
	EXIT_SUCCESS equ 0
	SYS_exit equ 60

	;;  Define data
	intNum dd 255				; double word 32 - bit
	

	;;  Here I reserve these bytes 
	section .bss
	strNum resb 10				; These are my bytes

	section .text
	global _start
	
_start:
	mov eax, dword [intNum]		; get the integer
	mov rcx, 0					; digit count = 0
	mov ebx, 10					; set for dividing by 10

	;;  This is the first part of the algorithm 
divideLoop:
	mov edx, 0					; Here is where the result will be allocate 
	div ebx						; divide number by 10
	
	push rdx					; and catch the remainder
	inc rcx						; incremenet the digit count
	
	cmp eax, 0					; if (result > 0)
	jne divideLoop				; we divide again

	;;  Now we need to convert the remainders and store

	mov rbx, strNum				; Here we get th pointer
	mov rdi, 0					; idx = 0 of the string

popLoop:
	pop rax						; Here we get the index
	add al, "0"					; '0' = 48 | int + '0' == char number
	mov byte [rbx+rdi], al		; Here we move the character byte 
	inc rdi						; increment the index
	loop popLoop				; do the loop while (rcx > 0)

	mov byte [rbx+rdi], NULL			; To define the end of the line
	
	;; With this we done
	
last:
	mov rax, SYS_exit
	mov rdi, EXIT_SUCCESS
	syscall
	
	
	


	
