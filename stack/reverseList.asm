	;; This is a program that reverse a a list into a stack
	section .data
	
	EXIT_SUCCESS equ 0
	SYS_EXIT equ 60

	;;  Define Data.
	arr dd 121, 122, 123, 124, 125
	len dd 5
	
	section .text
	global _start
_start:
	mov eax, 0
	mov ebx, dword [len]
pushLoop:						; This is like a while loop
	cmp eax, ebx
	jge endPushLoop				; if eax >= ebx jump endLoop
	mov ecx, dword [arr + eax * 4]
	push rcx
	inc eax
	jmp pushLoop
endPushLoop:
	mov eax, 0 					; I put again eax to zero

popLoop:
	cmp eax, ebx
	jge endPopLoop
	pop rcx
	mov dword [arr + eax * 4], ecx ; Here I put again the data to the same space of memory
	inc eax
	jmp popLoop
endPopLoop:	
	

last:
	mov rax, SYS_EXIT
	mov rdi, SYS_EXIT
	syscall
	
	
