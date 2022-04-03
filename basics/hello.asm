


	section .data
	text db "Hello, World!", 10, 0
	text_len equ $-text

	section .text
	global _main
	
_main:
	mov rax, 1
	mov rdi, 1
	mov rsi, text
	mov rdx, text_len
	syscall

	mov rax, 60 				; To finish the program
	mov rdi, 0					; To send 0 signal
	syscall

	
