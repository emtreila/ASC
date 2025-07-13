bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data

    s DD 12345607h, 1A2B3C15h
    len equ ($-s)/4   ; the length of the string
    d times $-s db 0
    i dd 0

; our code starts here
segment code use32 class=code
    start:
        ; Given an array S of doublewords, build the array of bytes D formed from bytes of doublewords sorted as unsigned numbers in ascending order.

        mov esi, s              ; source index is the string of dwords s
        mov edi, d              ; destination index is the string of bytes d
        cld                     ; parse the string from left to right
        mov ecx, len            ; len iterations in loop

        start_loop:
            mov ebx, 4          ; loop 4 times so that an entire dword is parsed

            add_loop:
                movsb           ; load in d each byte of s
                
                dec ebx 
                jnz add_loop    ; exit loop if ebx reached 0

            loop start_loop     ; process another dword

        ; sorting the string in edi using selection sort
        
        mov dword [i], 1        ; current index
        mov edi, d              ; edi contains the address of d at the current index
        
        i_loop:
            mov ecx, len * 4    ; length of d
                                ; looping through the d string until the last element
                                ; we can't compare the last element with the next items, because there aren't any
            
            sub ecx, dword [i]  ; substract the current index -> loop the rest elements
            
            
            cmp ecx, 0          ; check if we are on the last element
            jle done            ; exit loop if so
        
            mov esi, edi        ; for loading each byte in AL
            
            lodsb               ; AL now contains the byte at the current index

            
            ; interior loop of the selection sort
            j_loop:
                mov ah, byte [esi] ; mov in AH the byte at the current index in the interior loop
                                   ; meaning the jth element
                
                cmp al, ah         ; check if the element on the ith index (current index) is greater
                
                jle next           ; go to the next element if not
                
                ; switching the elements
                mov [edi], ah      ; AH is lower, move it at the current index
                mov [esi], al      ; AL is greater, move it at the jth position
                
                mov al, ah         ; mov in AL the new element on the current index
                
                ; go to the next element
                next:
                    inc esi        ; increment the address contained in ESI
                    loop j_loop    ; loop the interior for
            
            ; now increase the addres contained in EDI
            ; and the current index -> go to the next element
            add dword [i], 1
            inc edi
            jmp i_loop
        

        done:
            ; exit(0)
            push    dword 0      ; push the parameter for exit onto the stack
            call    [exit]       ; call exit to terminate the program