	;;  This is a little more complex code
	section .data
	
	EXIT_SUCCESS equ 0
	SYS_EXIT equ 60
	
	TRUE equ 1
	FALSE equ 0
	x dw 0
	y dw 0
	ans dw 0
	errFlg db FALSE				; one byte

	section .text
	global _start
	
_start: 						; So here is the code
	cmp dword [x], 0
	je doElse
	mov eax, dword [x]
	cdq							; convert dword of eax into a quad word eax:edx
	idiv dword [y]				; signed division eax = edx:eax / dword [y]
	mov dword [ans], eax		; now we move the answer
	mov byte [errFlg], FALSE 	; we put the err flag into false
	jmp skipElse

	;;  This is the else code
doElse:
	mov dword [ans], 0
	mov byte [errFlg], TRUE

skipElse:
	mov rax, SYS_EXIT
	mov rdi, EXIT_SUCCESS
	syscall
	
