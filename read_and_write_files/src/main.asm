
%include "lib/asm_io.inc"


segment .data
  
  buffer db "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",0 ;Quisque maximus eget est vitae semper. Vestibulum sed lectus eget metus ullamcorper bibendum. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Cras venenatis tortor arcu, ut auctor mi feugiat non. Nulla ullamcorper lacinia rutrum. Sed id tellus posuere, semper tellus ut, pretium magna. Etiam tincidunt luctus tellus, id tristique erat euismod et. Donec quis sagittis enim, tincidunt interdum ligula. Fusce fermentum, enim sed ultrices sollicitudin, leo tellus tristique est, vel accumsan augue nisi non dolor. Nullam interdum imperdiet purus eu volutpat.",0
  vet_count times 128 dd 0
  
segment .bss

	vet_char resb 128

segment .text  

%include "src/read_write_file.asm"

    global  _asm_main
		
_asm_main:
    
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
	call print_int
	add ebx, 4
	loop L4
	
    call print_nl 
   
    leave                     
    ret


	





