bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global octal        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
extern printf            
import printf msvcrt.dll 
extern scanf             
import scanf msvcrt.dll  

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    binary_number dd 0               ;= input binary number
    format1 db "%u", 0          ; Format for scanf to accept unsigned integers
    
    result dd 0                      ;= converted result   
    format2 db "Octal: %o", 10, 0 ; Format for printf to display octal
    


; our code starts here
segment code use32 class=code
    octal:
        ; Multiple numbers in base 2 are read from the keyboard. Display these numbers in the base 8.
        
        push binary_number         
        push format1               
        call [scanf]               
        add esp, 8                 

        mov eax, [binary_number]   ; binary_number into EAX
        call binary_to_octal       
        mov [result], eax          
        
        push [result]              
        push format2               
        call [printf]              
        add esp, 8 

    binary_to_octal:
        ; Input: EAX = binary number
        ; Output: EAX = decimal equivalent 

        xor ebx, ebx               ; EBX = result accumulator
        xor ecx, ecx               ; ECX = bit position counter

    convert_loop:
        test eax, eax              ; Check if the binary number is 0
        jz done                    ; If 0, exit loop

        mov edx, eax               ; Copy EAX to EDX
        and edx, 1                 ; Isolate the least significant bit
        shl edx, cl                ; Shift left by the bit position (ECX)
        add ebx, edx               ; Add to result in EBX

        shr eax, 1                 ; Shift binary number right by 1 bit
        inc ecx                    ; Increment the bit position counter
        jmp convert_loop           ; Repeat until EAX is 0

    done:
        mov eax, ebx               ; Move the result back to EAX
        ret                        ; Return to caller
            

        ; Exit the program
        push dword 0               ; Push exit code 0
        call [exit]                ; Call exit to terminate the program
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
