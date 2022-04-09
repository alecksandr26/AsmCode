	;;  This is a simple program that do an if and else statment
	section .data
	EXIT_SUCCESS equ 0
	SYS_EXIT equ 60

	;;  Here Is the number that we compare
	num dd 0
	text_true db "Are equal", 10, 0
	text_true_len equ $-text_true
	text_false db "Are not equal", 10, 0
	text_false_len equ $-text_false
	
	section .text
	global _start
	
_start:
	mov rax, 1
	mov rdi, 1
	cmp dword [num], 0x1
	je if_true
	mov rsi, text_false
	mov rdx, text_false_len
	jmp last
	
if_true:
	mov rsi, text_true
	mov rdx, text_true_len
	
last:
	syscall
	mov rax, SYS_EXIT
	mov rdi, EXIT_SUCCESS
	syscall
