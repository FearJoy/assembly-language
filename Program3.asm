TITLE Integer Accumulator (Program3.asm)

; Author: John Fitzpatrick
; CS 271 / Program 3;
; Description: Get negatives numbers, in the range of [-100,-1], from the user until
;              a non-negative is entered. Then the rounded average is displayed to
;              the screen, as well as the count of integers entered, the sum, and a
;              farewell message.
;
;
; Note to grader: this assignment was turned in one day late. I would like to use my
; first "free late" on this assignment to avoid the late penalty.

INCLUDE Irvine32.inc

LOWERLIMIT = -100

.data
; Variables listed below
userName       BYTE      25 DUP(0)
count          DWORD     0
remainder      SDWORD     ?
inputNum       SDWORD    ?
sum            SDWORD    ?
average        SDWORD    ?

; Constant text listed below
;    Initial greeting
introTitle     BYTE      "Welcome to the Integer Accumulator by John Fitzpatrick.",0
namePrompt     BYTE      "Please, enter your name: ",0
greetPrompt1   BYTE      "Hello, ",0
greetPrompt2   BYTE      ", thank you for using the  accumulator!",0

;    Instructions
instruct1      BYTE      "Instructions:",0
instruct2      BYTE      "   Enter an integer in the inclusive range of [-100,-1].",0
instruct3      BYTE      "   I will keep taking numbers until you enter a non-negative integer.",0
instruct4      BYTE      "   The following information will be printed to the screen:",0
instruct5      BYTE      "      A count of numbers entered, sum of numbers, average, farewell.",0

;    Prompts to get integer
intPrompt      BYTE      "Enter a number in [-100,-1]: ",0
intPositive    BYTE      "You have entered a non-negative. Preparing results...",0
intLow         BYTE      "You entered a number that is less than -100, try again.",0

;    Results of input(s)
rCount         BYTE      "Number of valid numbers entered:   ",0
rSum           BYTE      "Sum of valid numbers entered:     ", 0
rAverage       BYTE      "Average of valid numbers entered: ",0
rEmpty         BYTE      "No integers were provided. Please try again.",0

;    Farewell
caio           BYTE      "Thank you for using the Integer Accumulator. You did great!",0

.code
main PROC
; ----------------------------------------------------------------------
; Display title and greet the user by provided name
; ----------------------------------------------------------------------
     ; Print welcome message
     mov       edx, OFFSET    introTitle
     call      WriteString
     call      CrLf

     ; Get user name
     mov       edx, OFFSET    namePrompt
     call      WriteString
     mov       edx, OFFSET    userName
     mov       ecx, 24
     call      ReadString

     ; Greet user by name
     mov       edx, OFFSET    greetPrompt1
     call      WriteString
     mov       edx, OFFSET    userName
     call      WriteString
     mov       edx, OFFSET    greetPrompt2
     call      WriteString
     call      CrLf
     call      CrLf


; ----------------------------------------------------------------------
; Print instructions to the screen
; ----------------------------------------------------------------------
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

     mov       edx, OFFSET    instruct5
     call      WriteString
     call      CrLf
     call      CrLf


; ----------------------------------------------------------------------
; Repeatedly prompt user for number [-100,-1]
;    control counter to keep track of valid number of inputs
;    keep running total of numbers entered
; ----------------------------------------------------------------------
getInt:
     mov       edx, OFFSET    intPrompt
     call      WriteString
     call      ReadInt
     mov       inputNum, eax

     ; Check if integer recieved from user is in [-100,-1]
     cmp       inputNum, LOWERLIMIT
     jl        lowInput
     cmp       inputNum, -1
     jg        calculateResults
     jmp       goodInput

goodInput:
     mov       eax, sum
     add       eax, inputNum
     mov       sum, eax
     inc       count
     jmp       getInt

lowInput:
     mov       edx, OFFSET    intLow
     call      WriteString
     call      CrLf
     jmp       getInt


; ----------------------------------------------------------------------
; Calculate results (average; count and total finished)
; ----------------------------------------------------------------------
calculateResults:
     cmp       count, 0
     je        noEntry

     ; Calculates unrounded average
     mov       edx, 0
     mov       eax, sum
     cdq
     mov       ebx, count
     idiv      ebx
     mov       average, eax
     mov       remainder, edx

     ; To determine if rounding is needed compare (remainder * 2) to quotient
     ; If remainder is 0, do not round
     ; If remainder is 1, do not round
     ; If R * 2 <= Q ---> do not round
     ; If R * 2  > Q ---> round up
     
     ; No to rounding tests
     cmp       remainder, 0
     je        displayResults

     cmp       remainder, -1
     je        displayResults

     ; Test to round up
     mov       eax, remainder
     imul      eax, -2
     cmp       eax, count
     jg        roundUp
     jle       displayResults

roundUp:
     add       average, -1


; ----------------------------------------------------------------------
; Display results (count, total, average)
; ----------------------------------------------------------------------
displayResults:
     mov       edx, OFFSET    rCount
     call      WriteString
     mov       eax, count
     call      WriteDec
     call      CrLf

     mov       edx, OFFSET    rSum
     call      WriteString
     mov       eax, sum
     call      WriteInt
     call      CrLf

     mov       edx, OFFSET    rAverage
     call      WriteString
     mov       eax, average
     call      WriteInt
     call      CrLf
     call      CrLf

     jmp       farewell

noEntry:
     call      CrLf
     mov       edx, OFFSET    rEmpty
     call      WriteString
     call      CrLf
     call      CrLf


; ----------------------------------------------------------------------
; Farewell message
; ----------------------------------------------------------------------
farewell:
     mov       edx, OFFSET    caio
     call      WriteString
     call      CrLf
     call      CrLf

exit
main ENDP

END main