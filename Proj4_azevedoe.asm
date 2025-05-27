TITLE Nested Loops / Procedures      (Proj4_azevedoe.asm)

; Author: Eric Azevedo
; Last Modified: 02/25/24
; OSU email address: azevedoe@oregonstate.edu
; CS271 Section 400
; Project Number:  4               Due Date: 02/25/24
; Description: A program to calculate prime numbers

INCLUDE Irvine32.inc

; (insert macro definitions here)

UPPER_BOUND = 200
LOWER_BOUND = 1

.data

intro				BYTE		"Prime Numbers Programmed by Eric", 0
prompt_1			BYTE		"Enter the number of prime numbers you would like to see.", 0
prompt_2			BYTE		"I’ll accept orders for up to 200 primes.", 0
input_prompt		BYTE		"Enter the number of primes to display [1 ... 200]: ", 0
input				DWORD		?			; to be entered by user
out_of_range		BYTE		"No primes for you! Number out of range. Try again.", 0
primes				DWORD		200 DUP (?)	; primes to be stored by program 
potential_primes	DWORD		?
outro				BYTE		"Results certified by Eric. Goodbye." , 0

.code
main PROC

; introduction
	mov			EDX, OFFSET intro
	call		WriteString
	call		CrLf

; prompt
	call		CrLf
	mov			EDX, OFFSET prompt_1
	call		WriteString
	call		CrLf
	mov			EDX, OFFSET prompt_2
	call		WriteString
	call		CrLf

; getUserDate
_Input:
	call		CrLf
	mov			EDX, OFFSET input_prompt
	call		WriteString
	call		ReadDec
	mov			input, EAX

; validate
_Input_Greater:
	mov			EBX, UPPER_BOUND
	cmp			EAX, EBX
	jg			_OutOfRange		; if user’s input is greater than the upper bound (200), will jump to out of range error


_Input_Lesser:
	mov			EBX, LOWER_BOUND
	cmp			EAX, EBX
	jl			_OutOfRange		; if user’s input is less than the lower bound (1), will jump to out of range error
	jmp			_PotentialPrime

_OutOfRange:
	mov			EDX, OFFSET out_of_range
	call		WriteString
	jmp			_Input

; show prime
_PotentialPrime:
	mov			ECX, input				; loop counter
	mov			EAX, 2 					; 1st number to see if it is a prime
	mov			potential_primes, EAX

_Divide:
	mov			EDX, EAX
	dec			EAX
	mov			ESI, EAX			; loop counter 
	mov			EAX, EDX
	mov			EBX, 2

_Loop:
	cmp			ESI, 0
	je			_NotPrime
	cmp			EAX, EBX	; for 2 (since it is prime)
	je			_IsPrime			
	mov			EDX, 0
	div			EBX
	cmp			EDX, 0			; if EAX/EBX has remainder of 0, not prime
	je			_NotPrime
	inc			EBX
	dec			ESI
	jmp			_Loop

_IsPrime:
	mov			EAX, potential_primes
	mov			primes, EAX
	mov			EDX, primes
	call		WriteDec

_NotPrime:
	mov			EAX, potential_primes
	inc			EAX
	mov			potential_primes, EAX
	loop		_Divide

; farewell
_Outro:
	call		CrLf
	mov			EDX, OFFSET outro
	call		WriteString	


	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
