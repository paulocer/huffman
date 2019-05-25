
;
; file: ordena.asm
; ordena assembly program.
;
; To create executable:
;
; Using Linux and gcc:
; nasm -f elf32 src/ordena.asm
; gcc -m32 -o ordena src/ordena.o lib/driver.c lib/asm_io.o
;
%include "lib/asm_io.inc"
;
; initialized data is put in the .data segment
;
segment .data
;
; These labels refer to strings used for output
;
prompt1 db    "Ordenação de vetores: ", 0       ; don't forget nul terminator
outmsg1 db    "Entrada   : ", 0
outmsg2 db    "Frequência: ", 0
outmsg3 db    "Saída     : ", 0
vet_char		db		"a", "b", "c", "d", "e", "f", "g", "h", "i", "j"
vet_count		dd		 3  , 5  , 6  , 9  , 0  , 1  , 8  , 2  , 7  , 4
num		dd		10
con		dd		4
;
; uninitialized data is put in the .bss segment
;
segment .bss
;
;
;
; code is put in the .text segment
;
segment .text
        global  _asm_main
_asm_main:
        enter   0,0               ; setup routine
        pusha

		call print_nl          ; print new-line -> <<<imprime uma nova linha>>>
		
        mov     eax, prompt1      ; print out prompt
        call    print_string      ; -> <<<imprime o string armazenado no eax - passa o endereço>>>

		call print_nl          ; print new-line -> <<<imprime uma nova linha>>>
		call print_nl          ; print new-line -> <<<imprime uma nova linha>>>
		
;
; next print out result message as series of steps
;
		
		mov		eax, outmsg1
		call	print_string
		
        mov ecx, 10
		mov ebx, 0
		
		lp1:
		mov al, [vet_char + ebx]
		call print_char
		add ebx, 1
		loop lp1

		call print_nl          ; print new-line -> <<<imprime uma nova linha>>>

		mov		eax, outmsg2
		call	print_string
		
		mov ecx, 10
		mov ebx, 0
		
		lp2:
		mov eax, [vet_count + ebx]
		call print_int
		add ebx, 4
		loop lp2
		
		call print_nl          ; print new-line -> <<<imprime uma nova linha>>>

		mov ecx, [num]
		sub ecx, 1
		mov eax, 0
		
		l3:
		mov edx, [vet_count + eax]
		add eax, [con]
		mov ebx, [vet_count + eax]
		cmp edx, ebx
		jge salta
		sub eax, [con]
		mov [vet_count + eax], ebx
		add eax, [con]
		mov [vet_count + eax], edx
		cdq
		idiv dword [con]
		mov dl, [vet_char + eax]
		sub eax, 1
		mov bl, [vet_char + eax]
		mov [vet_char + eax], dl
		add eax, 1
		mov [vet_char + eax], bl
		imul dword [con]
		
		salta:
		loop l3
		
		sub eax, [con]
		cmp eax, 0
		je continua
		
		mov ecx, [num]
		sub ecx, 1
		mov [num], ecx
		mov eax, 0
		
		jmp l3
		
		continua:

		call print_nl          ; print new-line -> <<<imprime uma nova linha>>>

		mov		eax, outmsg3
		call	print_string

        mov ecx, 10
		mov ebx, 0
		
		lp4:
		mov al, [vet_char + ebx]
		call print_char
		add ebx, 1
		loop lp4

		call print_nl          ; print new-line -> <<<imprime uma nova linha>>>

		mov		eax, outmsg2
		call	print_string
		
		mov ecx, 10
		mov ebx, 0
		
		lp5:
		mov eax, [vet_count + ebx]
		call print_int
		add ebx, 4
		loop lp5
		
		call print_nl          ; print new-line -> <<<imprime uma nova linha>>>
		
        popa
        mov al, 0            ; return back to C
        leave                     
        ret
