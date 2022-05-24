N = nasm -f elf64
C = ld
BINS = main.o alloc.o 


all: main

alloc.o: alloc.asm
	$(N) alloc.asm

main.o: main.asm
	$(N) main.asm

main: $(BINS)
	$(C) $(BINS) -o main

