
;
; file: ordena.asm
; ordena assembly program.
;
; To create executable:
;
; Using Linux and gcc:
; nasm -f elf ordena.asm
; gcc -o ordena ordena.o driver.c asm_io.o
;
%include "asm_io.inc"
;
; initialized data is put in the .data segment
;
segment .data
;
; These labels refer to strings used for output
;
prompt1 db    "Entre com uma sequencia de 10 caracteres: ", 0       ; don't forget nul terminator
outmsg1 db    "Entrada: ", 0
outmsg2 db    "Saida: ", 0

;
; uninitialized data is put in the .bss segment
;
segment .bss
;
		num  resb 1
		v1   resb 10
		v2   resb 10
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

        mov ecx, 10
		mov ebx, 0

		lp1:
		call read_char
		mov [v1 + ebx], al
		add ebx, 1
		loop lp1

		call print_nl          ; print new-line -> <<<imprime uma nova linha>>>
		
;
; next print out result message as series of steps
;
		
		mov		eax, outmsg1
		call	print_string
		
;       mov ecx, 10
;		mov ebx, 0
		
;		lp2:
;		mov al, [v2 + ebx]
;		call print_char
;		add ebx, 1
;		loop lp2

;		call print_nl          ; print new-line -> <<<imprime uma nova linha>>>
		
		mov esi, v1
		mov edi, v2
		mov ecx, 10
		cld
		
		duplica:
		movsb
		loop duplica
		
		mov ecx, 10
		mov edx, 0
		
		L1:
		mov al, [v2 + edx]
		add edx, 1
		mov bl, [v2 + edx]
		cmp al, bl
		jge salta
		sub edx, 1
		mov [v2 + edx], bl
		add edx, 1
		mov [v2 + edx], al
		salta:
		loop L1
		
		sub edx, 1
		cmp edx, 0
		je continua
		
		mov ecx, edx
		mov edx, 0
		
		jmp L1
		
		continua:

        mov ecx, 10
		mov ebx, 0
		
		mov		eax, outmsg2
		call	print_string

		lp3:
		mov al, [v2 + ebx]
		call print_char
		add ebx, 1
		loop lp3

		call print_nl          ; print new-line -> <<<imprime uma nova linha>>>
		
        popa
        mov al, 0            ; return back to C
        leave                     
        ret
