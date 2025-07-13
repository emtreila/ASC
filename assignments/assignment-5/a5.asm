bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    s db 1, 3, -2, -5, 3, -8, 5, 0
    len equ $-s
    d1 times len db 0
    d2 times len db 0
    i db 0
    j db 0
; our code starts here
segment code use32 class=code
    start:
        ; A byte string S is given. Obtain the string D1 which contains all the positive numbers of S and the string D2 which contains all the negative numbers of S.
        ; Example:
            ; S: 1, 3, -2, -5, 3, -8, 5, 0
            ; D1: 1, 3, 3, 5, 0
            ; D2: -2, -5, -8
        mov eax, 0
        
        mov esi, 0 ; source index
        mov ebx, 0 ; destination index -> bl
        
        start_loop:
            mov al, [s+esi]
            cmp al, 0
            js put_d2 ; signed byte
            
            mov bl, [i]
            mov [d1 + ebx], al
            inc bl
            mov [i], bl
            jmp end_if
            
            put_d2:
                mov bl, [j]
                mov [d2 + ebx], al
                inc ebx
                mov [j], bl
            end_if:
                inc esi
                cmp esi, len
                je end
        loop start_loop
        end:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
