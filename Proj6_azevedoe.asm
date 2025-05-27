TITLE Designing low-level I/O procedures     (Proj6_azevedoe.asm)

; Author: Eric Azevedo
; Last Modified: 03/17/24
; OSU email address: azevedoe@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 6                Due Date: 03/17/24
; Description: Program that takes 10 signed decimal intergers that are small enough to fit 
; inside a 32 bit register and displays a list of the integers, their sums, and their average value

INCLUDE Irvine32.inc

mGetString	MACRO	prompt, input, length, bytes_read

	; create stack 
	push	EAX
	push	ECX
	push	EDX

	; prompt user 
	mov		EDX,  prompt					
	call	WriteString
	mov		EDX,  input				
	mov		ECX,  length				
	call	ReadString
	mov		bytes_read, EAX

	; terminate stack
	pop		EDX
	pop		ECX
	pop		EAX

ENDM

mDisplayString MACRO string
	
	; create stack
	push	EDX

	mov		EDX, string
	call	WriteString

	; terminate stack
	pop		EDX

ENDM

.data

intro_display			BYTE	"PROGRAMMING ASSIGNMENT 6: Designing low-level I/O procedures", 0
by_display				BYTE	"Written by: Eric Azevedo", 0
instr_1_display			BYTE	"Please provide 10 signed decimal integers.", 0
instr_2_display			BYTE	"Each number needs to be small enough to fit inside a 32 bit register.", 0
instr_3_display			BYTE	"After you have finished inputting the raw numbers I will display a list of the integers, their sum, and their average value.", 0
enter_prompt			BYTE	"Please enter an signed number: ", 0
error_display			BYTE	"ERROR: You did not enter a signed number or your number was too big. ", 0
error_prompt			BYTE	"Please try again: ", 0
validation_prompt		BYTE	"You entered the following numbers: ", 0
comma					BYTE	", ", 0			
sum_display				BYTE	"The sum of these numbers is: ", 0
average_display			BYTE	"The truncated average is: ", 0
outro_display			BYTE	"Thanks for playing!", 0
input					DWORD	10 DUP(?)	
input_size				DWORD	?				; number of digits the user entered
output					DWORD	10 DUP(?)
array					DWORD	10 DUP(?)		; store results 
sum						DWORD	?
average					DWORD	?

.code

main PROC

	; intro
	push		OFFSET intro_display
	push		OFFSET by_display
	push		OFFSET instr_1_display
	push		OFFSET instr_2_display
	push		OFFSET instr_3_display
	call		introduction
	call		CrLf

	; get values
	mov		EDI, OFFSET array		; moving array into EDI
	mov		ECX, 10					; counter for loop
	call	CrLf

	_getVal:
		push		LENGTHOF input
		push		EDI					; array
		push		OFFSET enter_prompt
		push		OFFSET error_display
		push		OFFSET error_prompt
		push		OFFSET input
		push		input_size
		call		ReadVal
		add			EDI, 4				; goes to next element in array
		loop		_getVal

	; display values
	call		CrLf
	mDisplayString OFFSET validation_prompt
	call		CrLf
	
	mov			ECX, 10
	mov			ESI, OFFSET array

	_displayVal:
		push	OFFSET output
		push	[ESI]
		call	WriteVal
		cmp		ECX, 1
		je		_done
		mDisplayString offset comma
		add		ESI, 4
		loop	_displayVal

	_done:
		call		CrLf

	; add values
	mov		ECX, 10
	mov		EDI, OFFSET array

	_addVals:
		mov		EAX, [EDI]
		add		sum, EAX
		add		EDI, 4
		loop	_addVals

	; display sum
	mDisplayString OFFSET sum_display

	push	OFFSET output
	push	sum
	call	WriteVal
	call	CrLf

	; get truncated average
	mov		EAX, sum
	mov		EBX, 10
	cdq
	idiv	EBX
	mov		average, EAX

	; print truncated average
	mDisplayString OFFSET average_display

	push	OFFSET output
	push	average
	call	WriteVal
	call	CrLf

	; outro
	push	OFFSET outro_display
	call	outro

	Invoke ExitProcess,0	; exit to operating system
main ENDP

introduction PROC
	
	; create stack
	push	EBP
	mov		EBP, ESP
	push	EDX

	; move/write intro
	mDisplayString [EBP+24]
	call	CrLf

	; move/write by
	mDisplayString [EBP+20]
	call	CrLf

	; move/write instructions
	call	CrLf
	mDisplayString [EBP+16]
	mDisplayString [EBP+12]
	mDisplayString [EBP+8]

	; terminte stack 
	pop		EDX
	pop		EBP
	ret		20

introduction ENDP

