bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    
    A dd 10011101111100110111101000011011b
    B dd 0000000000000000000000000000b
    C db 0000000000000000000000000000b
    n resb 1
    
; our code starts here
segment code use32 class=code
    start:
        ;Given the doubleword A, obtain the integer number n represented on the bits 14-17 of A. 
        ;Then obtain the doubleword B by rotating A n positions to the left. Finally, obtain the byte C as follows:
                ;the btis 0-5 of C are the same as the bits 1-6 of B
                ;the bits 6-7 of C are the same as the bits 17-18 of B
        
        mov ecx, 0

; 1) obtain the integer number n represented on the bits 14-17 of A        
        mov eax, [A]
        and eax, 00000000000000111100000000000000b;isolate bits 14-17 1001 1101 1111 0011 0111 1010 0001 1011->0000 0000 0000 0010 1100 0000 0000 0000
        shl eax, 14 ; 0000 0000 0000 0010 1100 0000 0000 0000 -> 1011 0000 0000 0000 0000 0000 0000 0000
        sar eax, 28 ; 1011 0000 0000 0000 0000 0000 0000 0000 -> 1111 1111 1111 1111 1111 1111 1111 1011
        mov [n], al
        mov cl, [n]
       
; 2) obtain the doubleword B by rotating A n positions to the left
        mov ebx, [A] ; ebx: 1001 1101 1111 0011 0111 1010 0001 1011 
        rol ebx, cl  ; 1001 1101 1111 0011 0111 1010 0001 1011 -> 1011 1101 0000 1101 1100 1111 1011 1001
        mov [B], ebx
        
; 3) obtain the byte C: the bits 0-5 of C are the same as the bits 1-6 of B 
        
        mov eax, 0
        mov ebx, 0
        mov eax, [B] ; eax: 1011 1101 0000 1101 1100 1111 1011 1001
        and eax, 00000000000000000000000001111110b ;isolate bits 1-6 of B:0000 0000 0000 0000 0000 0000 0011 1000
        shr eax, 1 ; 0000 0000 0000 0000 0000 0000 0011 1000 -> 0000 0000 0000 0000 0000 0000 0001 1100
        or ebx,eax ; in ebx este rezultatul
        
; 4) obtain the byte C: the bits 6-7 of C are the same as the bits 17-18 of B
    
        mov eax, 0
        mov eax, [B] ; eax: 1011 1101 0000 1101 1100 1111 1011 1001
        and eax, 00000000000001100000000000000000b ;isolate bits 17-18 of B:0000 0000 0000 0100 0000 0000 0000 0000
        shr eax, 11 ; 0000 0000 0000 0100 0000 0000 0000 0000 -> 0000 0000 0000 0000 0000 0000 1000 0000
        or ebx,eax ; in ebx este rezultatul
        mov [C], ebx
 
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
