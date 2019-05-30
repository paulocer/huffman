
%include "lib/asm_io.inc"


segment .data
  
  filename db "test.txt", 0
  buflen dw 2048
  vet_count times 128 dd 0
  
segment .bss

	vet_char resb 128
	buffer resb 2048 

segment .text  

%include "src/read_write_file.asm"

    global  _asm_main
		
_asm_main:

    push filename
    push buffer
    push buflen
    call read_file
    add esp, 12
    
	mov ecx, 128
	mov ebx, 0
	
	L1:	
	mov [vet_char + ebx], ebx
	add ebx, 1
	loop L1
	
	mov ecx, 128
	mov ebx, 0
	
	L2:	
	mov al, [vet_char + ebx]
	call print_char
	add ebx, 1
	loop L2
	
	call print_nl 	
    		
    mov esi, buffer    
    cld 
    conta:
    lodsb
        cmp al, 0
        je exit
		
		mov ecx, 128
		mov ebx, 0
		mov edx, 0
				
		L3:
		mov ah, [vet_char + ebx]		
		cmp al, ah
		je encontrou
		add ebx, 1
		add edx, 4
		loop L3				
		
		encontrou:	
        mov ecx, [vet_count + edx]
        inc ecx		
		mov [vet_count + edx], ecx				
		
    jmp conta
	
    exit:
	
	mov ecx, 128
	mov ebx, 0
	
	L4:		
	mov eax, [vet_count + ebx]
	cmp eax, 0
	je imprime
	call print_int
	imprime:
	add ebx, 4
	loop L4
	
    call print_nl 
   
    leave                     
    ret


	





