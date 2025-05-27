TITLE Generating, Sorting, & Counting Random integers!             (Proj5_azevedoe.asm)

; Author: Eric Azevedo
; Last Modified: 3/3/24
; OSU email address: azevedoe@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 5                Due Date: 3/3/24
; Description: Generating, Sorting, and Counting Random integers


INCLUDE Irvine32.inc

; (insert macro definitions here)

SIZE_ = 200
LO = 15
HI = 50

.data

randArray			DWORD	SIZE_	DUP(?)	; where random numbers will be store
counts				DWORD	(HI-LO+1)	DUP(0)	; the count
space				BYTE	" ", 0
max_1				DWORD	20					; max per line
intro_1				BYTE	"Generating, Sorting, and Counting Random integers!", 0
intro_2				BYTE	"Programmed by Eric", 13, 10, 0
about_1				BYTE	"Program generates 200 random integers between 15 and 50. It displays original list, sorted list, median value, and number of instances of each generated value.", 13, 10, 0
unsorted_prompt		BYTE	"Your unsorted random numbers:", 13, 10, 0
median_prompt		BYTE	"The median value of the array:", 13, 10, 0
sorted_prompt		BYTE	"Your sorted random numbers:", 13, 10, 0
instance_prompt		BYTE	"Your list of instances of each generated number, starting with the smallest value:", 13, 10, 0
outro				BYTE	"Goodbye, and thanks for using my program!", 0

.code
main PROC

; call Randomize
call	Randomize

; display introducion
push	OFFSET intro_1
push	OFFSET intro_2
push	OFFSET about_1
call	introduction


; fill array with random numbers
push	OFFSET randArray
call	fillArray


; display unsorted
push	max_1
push	OFFSET space
push	OFFSET unsorted_prompt
push	OFFSET SIZE_
push	OFFSET randArray
call	displayList


; sort array
push	OFFSET SIZE_
push	OFFSET randArray
call	sortList

; display median
push	OFFSET space
push	OFFSET median_prompt
push	OFFSET randArray
push	OFFSET SIZE_
call	displayMedian

; display sorted
push	max_1
push	OFFSET space
push	OFFSET sorted_prompt
push	OFFSET SIZE_
push	OFFSET randArray
call	displayList	

; count instance
push	OFFSET randArray
push	OFFSET counts
call	countList

; display count
push	max_1
push	OFFSET space
push	OFFSET instance_prompt
push	OFFSET (HI - LO + 1)
push	OFFSET counts
call	displayList	

; outro
call	CrLf
mov		EDX, OFFSET outro
call	WriteString
call	CrLf

	Invoke ExitProcess,0	; exit to operating system
main ENDP

introduction PROC

; introduction
push	EBP					; save old base pointer value
mov		EBP, ESP	
push	EDX

mov		EDX, [EBP+16]		; intro_1
call	WriteString
call	CrLf

mov		EDX, [EBP+12]		; intro_2
call	WriteString
call	Crlf

mov		EDX, [EBP+8]		; about_1	
call	WriteString

pop		EDX
pop		EBP
ret		3
introduction ENDP

fillArray PROC

; randmize nunbers and put it in the displayArray
push	EBP					; save old base pointer value
mov		EBP, ESP	
push	EDI
push	ECX
push	EAX

mov		EDI, [EBP+8]		; randArray
mov		ECX, SIZE_		; counter for loop

fillLoop:
mov		EAX, HI
sub		EAX, LO
inc		EAX
call	RandomRange
add		EAX, LO
mov		[EDI], EAX			; store value in array
add		EDI, 4				; move to next element

loop	fillLoop

endFill:
pop		EAX
pop		ECX
pop		EDI
pop		EBP
ret		4
fillArray ENDP

sortList PROC
push	EBP					; save old base pointer value
mov		EBP, ESP
push	ECX
push	EAX

loop1:
mov		ESI, [EBP+8]		; randArray
mov		ECX, [EBP+12]		; loop counter
dec		ECX
cmp		ECX, 0
jle		endSW
mov		EDX, 0

loop2:
mov		EAX, [ESI]			; current element
cmp		EAX, [ESI+4]
jle		loop3
mov		EBX, [ESI]
mov		EAX, [ESI+4]
mov		[ESI+4], EBX
mov		[ESI], EAX
mov		EDX, 1

loop3:
add		ESI, 4
loop	loop2

cmp		EDX, 1
je		loop1

endSW:
pop		EAX
pop		ECX
pop		EBP
ret		8
sortList ENDP

displayList PROC
push	EBP					; save old base pointer value
mov		EBP, ESP
push	EDX
push	ECX
push	ESI
push	EBX
push	EAX

call	CrLf
mov		EDX, [EBP+16]
call	WriteString

mov		ECX, [EBP+12]	; array size, loop counter
mov		ESI, [EBP+8]	; randArray
xor		EBX, EBX

print_loop:
mov		EAX, [ESI]
call	WriteDec
mov		EDX, [EBP+20]
call	WriteString
inc		EBX
cmp		EBX, [EBP+24]
jl		skip
call	CrLf
mov		EBX, 0

skip:
add		ESI, 4
loop	print_loop

end_d:
call	CrLf
pop		EAX
pop		EBX
pop		ESI
pop		ECX
pop		EDX
pop		EBP
ret		14
displayList ENDP

displayMedian PROC
push	EBP					; save old base pointer value
mov		EBP, ESP
push	EDX
push	ESI
push	EAX
push	EBX
push	ECX

call	CrLf
mov		EDX, [EBP+16]		; prompt
call	WriteString

mov		ESI, [EBP+12]		; list
mov		EAX, [EBP+8]		; loop counter
mov		EDX, 0
mov		EBX, 2
div		EBX
mov		ECX, EAX

loop_M:
add		ESI, 4
loop	loop_M

cmp		EDX, 0				; check for zero
jnz		odd

mov		EAX, [ESI-4]		; it is even
add		EAX, [ESI]
mov		EDX, 0
mov		EBX, 2
div		EBX
call	WriteDec
call	CrLf
jmp		end_1

odd:
mov		EAX, [ESI]
call	WriteDec
call	CrLf

end_1:
pop		ECX
pop		EBX
pop		EAX
pop		ESI
pop		EDX
pop		EBP
ret		10
displayMedian ENDP

countList PROC
push	EBP					; save old base pointer value
mov		EBP, ESP
push	ESI
push	EDI
push	ECX
push	EAX

mov		ESI, [EBP+12]		; randArray
mov		EDI, [EBP+8]		; counts
mov		ECX, SIZE_		; loop counter 

count_loop:
mov		EAX, [ESI]			; move current integer 
sub		EAX, LO
inc		DWORD PTR [EDI+EAX*4]	; increment count 
add		ESI, 4
loop	count_loop

end_c:
pop		EAX
pop		ECX
pop		EDI
pop		ESI
pop		EBP
ret		8
countList ENDP

END main