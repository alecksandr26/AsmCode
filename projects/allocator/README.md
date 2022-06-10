# Allocator
This is my version of malloc in nasm, I decided to use the heap data structure.

## Compiling
To compiled and generate the `alloc.o` just run.
```
make
```
## For testing
I write a `main.asm` program which test a little bit the behaivor of the alloc function
## How works
Basically I move the brk address or break address 8 kilo bytes upper, to create an array where I use it to create heap, with that implementation I accomplish a runtime of `o(logn)` when `free` function gets executed.
