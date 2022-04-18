	;; This program will do a function like in c with pure assembly code
	section .data
	EXIT_SUCCESS equ 0
	SYS_exit equ 60
	
	num dd 2
	num2 dd 2

	section .bss
	res resd 1


	section .text
	global _start

sum:							; Fisrt I declare where is going to be that segment of code
	mov eax, dword [num] ; Here We do the sum
	add eax, dword [num2]
	ret							; Here we return from the function
	
	
_start:
	call  sum					; Here I call the function "push rip, jmp sum"
	mov dword [res], eax		; Here I move the result to the rax register

last:	
	mov rax, SYS_exit
	mov rdi, EXIT_SUCCESS
	syscall
