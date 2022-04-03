	;; To compile this program we run these commands
	;; ysam -g dwarf2 -f elf64 file.asm -l output.lst | To create the object file
	;; 
	;; -g dwarf2 is to put the symbols for the debuggin
	;; -f elf64 to speficy to compile in 64 bit
	;; -l to put the output
	;; 
	;; ld -g output.o -o output | To create an executable program
	;; -g to include the debuggin information
	;; -o to put the output file 


	;; This si simple program sum

	;; *****************************************
	;; Here we define the section of data
	
	section .data
	;; To define constants we use the keyword "equ"
	EXIT_SUCCESS equ 0
	SYS_exit equ 60 			; This is id for the system call to exit

	;; To declare normal varibles of bytes we use the keywords
	;; db | 8 bits | byte
	;; dw | 16 bits | word 
	;; dd | 32 bits | double word
	;; dq | 64 bits | quad word
	;; ddq | 128 bits for ingeter | 
	;; dt | 128 bits for float
	
	num dd 10
	num2 dd 12
	res dd 0

	;; ***************************************
	;; Now to define the code section we use this
	section .text
	global _start
_start:

	;; In this part from our code we need to use our registers to be able to do the operation
	;; In this we are going to use just the 32 bits registers
	;; For that reason we need to be speficy how many bits we are going to transfer

	;; With this code we do a simple sum
	
	;; destination, source
	mov eax, dword [num]
	add eax, dword [num2]
	mov dword [res], eax

	;; *****************************
	;; To finish the program we need to do the exit system call
last:	
	mov rax, SYS_exit			; To call the system call
	mov rdi, EXIT_SUCCESS 		; Exit the progrma with success
	syscall						; here we do the call
	
	
	
	


	
