bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global concatenation

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    len_final dd 0 ; length of the final sentence
                   ; will be used so that we can add the characters of the current word 
                   ; at the current position

; our code starts here
segment code use32 class=code
    concatenation:          
        mov ecx, [esp + 4] ; ecx = sentence_index
        mov edi, [esp + 8]; edi = final
        mov esi, [esp + 12]; esi = sentence
        
        add edi, [len_final]
        
        start_loop:
            ;numar spatitiile
            cmp ecx, 0
            je add_loop
            
            lodsb
            cmp al, 32
            jz decrement
            jmp next
            decrement:
                dec ecx
            next:
                jmp start_loop
                
        add_loop:
            lodsb
            cmp al, 32
            je end_loop
            cmp al, 0
            je end_loop
            
            mov [edi], al
            inc edi
            add dword [len_final], 1
            jmp add_loop
            
        end_loop:
            
            mov byte [edi], 32
            add dword [len_final], 2
            ret
            
