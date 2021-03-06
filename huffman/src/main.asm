
%include "lib/asm_io.inc"


segment .data
  
	filename db "test2.txt", 0
	buflen dd 2048
	vet_count times 128 dd 0
	vet_nodes times 128 dd 0
	num		dd		128
	con		dd		4
	dic		dd		0
    debug_msg1 db "===== DEBUG ====", 0
    debug_msg2 db "AQUI",10, 0
    debug_msg3 db "Memory: ", 0

segment .bss

	buffer resb 2048 
	vet_char resb 128
	dic_huff resb 128
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

        call imprime_vetor
		
		mov ecx, 128
		mov edx, 0
		mov ebx, 0
		
		L3:		

		call create_node
		mov edi, eax
		mov eax, edx

		mov eax, [vet_count + edx]
		cmp eax, 0
		je fim_do_vetor

		mov [edi - 4], eax
		
		mov al, [vet_char + ebx]
		mov [edi - 5], al ; insere caracter no nó
		mov dword [edi - 9], 0 ; filho direito
		mov dword [edi - 13], 0 ; filho esquerdo
		
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
		mov edi, [vet_nodes + edx]
		mov eax, [edi - 4]
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
		mov [edi - 9], esi; filho esquerdo
		mov dword [vet_nodes + edx], 0
		sub edx, 4
		mov esi, [vet_nodes + edx]
		add ecx, [esi - 4]
		mov [edi - 13], esi; filho direita
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
		cmp ecx, [esi - 4]
		jle finaliza
		mov ebx, esi
		add edx, 4
		mov ebx, [vet_nodes + edx]
		mov [vet_nodes + edx], esi
		sub edx, 4
		mov [vet_nodes + edx], ebx
		jmp reordena
		finaliza:
		pop edx

		push ecx
		mov ecx, 0
		imprime1:
		mov esi, [vet_nodes + ecx]
		mov eax, [esi - 4]
		add ecx, 4
		cmp edx, ecx
		jge imprime1
		pop ecx
		call print_nl
		

		jmp monta_arvore
		final:

		mov ecx, 0
		L5:
		mov edi, [vet_nodes + ecx]
		mov eax, [edi - 4]
		add ecx, 4
		cmp ecx, edx
		jg final2
		jmp L5
		final2:
		mov ecx, 0
		push edx
		push dword [vet_nodes]
		mov edx, 0
		mov ebx, 0
		call ler_em_pre_ordem
		add esp, 8
		call print_nl
		mov eax, [dic]
		cdq
		idiv dword [con]
		mov [con], eax
		mov ecx, [con]
		mov ebx, 0

		L6:
		call imprime_dic
		add ebx, 4
		loop L6
		
		call print_nl
		mov ecx, [con]
		mov ebx, 0
		
		L7:
		call imprime_cod
		add ebx, 4
		loop L7
		
		L8:
    	call print_nl
		mov esi, buffer 
    	cld
		codifica:
		lodsb
		cmp al, 0
		je sair
			mov ebx, 0
			mov ecx, [con]
			pesquisa:
			mov edi, [dic_huff + ebx]
			cmp al, [edi - 1]
			je imp_comprimido
			add ebx, 4
			loop pesquisa
			jmp codifica
			imp_comprimido:
			call comprime
			jmp codifica
		sair:
		call print_nl
		call print_nl
				
leave                     
    ret
	
ler_em_pre_ordem:
    push ebp
    mov ebp, esp
    pusha
    pushf
        mov edi, [ebp + 8] ;endereço da árvore
        cmp edi, 0
        je nao_imprime
			mov al, [edi - 5]
			cmp al, ""
			je proximo_no
			mov eax, [edi - 4]
			call print_int
			call cria_no_char
			push esi
			mov esi, eax
            mov al, '-'
            call print_char
			mov al, [edi - 5]
			mov [esi - 1], al
            call print_char
            mov al, '-'
            call print_char
			mov eax, ecx
			mov [esi - 5], ecx
			call print_int
            mov al, '-'
            call print_char
			mov [esi - 9], edx
			mov ebx, [dic]
			mov [dic_huff + ebx], esi
			add ebx, 4
			mov [dic], ebx
			pop esi
			
			mov ebx, edx
			mov ecx, 32
			bit_a_bit:
			mov eax, 0
			shl ebx, 1
			jnc print3 ; impŕime '0'
			mov eax, 1 ; imprime '1'
			print3:
			call print_int
			loop bit_a_bit
			call print_nl
			
			proximo_no:
            push dword [edi - 13]; no da esquerda
			shl edx, 1
			add ecx, 1
            call ler_em_pre_ordem; lê o no da esquerda
			sub ecx, 1
			shr edx, 1
            add esp, 4
            
            push dword [edi - 9]; no da direita
			shl edx, 1
			add ecx, 1
			or edx, 0000000000000000000000000000001b
            call ler_em_pre_ordem; lê o no da direita
			sub ecx, 1
			shr edx, 1
            add esp, 4
            
        nao_imprime:
    popf
    popa
    pop ebp
ret

cria_no_char:
    push ebp
    mov ebp, esp
    
    push ebx    
    mov	eax, 45		; sys_brk
	xor	ebx, ebx
	int	80h

	add	eax, 9		; reserve 9 bytes
	mov	ebx, eax
	mov	eax, 45		; sys_brk
	int	80h
    pop ebx
    pop ebp 
ret

imprime_dic:
	mov esi, [dic_huff + ebx]
	mov al, [esi - 1]
	call print_char
	mov al, '-'
	call print_char
	mov eax, [esi - 5]
	call print_int
	mov al, '-'
	call print_char
	mov edx, [esi - 9]
	push ecx
	mov ecx, 32
	verifica_bit:
	mov eax, 0
	shl edx, 1
	jnc imprime ; impŕime '0'
	mov eax, 1 ; imprime '1'
	imprime:
	call print_int
	loop verifica_bit
	pop ecx
	call print_nl
ret

imprime_cod:
	mov esi, [dic_huff + ebx]
	mov al, [esi - 1]
	call print_char
	mov al, '-'
	call print_char
	mov eax, [esi - 5]
	call print_int
	mov al, '-'
	call print_char
	mov edx, [esi - 9]
	push ecx
	mov ecx, 32
	sub ecx, [esi - 5]
	cmp ecx, 0
	je coda_bit
	shl edx, cl
	mov ecx, [esi - 5]
	coda_bit:
	mov eax, 0
	shl edx, 1
	jnc coda ; impŕime '0'
	mov eax, 1 ; imprime '1'
	coda:
	call print_int
	loop coda_bit
	pop ecx
	call print_nl
ret

comprime:
	mov edx, [edi - 9]
	push edx
	push ecx
	mov ecx, 32
	sub ecx, [edi - 5]
	cmp ecx, 0
	je imp_huffman
	shl edx, cl
	mov ecx, [edi - 5]
	imp_huffman:
	mov eax, 0
	shl edx, 1
	jnc cod_huffman ; impŕime '0'
	mov eax, 1 ; imprime '1'
	cod_huffman:
	call print_int
	loop imp_huffman
	pop ecx
	pop edx
ret

imprime_vetor:
		mov ecx, 128
		sub ecx, 1
		mov ebx, 0
		mov edx, 0
		
		lista:
		mov eax, [vet_count + edx]
		cmp eax, 0
		je nao_imp
		mov al, [vet_char + ebx]
		call print_char
		mov al, "-"
		call print_char
		mov eax, [vet_count + edx]
		call print_int
		call print_nl
		nao_imp:
		add ebx, 1
		add edx, 4
		loop lista
ret