ReadVal PROC
	
	; create stack
	push	EBP
	mov		EBP, ESP
	push	EAX
	push	ECX
	push	EDX
	push	EDI

	; moves EDI (array) to EDI
	mov		EDI, [EBP+28]

	; get number from user 
	mGetString [EBP+24], [EBP+12], [EBP+32], [EBP+8]

	; checks if there is a byte
	_check:
	mov		EAX, [EBP+8]	; moves input size to EAX
	cmp		EAX, 1			; if there is a byte, jumps to digit (meaning its an integer)
	je		_digit
	cmp		EAX, 11			; if EAX >= 11 bytes, check to see if it is a sign
	jge		_sign			; if EAX < 11, then it is fine
	jl		_normal

	; if input is invalid
	_invalid:
		mDisplayString [EBP+20]
		call		CrLf
		mov			EAX, 0										; clears the value in array
		mov			[EDI], EAX
		mGetString	[EBP+16], [EBP+12], [EBP+32], [EBP+8]	; get number from user with the error prompt
		jmp			_check

	; if only one digit, then it must be an integer
	_digit:
		mov		ESI, [EBP+12]		; moves input to ESI
		lodsb
		cmp		AL, '0'				; if character less than 0, its invalid
		jl		_invalid
		cmp		AL, '9'				; if more than 9, its invalid 
		jg		_invalid
		sub		AL, '0'					; subtracts 48 from ascii value, giving the single digit
		movzx	EAX, AL
		add		[EDI], EAX
		jmp		_done


	; check for any signs 
	_sign:
		mov		ECX, [EBP+8]	; moves input size into ECX
		dec		ECX				; going to character before 
		mov		ESI, [EBP+12]	; moves input to ESI
		lodsb
		cmp		AL, '+'			; if there is a + in front, moves to see if its just 0
		je		_zeros
		cmp		AL, '-'			; if there is a - in front, moves to see if its just 0
		je		_zeros
		cmp		AL, '0'			; if it is null, moves to see if its just 0
		je		_zeros	
		jmp		_invalid		; if none, then invalid 

	; normal numbers
	_normal:
		mov		ECX, [EBP+8]		; moves input size into ECX
		mov		ESI, [EBP+12]		; moves input to ESI
		lodsb
		cmp		AL, '+'				; if there is a + in front, moves on
		je		_sign2
		cmp		Al, '-'				; if there is a - in front, moves on
		je		_sign2
		cmp		AL, '0'				; if it is not null, moves to double check number
		jne		_normal2

	; if sign or leading zero
	_sign2:
		dec		ECX
		cmp		ECX, 0
		je		_zeros2

	; check if user entered leading zeros
	_zeros:
		lodsb
		cmp		AL, 0		; if it is null, moves to next character
		je		_sign2
		cmp		AL, '0'		; if character less than 0, its invalid
		jl		_invalid
		cmp		AL, '9'
		jg		_invalid	; if more than 9, its invalid 

	; double check
	_normal2:
		cmp		ECX, 9		; If more than 10 digits, invalid
		jge		_invalid
		cmp		AL, '0'		; if character less than 0, its invalid
		jl		_invalid
		cmp		AL, '9'
		jg		_invalid	; if more than 9, its invalid 
		sub		AL, '0'		; to find the digit value
		movzx	EAX, AL
		push	EAX			; preserve EAX and ECX 
		push	ECX
		dec		ECX			; If ecx-1 = 0, at ones place
		cmp		ECX, 0
		je		_one
		mov		EAX, 1

	_xPlace:
		mov		EBX, 10
		mul		EBX
		loop	_xPlace

	; restore 
	pop		ECX
	pop		EBX				; digit value stored in EBX, not EAX b/c EAX holds the place value

	mul		ebx				; ebx * eax
	jc		_invalid		; if value  bigger than the operand size
	add		[EDI], EAX
	js		_invalid		; if value is signed 
	jmp		_loop

	_invalid2:
		; restore
		pop		ECX
		pop		EAX
		jmp		_invalid

	; if in the ones place
	_one:
		push	EAX						; preserve EAX 
		mov		ESI, [EBP+12]			; moves input to ESI
		lodsb
		cmp		AL, '-'					; if  not -, it is positive
		jne		_positive				

	_negative:
		pop		EAX
		mov		EBX, [EDI]
		neg		EBX
		mov		[EDI], EBX
		sub		[EDI], EAX		; if not signed, then too small
		jns		_invalid2		
		pop		ECX
		pop		EBX
		jmp		_done

	_positive:
		pop		EAX
		add		[EDI], EAX
		js		_invalid2		; if too big 
		pop		ECX
		pop		EBX
		jmp		_done

	_loop:
		lodsb
		cmp		ECX, 0
		je		_done
		loop	_normal2
	
	; if character are zero
	_zeros2:
		cmp		AL, 03		; if not null, not valid 
		jne		_invalid
		mov		EAX, 0
		mov		[EDI], EAX

	_done:
		pop		EDI
		pop		EDX
		pop		ECX
		pop		EAX
		pop		EBP
		ret		28

ReadVal	ENDP

WriteVal PROC

	; create stack 
	push	EBP
	mov		EBP, ESP
	push	EAX
	push	EBX
	push	ECX
	push	EDX
	push	EDI

	mov		ECX, 0				; clear for counter
	mov		EDI, [EBP+12]		; moves output to EDI
	add		EDI, 10				; goes to final element in array
	std							; sets direction flag
	mov		EAX, [EBP+8]		; moves input to EAX
	cmp		EAX, 0				; if >= 0, it is a positive value
	jge		_positive
	mov		ECX, 1		; value is negative				
	neg		EAX			

	_positive:
		mov		EDX, 0		 ; clear for division
		mov		EBX, 10
		div		EBX
		push	EAX
		mov		AL, DL		; moves remainder to AL
		add		AL, 48		; adds to convert and store 
		stosb
		pop		EAX			; preserve
		cmp		EAX, 0		; if > 0, it is positive
		jg		_positive
		cmp		ECX, 1		
		jne		_display


	_negative:
		mov		AL, '-'				; adds negative sign
		stosb

	_display:
		inc		EDI				; increase output and display
		mDisplayString EDI

		; terminate stack
		pop		EDI
		pop		EDX
		pop		ECX
		pop		EBX
		pop		EAX
		pop		EBP
		ret		8

WriteVal ENDP

outro PROC

	; create stack
	push	EBP
	mov		EBP, ESP

	call	CrLf
	mDisplayString [EBP+8]	; moves outro to EDX for display
	call	CrLf

	;terminate stack
	pop		EBP
	ret		4

outro ENDP

END main