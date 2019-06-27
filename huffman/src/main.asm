
%include "lib/asm_io.inc"


segment .data
  
	filename db "test2.txt", 0
	buflen dd 2048
	vet_count times 128 dd 0
	vet_nodes times 128 dd 0
	num		dd		128
	con		dd		4
    debug_msg1 db "===== DEBUG ====", 0
    debug_msg2 db "AQUI",10, 0
    debug_msg3 db "Memory: ", 0

segment .bss

	buffer resb 2048 
	vet_char resb 128
    tree resd 1
    num_nodes resd 1

segment .text  

%include "src/read_write_file.asm"
%include "src/binary_search_tree.asm"

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
	mov [vet_char + ebx], ebx ; Cria o vetor com os 128 caracteres
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
		add ecx, 1 ; Conta a quantidade de ocorrências do caracter
		pula:
		jmp conta

		armazena:

		mov [vet_count + edx], ecx ; Armazena a quantidade de ocorrências do caracter
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
	
;	Ordena os dois vetores da maior frequência para a menor

		mov ecx, [num]
		sub ecx, 1
		mov eax, 0
		
		L2:
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
		loop L2
		
		sub eax, [con]
		cmp eax, 0
		je continua
		
		mov ecx, [num]
		sub ecx, 1
		mov [num], ecx
		mov eax, 0
		
		jmp L2
		
		continua:

        mov ecx, 128
		mov edx, 0
		mov ebx, 0
		
		L3:		

		call create_node
		mov edi, eax

		mov eax, [vet_count + edx]
		cmp eax, 0
		je fim_do_vetor
;		call print_int

		mov [edi - 4], eax
		
;		mov al, "-"
;		call print_char
		mov al, [vet_char + ebx]
		mov [edi - 5], al ; insere caracter no nó
		mov dword [edi - 9], 0 ; filho direito
		mov dword [edi - 13], 0 ; filho esquerdo
;		call print_char
;		call print_nl
		
		mov [vet_nodes + edx], edi

		add ebx, 1
		add edx, 4
		
		loop L3
		
		fim_do_vetor:

		sub edx, 4 ; última posição do nó
		cmp edx, 0
		je final
		
		mov ecx, 0
		L4:
		mov edi, [vet_nodes + ecx]
		mov eax, [edi - 4]
		call print_int
		mov al, "-"
		call print_char
		mov al, [edi - 5]
		call print_char
		call print_nl
		add ecx, 4
		cmp ecx, edx
		jg monta_arvore
		jmp L4
		
		monta_arvore:
		
		cmp edx, 0
		je final
		
		call create_node
		mov edi, eax

		mov esi, [vet_nodes + edx]
		mov ecx, [esi - 4]
		mov [edi - 13], esi; filho esquerdo
		mov dword [vet_nodes + edx], 0
		sub edx, 4
		mov esi, [vet_nodes + edx]
		add ecx, [esi - 4]
		mov [edi - 9], esi; filho direita
		mov bl, ""
		mov [edi - 5], bl ; insere caracter vazio no nó
		mov [edi - 4], ecx ; frequencia do nó
		mov [vet_nodes + edx], edi
		
		cmp edx, 0
		je final
		
		push edx
		reordena:
		cmp edx, 0
		je finaliza
		sub edx, 4
		mov esi, [vet_nodes + edx]
		cmp eax, [esi - 4]
		jle finaliza
		mov ebx, esi
		mov esi, edi
		mov edi, ebx
		jmp reordena
		finaliza:
		pop edx
		
		jmp monta_arvore
		final:

		mov ecx, 0
		L5:
		mov edi, [vet_nodes + ecx]
		mov eax, [edi - 4]
		call print_int
		mov al, "-"
		call print_char
		mov al, [edi - 5]
		call print_char
		call print_nl
		add ecx, 4
		cmp ecx, edx
		jg final2
		jmp L5
		final2:
		push dword [vet_nodes]
		call print_pre_order2
		add esp,4

leave                     
    ret
	
print_pre_order2:
    push ebp
    mov ebp, esp
    pusha
    pushf
        mov edi, [ebp + 8] ;tree_address

        cmp edi, 0
        je dont_print2
            mov eax, [edi - 4]
            call print_int
            mov al, '-'
            call print_char
			mov al, [edi - 5]
            call print_char
			mov al, '/'
            call print_char
            push dword [edi - 13]
            call print_pre_order2
            add esp, 4
            
            push dword [edi - 9]
            call print_pre_order2
            add esp, 4
            
        dont_print2:
    popf
    popa
    pop ebp
ret