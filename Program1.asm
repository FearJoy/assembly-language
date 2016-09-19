TITLE Program1(Program1.asm)

; Name: John Fitzpatrick
; CS 271 / Program 1
;
; Description: This program will display the programmer's name and the program's title to the user.
; The user will be sintructed to input two positive itegers.
; Using these numbers, the sum, difference, product, quotient and remainder will be displayed.
; A terminating will be displayed before the program ends.


INCLUDE Irvine32.inc

.data
; variables are stored here

; text variables
intro_1     BYTE    "Elementary Arithmetic by John Fitzpatrick", 0
intro_2     BYTE    "I will take two numbers, and output the sum, difference, product, quotient, and remainder.", 0
getNum1     BYTE    "Please, enter a number (must be an integer greater than 0): ", 0
getNum2     BYTE    "Enter a second number (same rules as above): ", 0
addT        BYTE    " + ", 0
subT        BYTE    " - ", 0
proT        BYTE    " * ", 0
quoT        BYTE    " / ", 0
remT        BYTE    " remainder ", 0
equT        BYTE    " = ", 0
caio        BYTE    "Thank you for using this tool. Come back soon! Good bye.", 0

; variables to store input
n1      DWORD ?
n2      DWORD ?

; variables to store results of mathematical operations
addition    DWORD ?
subtraction DWORD ?
product     DWORD ?
quotient    DWORD ?
remainder   DWORD ?

.code
main PROC

; print introduction for user
     mov     edx, OFFSET     intro_1
     call    WriteString
     call    CrLf

     mov     edx, OFFSET     intro_2
     call    WriteString
     call    CrLf

; get first positive integer from user
     mov     edx, OFFSET     getNum1
     call    WriteString
     call    ReadInt
     mov     n1, eax

; get second positive integer from user
     mov     edx, OFFSET     getNum2
     call    WriteString
     call    ReadInt
     mov     n2, eax

; preform addition
     mov     eax, n1
     add     eax, n2
     mov     addition, eax

; print addition
     mov     eax, n1
     call    WriteDec
     mov     edx, OFFSET     addT
     call    WriteString

     mov     eax, n2
     call    WriteDec
     mov     edx, OFFSET     equT
     call    WriteString

     mov     eax, addition
     call    WriteDec
     call    CrLf

; preform subtraction
     mov     eax, n1
     sub     eax, n2
     mov     subtraction, eax

; print subtraction
     mov     eax, n1
     call    WriteDec
     mov     edx, OFFSET     subT
     call    WriteString

     mov     eax, n2
     call    WriteDec
     mov     edx, OFFSET     equT
     call    WriteString

     mov     eax, subtraction
     call    WriteDec
     call    CrLf

; preform multiplication
     mov     eax, n1
     mov     ebx, n2
     mul     ebx
     mov     product, eax

; print multiplication
     mov     eax, n1
     call    WriteDec
     mov     edx, OFFSET     proT
     call    WriteString

     mov     eax, n2
     call    WriteDec
     mov     edx, OFFSET     equT
     call    WriteString

     mov     eax, product
     call    WriteDec
     call    CrLf

; preform division(quotient)
     mov     eax, n1
     mov     ebx, n2
     sub     edx, edx
     div     ebx
     mov     quotient, eax

; preform division(remainder)
     mov     eax, n1
     mov     ebx, n2
     sub     edx, edx
     div     ebx
     mov     remainder, edx

; print quotient and remainder
     mov     eax, n1
     call    WriteDec
     mov     edx, OFFSET     quoT
     call    WriteString

     mov     eax, n2
     call    WriteDec
     mov     edx, OFFSET     equT
     call    WriteString

     mov     eax, quotient
     call    WriteDec
     mov     edx, OFFSET     remT
     call    WriteString
     mov     eax, remainder
     call    WriteDec
     call    CrLf

; farewell message
     mov     edx, OFFSET     caio
     call    WriteString

main ENDP

END main

