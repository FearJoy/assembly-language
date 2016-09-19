TITLE Fibonacci(Program2.asm)

; Author: John Fitzpatrick
; CS 271 / Program 2
; Description: Interacts with user to print a Fibonacci sequences to a user specified count.
;       -Get's user name and prints it to the screen
;       -Validates that the user's input is within the allowed range (post=test loop)
;       -Output Fibonacci terms using MASM loop instruction using iteration

INCLUDE Irvine32.inc

LOWERLIMIT = 1
UPPERLIMIT = 46

.data

intPrompt		BYTE	"Enter a number: ",0
intPositive		BYTE	"You entered non-negative, preparing results",0
intLow			BYTE	"You enterd a number that is too low",0

userName        BYTE    25 DUP(0)
inputNum        DWORD   ?
count           DWORD   ?
fib1            DWORD   1
fib2            DWORD   0

introTitle      BYTE    "Welcome the the Fibonacci Sequence Generator by John Fitpatrick",0
namePrompt      BYTE    "Enter your name: ",0
greetPrompt1    BYTE    "Hello, ",0
greetPrompt2    BYTE    ", thank you for using the program.",0

instruct1       BYTE	"Steps:", 0
instruct2       BYTE	"     1. Input a number between 1 and 46",0
instruct3       BYTE	"     2. I will print a list of Fibonacci numbers",0
instruct4       BYTE	"	 Hint: if you input a number that is not within range, I will help :)",0

getFibNum       BYTE    "Enter the amount of Fibonacci numbers to calculate (1-46): ",0
inputHigh       BYTE    "Input is too high, try again (1-46)...",0
inputBad        BYTE    "Input is zero or negative, try again (1-46)...",0
spaces          BYTE    "     ",0
ciao            BYTE    "Thank you for using the Fibonacci Sequence Generator!",0

.code
main PROC

; ----------------------------------------------------------------------
; introduction (print intro and greet user by name)
; ----------------------------------------------------------------------
mov     edx, OFFSET introTitle               ; Loads introTitle to edx reg
call    WriteString                          ; Prints string
call    CrLf; Prints new line

mov     edx, OFFSET namePrompt               ; Prompts to get the name
call    WriteString                          ; Prints string

mov     edx, OFFSET userName                 ; Loads userName into edx reg
mov     ecx, 24                              ; Primes edx reg
call    ReadString                           ; Writes input to edx reg to be stored in userName

mov     edx, OFFSET greetPrompt1             ; Loads greetPrompt1 to edx reg
call    WriteString                          ; Prints string
mov     edx, OFFSET userName                 ; Loads userName to edx reg
call    WriteString                          ; Prints string
mov     edx, OFFSET greetPrompt2             ; Loads greetPrompt2 to edx reg
call    WriteString                          ; Prints string
call    CrLf                                 ; Prints new line

; ----------------------------------------------------------------------
; user instructions (display instructions and initial input prompt)
; ----------------------------------------------------------------------
mov     edx, OFFSET instruct1                ; Loads instruct1 to edx reg
call    WriteString                          ; Prints string
call    CrLf                                 ; Prints new line

mov     edx, OFFSET instruct2                ; Loads instruct2 to edx reg
call    WriteString                          ; Prints string
call    CrLf                                 ; Prints new line

mov     edx, OFFSET instruct3                ; Loads instruct3 to edx reg
call    WriteString                          ; Prints string
call    CrLf                                 ; Prints new line

mov     edx, OFFSET instruct4                ; Loads instruct4 to edx reg
call    WriteString                          ; Prints string
call    CrLf                                 ; Prints new line

; ----------------------------------------------------------------------
; getUserData (get input from user and store)
; ----------------------------------------------------------------------
mov     ecx, 1
jmp     GetInput

GetInput:                                    ; Gets data from user
mov     edx, OFFSET getFibNum
call    WriteString
call    ReadDec

test    eax,eax
jz      badNum                               ; Int is below range

cmp     eax, UPPERLIMIT
jg      highNum                              ; Int is outside range

jmp     goodNum                              ; Int is within range

badNum:                                      ; Advises user to input a higher number
mov     edx, OFFSET inputBad
call    WriteString
call    CrLf
mov     ecx, 2
loop    GetInput

highNum:                                     ; Advises user to input a lower number
mov     edx, OFFSET inputHigh
call    WriteString
call    CrLf
mov     ecx, 2
loop    GetInput

; ----------------------------------------------------------------------
; displayFibs(calculate and print Fibs in loop)
; ----------------------------------------------------------------------

goodNum:                                     ; Loads ecx counter and line counter
mov     inputNum, eax
mov     count, 6
mov     ecx, inputNum
cmp     ecx, 0
je      EndFib

Cont:                                        ; Used to continue printing to same line or to add a new line
dec     count
cmp     count, 0
jne     Line
cmp     count, 0
je      NewLine

Line:                                        ; Prints Fib on current line
mov     edx, OFFSET spaces
call WriteString
mov     eax, fib1
add     eax, fib2
mov     ebx, fib2
mov     fib1, ebx
mov     fib2, eax
Call    WriteDec

loop    Cont                                 ; Loops to continue to print

cmp     ecx,0
jz      EndFib                               ; The required amount of Fibs has been printed

NewLine:
call    CrLf
mov     count, 6
jmp     Cont

; ----------------------------------------------------------------------
; farewell(say goodbye!)
; ----------------------------------------------------------------------

EndFib:
Call    CrLf
mov     edx, OFFSET ciao
Call    WriteString
Call    CrLf

exit                                         ; Exit to operating system
main ENDP
     ; (insert additional procedures here)

END main
