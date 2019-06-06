
%include "lib/asm_io.inc"


segment .data
  
 filename db "test2.txt", 0
 buflen dd 2048
 vet_count times 128 dd 0


segment .bss

	buffer resb 2048 
	vet_char resb 128

segment .text  

%include "src/read_write_file.asm"
;	%include "src/ordena.asm"

        global  asm_main
asm_main:
    
    push filename
    push buffer
    push dword [buflen]
    call read_file
    add esp, 12

	mov ecx, 128
	mov ebx, 0
	
	L1:	
	mov [vet_char + ebx], ebx
		mov al, [vet_char + ebx]
		call print_char
		mov al, "-"
		call print_char
		mov eax, ebx
		call print_int
		call print_nl
	add ebx, 1
	loop L1

	mov eax, 0
	mov ebx, 0
	mov ecx, 0
	mov edx, 0
	
	caracter:
    	mov esi, buffer 
    	cld
		conta:
		lodsb
		cmp al, 0
		je armazena
			mov ah, [vet_char + ebx]
			cmp al, ah
			jne pula
		add ecx, 1
		pula:
		jmp conta

		armazena:

		mov [vet_count + edx], ecx
		add ebx, 1
		add edx, 4
		cmp ebx, 128
		je exit
		mov ecx, 0
		jmp caracter

	exit:
	
	mov ecx, 128
	mov ebx, 0
	mov edx, 0
	
	L3:		

		mov al, [vet_char + ebx]
		call print_char
		mov al, "-"
		call print_char
		mov eax, [vet_count + edx]
		call print_int
		call print_nl
		add ebx, 1
		add edx, 4
	loop L3

    call print_nl
	
    leave                     
    ret
