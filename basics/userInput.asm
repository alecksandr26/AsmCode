	;;  The data that we are using
	section .data
	text1 db "What is your name?: "
	text1_len equ $-text1
	text2 db "Hello, "
	text2_len equ $-text2

	;; To receive data from the user we need to reserve data
	;; How easy we work in this new section
	section .bss
	name resb 16				; Here we are going to reserve 16 bytes
	

	section .text
	global _start
	
	
_start:
	;; To create this program we need to program a subroutines like this for exmpale
	call _printText1 			; When we use call basically we call a subroutine
	call _getName
	call _printText2
	call _printName

last:
	mov rax, 60
	mov rdi, 0 					; To finish in okay
	syscall

	;;  This is the subroutine to print the first text
_printText1:
	mov rax, 1
	mov rdi, 1
	mov rsi, text1
	mov rdx, text1_len
	syscall 					; Basically a simple print sys call
	ret 						; With this keyword we come back from a subroutine


	;; To prin the text number 2
_printText2:
	mov rax, 1
	mov rdi, 1
	mov rsi, text2
	mov rdx, text2_len
	syscall
	ret

	;;  To receive the input from a user is too easy actually
_getName:
	mov rax, 0					; Here we use the id 0 to receive the use input
	mov rdi, 0					; the stdinput "0"
	mov rsi, name				; Now basically we put the area where we want to store the data
	mov rdx, 16					; The size of bytes that we want to read
	syscall
	ret

	;; To print the data is the same thing that we already see 
_printName:
	mov rax, 1
	mov rdi, 1
	mov rsi, name
	mov rdx, 16
	syscall
	ret
