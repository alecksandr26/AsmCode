	;; This a program where we try to create a list into the stack of numbers of 4 bytes
	section .data
	EXIT_SUCCESS equ 0
	SYS_EXIT equ 60
	
	nums dd 102, 103, 104, 105, 106
	len dd 5n
	
	section .text
	global _start
_start:
	push rbp
	mov rbp, rsp
	sub rsp, 24

	;;  Here we prepare for the loop
	mov eax, 0
	mov ebx, dword [len]
	mov dword [rbp - 4], 0		; Here I'm going to create a sum variable
pushLoop:
	cmp eax, ebx
	jge endPushLoop
	mov r8d, dword [nums + rax * 4] ; First I get the data 
	mov dword [rbp + rax * 4 - 24], r8d ; I put the data into the stack
	add dword [rbp - 4], r8d			; And I make the sum
	inc eax
	jmp pushLoop
endPushLoop:
	mov rsp, rbp
	pop rbp

last:
	mov rax, SYS_EXIT
	mov rdi, EXIT_SUCCESS
	syscall
	
	


	
