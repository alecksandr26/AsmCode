; Simple example demonstrating basic stack operations.

section .data
	EXIT_SUCCESS equ 0
	SYS_EXIT equ 60

	numbers dq 121, 122, 123, 124, 125
	len dq 5

section .text
global main
main:
	; Like this basically we can put all the numbers
	mov rcx, qword [len]
	mov rbx, numbers
	mov r12, 0
	mov rax, 0
	; Here we are pussing one byte to the stack lets see 
	push qword [rbx + r12 * 8]

	; To pop back from the stack our data 
	pop rax

; To finish the program 
last:
	mov rax, SYS_EXIT
	mov rdi, EXIT_SUCCESS
	syscall