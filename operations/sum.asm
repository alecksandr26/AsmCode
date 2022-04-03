	;; This program show how to suma simple number of 1 digit

	section .data
	res db 0 					; we only need one byte

	message db "Your number is: "
	message_len equ $-message

	newLine db 10
	
	section .text
	global _start
	
_start:
	mov al, 4					; here we start with | 4
	add al, 1 					; here we add | 8
	add al, 48					; here we sun the 48 to move to the number
	mov byte [res], al			; here we save the operation in the res
	call _getOutput
	

	
last:
	mov rax, 60
	mov rdi, 0
	syscall

_getOutput:
	mov rax, 1					; First we print the message
	mov rdi, 1
	mov rsi, message
	mov rdx, message_len
	syscall

	mov rax, 1					; After that we print the number
	mov rdi, 1
	mov rsi, res
	mov rdx, 1
	syscall

	mov rax, 1 					; The jump line of 
	mov rdi, 1
	mov rsi, newLine
	mov rdx, 1
	syscall
	ret

	

	
