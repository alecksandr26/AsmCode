	;; This is a simple program to iterate into the data
	section .data
	EXIT_SUCCESS equ 0
	EXIT_SYS equ 60

	;; These are my variables
	arr dd 10, 4, 5, 6, 1
	len dd 4
	index dd -1
	curr dd 0

	textF db "finish iteration", 10, 0
	textF_len equ $-textF

	textS db "Starting iteration", 10, 0
	textS_len equ $-textS

	section .text
	global _start
	extern printf
	
_start:
	;;  Here we print the iteration
	mov rax, 1
	mov rdi, 1
	mov rsi, textS
	mov rdx, textS_len
	syscall
	
	;;  Here we are going to do the iteration | this is similar to a do while 
sumLoop:
	inc dword [index]		; I increment its value
	mov eax, dword [index]
	mov ebx, dword [len]
	
	mul eax, 4				   ; we need to multiple by 4 because are 4 bytes 
	mov r8d, dword [arr + eax] ; Here we get the current value from the iteration
	cmp eax, ebx
	jl sumLoop 					; if eax < ebx
	
	;;  Now we print a message
	mov rax, 1
	mov rdi, 1
	mov rsi, textF
	mov rdx, textF_len
	syscall

last:
	mov rax, EXIT_SYS
	mov rdi, EXIT_SUCCESS
	syscall
