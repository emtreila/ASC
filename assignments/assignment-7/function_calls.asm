bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf, scanf              ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll
import scanf msvcrt.dll                         ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    message1 db "Number a = ", 0
    message2 db "Number b = ", 0
    message3 db "a+b = %d", 0 
    format db "%x", 0
    a dd 0
    b dd 0

; our code starts here
segment code use32 class=code
    start:
        ; Read two numbers a and b (in base 16) from the keyboard and calculate a+b. Display the result in base 10
        
        ; scanf(msg, addr1, addr2, ...)
        push dword message1
        call [printf]
        add esp, 4*1
        
        push dword a
        push dword format
        call [scanf]
        add esp, 4*2
        
        push dword message2
        call [printf]
        add esp, 4*1
        
        push dword b
        push dword format
        call [scanf]
        add esp, 4*2
        
        ;printf(msg, mem1, mem2, ...)
        mov ebx, [a]
        add ebx, [b]
        push ebx
        push dword message3
        call [printf]
        add esp, 4*2
        
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the  program
