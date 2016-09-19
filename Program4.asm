TITLE Composite Generator (Program4.asm)

; Author: John Fitzpatrick
; CS 271 / Program 4
; Description: This program calculates a list of composite numbers. The amount of numbers
;              printed is between 1 and a user specified count, n. The program will print
;              up to 10 composites per line, until the nth term is reached.

INCLUDE Irvine32.inc

; constants
LOWERLIMIT = 1
UPPERLIMIT = 400

.data
; Variables listed below

;    Initial greeting and instructions
introTitle     BYTE      "Welcome to the Composite Generator by John Fitzpatrick.", 0
instruct1      BYTE      "Instructions:", 0
instruct2      BYTE      "   Enter an integer in the inclusive range of [1, 400].", 0
instruct3      BYTE      "   A list of composite number will be printed to the screen.", 0
instruct4      BYTE      "   The amount of composite numbers is equal to the number provided.", 0

;    Prompts to get integer
intPrompt      BYTE      "Enter a number in [1, 400]: ", 0
intError       BYTE      "Out of range. Try again.", 0

;    Printing and calculating composites
inputNum       SDWORD    ?
compPrompt     BYTE      "Composites listed below:",0
compSpace      BYTE      "   ",0
compNum        SDWORD    3
compFactor     SDWORD    ?

;    Farewell
caio           BYTE      "Thank you for using the Composite Generator.", 0

mychcker       BYTE      12h
               BYTE      34h
               BYTE      64h
               BYTE      56h
               BYTE      70h
               BYTE      90h

.code
main PROC

call GreetAndInstruct
call GetInt
call Farewell
call PrintComposites
call CrLf

exit
main ENDP

; ----------------------------------------------------------------------
; Description:           Prints a greeting and instructions to the screen.
; Receives:              introTitle, instruct1, instruct2, instruct3,
;                        instruct4
; Returns                Printed text
; Preconditions:         N/A
; Registers Changed:     EDX
; ----------------------------------------------------------------------
GreetAndInstruct PROC
; Display title and greet the user
     mov       edx, OFFSET    introTitle
     call      WriteString
     call      CrLf

; Print instructions to the screen (instruct 1, 2, 3 and 4)
     mov       edx, OFFSET    instruct1
     call      WriteString
     call      CrLf

     mov       edx, OFFSET    instruct2
     call      WriteString
     call      CrLf

     mov       edx, OFFSET    instruct3
     call      WriteString
     call      CrLf

     mov       edx, OFFSET    instruct4
     call      WriteString
     call      CrLf
     call      CrLf

     ret
GreetAndInstruct ENDP

; ----------------------------------------------------------------------
; Description:           Gets an integer from the user between LOWERLIMIT
;                        and UPPERLIMIT (inclusive) and stores it in
;                        inputNum.
; Receives:              LOWERLIMIT, UPPERLIMIT, intPrompt, intError
; Returns                inputNum
; Preconditions:         N/A
; Registers Changed:     EAX, EDX
; ----------------------------------------------------------------------
GetInt PROC
; Repeatedly prompt user for number[LOWERLIMIT,UPPERLIMIT]
     get:
          mov       edx, OFFSET    intPrompt
          call      WriteString
          call      ReadInt
          call      CrLf

          ; Check if integer recieved from user is in[1, -400]
          cmp       eax, LOWERLIMIT
          jl        outOfRange
          cmp       eax, UPPERLIMIT
          jg        outOfRange
          mov       inputNum, eax
          
          ret
     outOfRange:
          mov       edx, OFFSET    intError
          call      WriteString
          call      CrLf
          jmp       get

          ret
GetInt ENDP


; ----------------------------------------------------------------------
; Description:           Prints composite numbers to the screen based on
;                        internal calculations from CompositeTest
; Receives:              compPrompt, inputNum, compNum, inputNum, compSpace
; Returns                Printed text
; Preconditions:         N/A
; Registers Changed:     EAX, EBX, ECX, EDX
; ----------------------------------------------------------------------
PrintComposites PROC
     call CrLf
     mov       edx, OFFSET compPrompt
     call WriteString
     call CrLf

     mov       ecx, inputNum                 ; Initialize loop counter to integer input
     L1:
          L2:
               inc       compNum
               call      CompositeTest
               cmp       eax, 1
               JNE       L2

          mov       eax, compNum
          call      WriteDec                 ; Prints composite (compCounter) to screen

          mov       edx, OFFSET compSpace     
          call      WriteString              ; Print 3 spaces

          ; Test for a new line to be printed
          mov       eax, inputNum
          sub       eax, ecx
          inc       eax
          mov       ebx, 10                  ; Divides (inputnum by current loop counter)
          xor       edx, edx                     
          div       ebx                      ; Divides by 10, if R=0 then 10 numbers on line

          cmp       edx, 0
          JNE NoLine                         ; Prints or does not print new line
          
          call CrLf

          NoLine:
          loop L1
     
     ret
PrintComposites ENDP

; ----------------------------------------------------------------------
; Description:           Tests if a number is prime by dividing it by 2,
;                        then 3, then 4, then 5, ... and so on until
;                        a remainder of 0 is produced, or the divisor
;                        becomes equal to the dividend.
; Receives:              compFactor, compNum
; Returns                EAX as 1/0, used to represent TRUE (1)/FALSE(0)
; Preconditions:         PROC PrintComposites is called
; Registers Changed:     EAX, EBX, EDX
; ----------------------------------------------------------------------
CompositeTest PROC
     mov       compFactor, 2

     FactorTest:
          ; tests if the factor to be tested is equal to the current number to be tested
          mov       eax, compFactor
          cmp       eax, compNum
          JE        IsNotComposite

          ; divide current factor into current number
          ; check if R=0 to resolve composite test
          xor       edx, edx
          mov       eax, compNum
          mov       ebx, compFactor
          div       ebx

          cmp       edx, 0              ; comparing remainder to 0
          JE        IsComposite         ; if R=0, then compNum is a composite

          inc       compFactor
          jmp       FactorTest

     IsComposite:
          mov       eax, 1              ; returns 1 (TRUE) if compNum is a composite
          JMP       ExitTest

     IsNotComposite:
          mov       eax, 0              ; returns 0 (FALSE) if compNum is a prime

     ExitTest:
          ret
CompositeTest ENDP

; ----------------------------------------------------------------------
; Description:           Prints a farewell message to the the screen.
; Receives:              caio
; Returns                Printed text
; Preconditions:         N / A
; Registers Changed : EDX
; ----------------------------------------------------------------------
Farewell PROC
; Farewell message
mov       edx, OFFSET    caio
call      WriteString
call      CrLf
call      CrLf

ret
Farewell ENDP


END main