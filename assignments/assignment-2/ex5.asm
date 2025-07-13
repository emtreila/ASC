bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    b db 1
    c db 2
    e dw 5h
    g dw 5h

; our code starts here
segment code use32 class=code
    start:
        ; 26. (e+g-2*b)/c
        mov ebx, 0 
        mov eax, 0
        mov dx, 0
        
        mov bx, [e]
        add bx, [g]

        mov al, [b]
        mov cl, 2
        mul cl
        sub ebx, eax
        
        mov eax, ebx
        mov bl, [c]
        div bx
       
        
        
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
