bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fprintf, fclose              ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import fopen msvcrt.dll                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import fprintf msvcrt.dll
import fclose msvcrt.dll

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    filename db "name.txt", 0
    text db "AnA haS 34 aPpLEs!!!", 0
    length equ $-text-1
    mode db "w", 0
    format db "%s", 0
    

; our code starts here
segment code use32 class=code
    start:
        ; A file name and a text (defined in the data segment) are given. The text contains lowercase letters, uppercase letters, digits and special characters. Transform all the uppercase letters from the given text in lowercase. Create a file with the given name and write the generated text to file.
        
        mov esi, text
        mov ecx, length
        
        start_loop:
            mov al, [esi] 
            cmp al,"A"
            jl next
            cmp al,"Z"
            jg next
            
            add al, 0x20
            mov [esi], al
            
            next:
                inc esi
                loop start_loop
        
        push dword mode
        push dword filename
        call [fopen]
        add esp, 4*2
        
        mov ebx, eax
        push dword text
        push dword format
        push ebx
        call [fprintf]
        add esp, 4*3
        
        push ebx
        call [fclose]
        add esp, 4*1
        
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
