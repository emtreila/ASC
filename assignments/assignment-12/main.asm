bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf, scanf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll                         ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import scanf msvcrt.dll

extern concatenation ; my module

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    n dd 0
    message1 db "n=", 0
    format1 db "%d", 0
    
    sentence times 100 db 0 ; the sentence from the user
    format2 db "%s", 0
    message2 db "Enter sentence: ", 0
    final times 100 db 0
    
    sentence_index dd 0
    
    format3 db "%s", 0
    
    
; our code starts here
segment code use32 class=code
    start:
        ; Read an integer (positive number) n from keyboard. Then read n sentences containing at least n words (no validation needed).
        ; Print the string containing the concatenation of the word i of the sentence i, for i=1,n (separated by a space).
        ; Example: n=5
        ; We read the following 5 sentences:
        ; We read the following 5 sentences.
        ; Today is monday and it is raining.
        ; My favorite book is the one I just showed you.
        ; It is pretty cold today.
        ; Tomorrow I am going shopping.

        ; The string printed on the screen should be:
        ; We is book cold shopping.
        
        push dword message1 ;showing the message n= for the user to type the value n
        call [printf]
        add esp, 4*1
        
        push dword n        ; getting the value for n from the user
        push dword format1
        call [scanf]
        add esp, 4*2
        
        mov ecx, [n]
        
        start_loop:
            push ecx
        
            push dword message2
            call [printf]
            add esp, 4*1
            
            push dword sentence
            push dword format2
            call [scanf]
            add esp, 4*2
            
            ; call la metoda
            ; sentence = read sentence
            ; final = sentence where the ith word will be added
            ; i = index of the sentence read
            
            push dword sentence
            push dword final
            push dword [sentence_index]
            call concatenation
            add esp, 4*3
            
            pop ecx
               
            add dword [sentence_index], 1
            loop start_loop
            
        end_loop:
        
            push dword final
            push dword format3
            call [printf]
            add esp, 4*2
            
        
        
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
