
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
v1		db		"a", "b", "c", "d", "e", "f", "g", "h", "i", "j"
v2		dd		 1  , 2  , 3  , 4  , 5  , 6  , 7  , 8  , 9  , 0
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
		mov al, [v1 + ebx]
		call print_char
		add ebx, 1
		loop lp1

		call print_nl          ; print new-line -> <<<imprime uma nova linha>>>

		mov		eax, outmsg2
		call	print_string
		
		mov ecx, 10
		mov ebx, 0
		
		lp2:
		mov eax, [v2 + ebx]
		call print_int
		add ebx, 4
		loop lp2
		
		call print_nl          ; print new-line -> <<<imprime uma nova linha>>>

		mov ecx, [num]
		sub ecx, 1
		mov eax, 0
		
		l3:
		mov edx, [v2 + eax]
		add eax, [con]
		mov ebx, [v2 + eax]
		cmp edx, ebx
		jge salta
		sub eax, [con]
		mov [v2 + eax], ebx
		add eax, [con]
		mov [v2 + eax], edx
		cdq
		idiv dword [con]
		mov dl, [v1 + eax]
		sub eax, 1
		mov bl, [v1 + eax]
		mov [v1 + eax], dl
		add eax, 1
		mov [v1 + eax], bl
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
		mov al, [v1 + ebx]
		call print_char
		add ebx, 1
		loop lp4

		call print_nl          ; print new-line -> <<<imprime uma nova linha>>>

		mov		eax, outmsg2
		call	print_string
		
		mov ecx, 10
		mov ebx, 0
		
		lp5:
		mov eax, [v2 + ebx]
		call print_int
		add ebx, 4
		loop lp5
		
		call print_nl          ; print new-line -> <<<imprime uma nova linha>>>
		
        popa
        mov al, 0            ; return back to C
        leave                     
        ret
