bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a db 1
    b dw 6
    c dd 10
    d dq 3

; our code starts here
segment code use32 class=code
    start:
        ; 26) (c-d-a)+(b+b)-(c+a)= (10-3-1) + 12 - 11 = 7
        
        mov edx, 0
        
        mov eax, [c]
        cdq
        sub eax , [d]
        sbb edx, [d+4]
        mov ebx, eax
        mov ecx, edx
        mov al, [a]
        cbw
        cwde
        cdq
        sub ebx, eax; in ecx:ebx am prima ()
        sbb ecx, edx
        
        mov ax, [b]
        add ax, [b]
        cwde
        cdq
        adc ebx, eax
        adc ecx, edx ;in ecx:ebx am ()+()
        
        mov al, [a]
        cbw
        cwde
        add [c], eax
        sub ebx, [c]
    
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
