N = nasm -f elf64
C = ld
CLANG = clang -no-pie

EXT = main.o
OBJS = alloc.o
BINS = main ctest

all: main ctest

alloc.o: alloc.asm
	$(N) alloc.asm

main.o: test.asm
	$(N) test.asm -o main.o

main: $(EXT) $(OBJS)
	$(C) $(EXT) $(OBJS) -o main

ctest: $(OBJS)
	$(CLANG) -ggdb $(OBJS) test.c

clean:
	rm $(OBJS) $(EXT) $(MAIN) 

