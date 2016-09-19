TITLE Sorting Random Integers(Program5.asm)

; Author: John Fitzpatrick
; CS 271 / Program 5
; Description: This programs generates a set of random integers in the range of[100, 999].
;              The amount of numbers generated is determined by a user provided integer.
;              The random numbers will be stored in an array.The unsorted integers will
;              be printed, 10 per line.The arry will be sorted in descending order.After
;              the sort, the median will be displayed, followed by the list of sorted
;              integers, 10 per line.

INCLUDE Irvine32.inc

; constants
	MIN = 10
	MAX = 200
	LO = 100
	HI = 999
	DISTANCE = 900

.data
; Variables listed below
	;    Initial greeting and instructions
	introTitle     BYTE      "Sorted Random Integers, by John Fitzpatrick", 0
	instruct1      BYTE      "Instructions:", 0
	instruct2      BYTE      "   Provide an integer between [10,200], this many random integers will be calculated.", 0
	instruct3      BYTE      "   The integers will be in the range [100,999], and will be printed unsorted.", 0
	instruct4      BYTE      "   After printing, the integers will be sorted, and a final list will be printed along with the median.", 0

	;    Prompts to get integer
	intPrompt      BYTE      "Enter a quantity of numbers to generate in [10,200]: ", 0
	intError       BYTE      "Out of range. Try again.", 0
	request        DWORD ?

	;    Array declarations and printing
	array          DWORD     MAX DUP(?)
	padding		BYTE		"   ",0
	unsorted		BYTE		"A list of the unsorted array, 10 integers per line:",0
	sorted		BYTE		"A list of the sorted array, 10 integers per line:",0
	median		BYTE		"The median value is: ",0
	;    Farewell
	caio           BYTE      "Thank you for using the Sorted Random Integers tool.", 0


.code
main PROC
	call GreetAndInstruct
	push      OFFSET request
	call GetInt

	push      OFFSET array
	push      request
	call FillArray

	push		OFFSET array
	push		request
	push		OFFSET unsorted
	call PrintArray

	push		OFFSET array
	push		request
	call Sort

	push		OFFSET array
	push		request
	push		OFFSET median
	call PrintMedian

	push		OFFSET array
	push		request
	push		OFFSET sorted
	call PrintArray

	call Farewell
	call CrLf
	exit
main ENDP


; ----------------------------------------------------------------------
	; Description:           Prints a greeting and instructions to the screen.
	; Receives:              introTitle, instruct1, instruct2, instruct3,
	;                        instruct4
	; Returns                Printed text
	; Preconditions:         N / A
	; Registers Changed : EDX
; ----------------------------------------------------------------------
GreetAndInstruct PROC         ; COMPLETE
; Display title and greet the user
	mov       edx, OFFSET    introTitle
	call      WriteString
	call      CrLf

	; Print instructions to the screen(instruct 1, 2, 3 and 4)
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
	; Description:           Gets an integer from the user between MIN
	;                        and MAX(inclusive) and stores it in request.
	; Receives:              MIN, MAX, intPrompt, intError
	; Returns                request
	; Preconditions:         N / A
	; Registers Changed : EAX, EDX
; ----------------------------------------------------------------------
GetInt PROC                   ; COMPLETE
; Repeatedly prompt user for number[LOWERLIMIT, UPPERLIMIT]
	push      ebp
	mov       ebp, esp
	pushad
	mov       ebx, [ebp + 8]

	get:
		; Get int and confirm it is in [10,200]
		mov       edx, OFFSET intPrompt
		call WriteString
		call ReadInt
		call CrLf

		cmp       eax, MIN		; compare to MIN
		jb        outOfRange

		cmp       eax, MAX		; compare to MAX
		ja        outOfRange

		mov       request, eax

		jmp       procExit

	outOfRange:
		mov       edx, OFFSET    intError
		call      WriteString
		call      CrLf
		jmp       get

	procExit:
		mov       [ebx], eax     ; Stores eax in address held by [ebx]
		popad                    ; restores register original
		pop       ebp            ; reset base pointer
		ret       4              ; returns stack to original value
GetInt ENDP


; ----------------------------------------------------------------------
	; Description:           
	; Receives:              
	; Returns:
	; Preconditions:
	; Registers Changed:
; ----------------------------------------------------------------------
FillArray PROC                ; COMPLETTE
	push      ebp                 ; stores base pointer
	mov       ebp, esp            ; base pointer ref stack frame
	pushad                        ; store contents of registers
	mov       esi, [ebp+12]       ; [ebp+12] is the offset of array
	mov       ecx, [ebp+8]        ; set ecx to value of request for looping

	cmp       ecx, 0              ; check if ecx is 0, should never happen
	je        procExit            ; used for debugging and error testing

	call Randomize                ; seed for random number generation
	fill:
		mov       eax, DISTANCE  ; set eax up for function call
		call      RandomRange    ; returns random int in [0,(eax-1)]
		add       eax, LO        ; brings result to number in [100,999]
		mov       [esi],eax      ; puts value in array at [esi]
		add       esi, 4         ; move to next DWORD element in array
		loop      fill           ; loop until ecx is empty

	procExit:
		popad				; house cleaning
		pop       ebp
		ret       8
FillArray ENDP


; ----------------------------------------------------------------------
	; Description:           
	; Receives:              
	; Returns:
	; Preconditions:
	; Registers Changed:
