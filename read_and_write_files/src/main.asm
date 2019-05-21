
%include "lib/asm_io.inc"


segment .data
  
  filename db "test.txt", 0
  buflen dw 2048
  buffer db "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque maximus eget est vitae semper. Vestibulum sed lectus eget metus ullamcorper bibendum. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Cras venenatis tortor arcu, ut auctor mi feugiat non. Nulla ullamcorper lacinia rutrum. Sed id tellus posuere, semper tellus ut, pretium magna. Etiam tincidunt luctus tellus, id tristique erat euismod et. Donec quis sagittis enim, tincidunt interdum ligula. Fusce fermentum, enim sed ultrices sollicitudin, leo tellus tristique est, vel accumsan augue nisi non dolor. Nullam interdum imperdiet purus eu volutpat.",0
  vet_count times 128 dd 0
  
segment .bss

;   buffer resb 2048 
	vet_char resb 128

segment .text  

%include "src/read_write_file.asm"

        global  _asm_main
		
_asm_main:
    
    ;push filename
    ;push buffer
    ;push buflen
    ;call read_file
    ;add esp, 12
	
	mov ecx, 128
	mov ebx, 0
	
	l1:
	
	mov [vet_char + ebx], ebx
	add ebx, 1
	loop l1
    
    mov esi, vet_char
    cld 
    print:
    lodsb
        ;cmp al, 0
        je exit
		;movzx eax, al
		;push eax
		;push vet_char
		;push vet_count
		;call contabiliza
		;add esp, 12
        call print_char
    jmp print
    exit:
    call print_nl 
   
    leave                     
    ret

contabiliza:
	push ebp
	mov ebp, esp
	
	mov ebx, [ebp + 16]
	mov edi, [ebp + 12]
	mov esi, [ebp + 8]
	





