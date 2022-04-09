	;;  This is code example of a while loop

	section .data

	EXIT_SUCCESS equ 0
	SYS_EXIT equ 60
	
	maxN dd 30
	ite dd 0
	
	section .text
	global _start
	
_start:
startLoop:
	;;  This is the a loop is like a while
	mov eax, dword [ite]
	mov ebx, dword [maxN]
	cmp eax, ebx
	jge endLoop					; if eax >= ebx jump endLoop
	inc dword [ite]
	jmp startLoop
	
endLoop:
	;;  Finish the program
	mov rax, SYS_EXIT
	mov rdi, EXIT_SUCCESS
	syscall
