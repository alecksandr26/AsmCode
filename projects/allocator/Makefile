N = nasm -f elf64
C = ld
BINS = test.o alloc.o 


all: main

alloc.o: alloc.asm
	$(N) alloc.asm

test.o: test.asm
	$(N) test.asm

main: $(BINS)
	$(C) $(BINS) -o main

clean:
	rm $(BINS) main