; ----------------------------------------------------------------------
PrintArray PROC               ; COMPLETE
	push		ebp
	mov		ebp, esp
	pushad

	mov		esi, [ebp+16]		; @array
	mov		ecx, [ebp+12]		; set ecx to value of request for looping
	mov		edx, [ebp+8]		; @title
	mov		ebx, 10

	call		WriteString		; prints title to screen
	call		CrLf

	; add print 10 per line and determine if a new line needs to be printed
	printInt:
		mov		eax, [esi]	; array[esi] to eax, starts at array[0]
		call		WriteDec		; print unsigned int to screen
		mov		edx, OFFSET padding
		call		WriteString
		add		esi, 4		; shift from array[x] to array[x+1]
		
		xor		edx, edx
		mov		eax, ecx		; line control
		div 		ebx
		cmp		edx, 0
		jne		noLine

	printLine:
		call		CrLf
		loop		printInt
	noLine:
		loop		printInt

	popad					; standard clean up
	pop		ebp
	ret		12
PrintArray ENDP


; ----------------------------------------------------------------------
	; Description:           
	; Receives:              
	; Returns:
	; Preconditions:
	; Registers Changed:
; ----------------------------------------------------------------------
Sort PROC                     ; COMPLETE
	push ebp						; set up stack 
	mov ebp, esp
	pushad						; store registers

	
	mov ecx, [ebp+8]				; set ecx to request
	dec ecx						; ecx = request-1

	outLoop:
		push ecx				; outer loop
		mov esi, [ebp+12]			;esi = @array

	inLoop: mov eax, [esi]			; get array data
			cmp [esi+4], eax
			JBE noExch			; if [esi+4] <= [esi] no exchange

			push esi				; pass parameters
			mov edi, esi
			add edi, 4
			push edi
			call SwapFunction		; else swap data
		
		noExch:
			add esi, 4			; advance pointer to next element
			loop inLoop			; inner loop

		pop ecx					; restore outer count
		loop outLoop				; repeat outer loop


	popad						; restore registers
	pop ebp
	ret 8
Sort ENDP

; ----------------------------------------------------------------------
	; Description:           
	; Receives:              
	; Returns:
	; Preconditions:
	; Registers Changed:
; ----------------------------------------------------------------------
SwapFunction PROC			; COMPLETE
	push ebp					; set up stack frame
	mov ebp, esp
	pushad					; save registers

	mov eax, [ebp+12]			; eax = @array[i]
	mov ecx, [eax]				; ecx =  array[i]

	mov ebx, [ebp+8]			; ebx = @array[j]
	mov edx, [ebx]				; edx =  array[j]

	xchg ecx, edx				; swap values

	mov [eax], ecx				; implement values
	mov [ebx], edx

	popad
	pop ebp
	ret 8				
SwapFunction ENDP

; ----------------------------------------------------------------------
	; Description:           
	; Receives:              
	; Returns:
	; Preconditions:
	; Registers Changed:
; ----------------------------------------------------------------------
PrintMedian PROC                   ; COMPLETE
	push		ebp			; save ebp
	mov		ebp, esp		; move stack pointer to ebp
	pushad				; store general register values

	call		CrLf
	mov		esi, [ebp+16]		; @array
	mov		edx, [ebp+8]		; @title
	call		WriteString		; prints title
	
	; set up for division to determine if array countaints even or odd count
	mov		eax, [ebp+12]		; set eax to value of request	
	mov		ebx, 2
	xor		edx, edx
	div		ebx				; eax contains index number of middle element

	cmp		edx, 0
	je		evenCount
	jne		oddCount

	evenCount:
		mov		ebx, 4
		mul		ebx				; eax = eax*ebx or 4*middle number
		add		esi, eax			; point esi to element at array[4*eax]

		; add two middle numbers and divide by 2
		mov		eax, [esi]		; store array[esi] into eax
		add		eax, [esi+4]		; add two numbers
		mov		ebx, 2			; set up for division
		xor 		edx, edx
		div 		ebx				

		; calculate rounding
		mov		ecx, eax			; store eax in ecx
		mul		ebx				; round up if remainder*2 > quotient
		cmp		eax, edx
		ja		roundUp			; evaluates (eax*2) >  remainder
		jbe		roundDown			; evaluates (eax*2) =< remainder

		roundUp:
		mov		eax, ecx
		inc		eax
		call		WriteDec
		call		CrLf
		jmp		procExit

		roundDown:
		mov		eax, ecx
		call		WriteDec
		call		CrLf
		jmp		procExit
	
	oddCount:
		mov		ebx, 4
		mul		ebx
		add		esi, eax			; point esi to element at array[4*eax]
		mov		eax, [esi]
		call		WriteDec
		call		CrLf
		jmp		procExit
	
	procExit:
		popad
		pop		ebp
		ret		12
PrintMedian ENDP


; ----------------------------------------------------------------------
	; Description:           Prints a farewell message to the the screen.
	; Receives:              caio
	; Returns                Printed text
	; Preconditions:         N / A
	; Registers Changed : EDX
; ----------------------------------------------------------------------
Farewell PROC                 ; COMPLETE
; Farewell message
	call		CrLf
	mov       edx, OFFSET    caio
	call      WriteString
	call      CrLf
	call      CrLf

	ret
Farewell ENDP


END main