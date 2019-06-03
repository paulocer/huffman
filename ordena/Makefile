all: src/ordena.asm
	 nasm -f elf32 src/ordena.asm
	 gcc -m32 -o ordena src/ordena.o lib/driver.c lib/asm_io.o

clean:
	 rm bst
