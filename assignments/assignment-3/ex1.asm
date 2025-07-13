bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a db 2
    b dw 4
    c dd 9
    d dq 3

; our code starts here
segment code use32 class=code
    start:
        ; (c-b+a)-(d+a) = 7  - 5 = 2
        
        mov eax, 0
        mov ebx, 0
        mov ecx, 0
        mov edx, 0
        
       
        mov ax, [b]
        cwde
        sub [c], eax
        mov al, [a]
        cbw
        cwde
        add [c], eax ;prima () in c
        
       
        add [d], eax
        adc [d+4], edx
      
        mov eax, [c]
        cdq
         
        sub eax, [d]
        sbb edx, [d+4]
       
        
        
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
