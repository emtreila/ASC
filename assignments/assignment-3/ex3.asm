bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; a-word; b-byte; c-word; d-doubleword; x-qword
    a dw 3
    b db 4
    c dw 2
    d dd 4
    x dq 3
    
; our code starts here
segment code use32 class=code
    start:
        ; (a*a+b/c-1)/(b+c)+d-x = 10 / 6 + 4 - 3 = 2
       
       
       
       mov ax, [a]
       mul word[a]
       mov bx, ax
       mov cx, dx
       mov al, [b]
       mov ah, 0
       mov dx, 0
       div word[c]
       add bx, ax
       sub bx, 1 ;bx = numaratorul
       
       mov al, [b]
       mov ah, 0
       add ax, [c]
       
       mov dx, cx
       mov cx, ax
       mov ax, bx
       mov bx, cx
       
       div bx
       
       mov ebx, 0
       mov bx, ax
       add ebx, [d]
       mov ecx, 0
       
       sub ebx, [x]
       sbb ecx, [x+4]
       
       
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
