TITLE Elementary Arithmetic     (Proj1_azevedoe.asm)

; Author: Eric Azevedo
; Last Modified: 01/23/24
; OSU email address: azevedoe@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: Project 01               Due Date: 01/28/24
; Description: Write and test a MASM program to perform the following tasks: (1) Display your name and program title on the output screen.
;				(2) Display instructions for the user. (3) Calculate the sum and differences: (A+B, A-B, A+C, A-C, B+C, B-C, A+B+C).
;				(4) Display the results of the above calculations.(5) Display a closing message.

INCLUDE Irvine32.inc

; (insert macro definitions here)

; (insert constant definitions here)

.data

value_A		DWORD	?	; integer to be entered by the user for value A
value_B		DWORD	?	; integer to be entered by the user for value B
value_C		DWORD	?	; integer to be entered by the user for value C
intro_1		BYTE	"Elementary Arithmetic     by Eric Azevedo", 0 
intro_2		BYTE	"Enter 3 numbers A > B > C, and I'll show you the sums and differences.", 0
prompt_1	BYTE	"First number: ", 0
prompt_2	BYTE	"Second number: ", 0
prompt_3	BYTE	"Third number: ", 0
plus_0		BYTE	" + ", 0
minus_0		BYTE	" - ", 0
equals_0	BYTE	" = ", 0
calc_1		DWORD	?	; calculation of A + B		
calc_2		DWORD	?	; calculation of A - B
calc_3		DWORD	?	; calculation of A + C
calc_4		DWORD	?	; calculation of A - C
calc_5		DWORD	?	; calculation of B + C
calc_6		DWORD	?	; calculation of B - C
calc_7		DWORD	?	; calculation of A + B + C
goodbye_1	BYTE	"Thanks for using Elementary Arithmetic!  Goodbye!" 


.code
main PROC

; Introduction programmer 
	mov		EDX, OFFSET	intro_1
	call	WriteString
	call	CrLf


; Get three numbers 
	call	CrLf
	mov		EDX, OFFSET intro_2
	call	WriteString
	call	CrLf
	mov		EDX, OFFSET prompt_1
	call	WriteString
	call	ReadDec					; input for value A
	mov		value_A, EAX
	mov		EDX, OFFSET prompt_2
	call	WriteString
	call	ReadDec					; input for value B
	mov		value_B, EAX
	mov		EDX, OFFSET prompt_3
	call	WriteString
	call	ReadDec					; input for value C
	mov		value_C, EAX
	call	CrLf


; Calculate the data 
	mov		EAX, value_A	; A+B
	mov		EBX, value_B
	add		EAX, EBX
	mov		calc_1, EAX

	mov		EAX, value_A	; A-B
	mov		EBX, value_B
	sub		EAX, EBX
	mov		calc_2, EAX

	mov		EAX, value_A	; A+C
	mov		EBX, value_C
	add		EAX, EBX
	mov		calc_3, EAX

	mov		EAX, value_A	; A-C
	mov		EBX, value_C
	sub		EAX, EBX
	mov		calc_4, EAX

	mov		EAX, value_B	; B+C
	mov		EBX, value_C
	add		EAX, EBX
	mov		calc_5, EAX

	
	mov		EAX, value_B	; B-C
	mov		EBX, value_C
	sub		EAX, EBX
	mov		calc_6, EAX

	mov		EAX, value_A	; A+B+C
	mov		EBX, value_B
	mov		ECX, value_C
	add		EAX, EBX
	add		EAX, ECX
	mov		calc_7, EAX


; Return results 
	mov		EAX, value_A			; A+B
	call	WriteDec
	mov		EDX, OFFSET plus_0
	call	WriteString
	mov		EAX, value_B
	call	WriteDec
	mov		EDX, OFFSET equals_0
	call	WriteString
	mov		EAX, calc_1
	call	WriteDec
	call	CrLf

	mov		EAX, value_A			; A-B
	call	WriteDec
	mov		EDX, OFFSET minus_0
	call	WriteString
	mov		EAX, value_B
	call	WriteDec
	mov		EDX, OFFSET equals_0
	call	WriteString
	mov		EAX, calc_2
	call	WriteDec
	call	CrLf

	mov		EAX, value_A			; A+C
	call	WriteDec
	mov		EDX, OFFSET plus_0
	call	WriteString
	mov		EAX, value_C
	call	WriteDec
	mov		EDX, OFFSET equals_0
	call	WriteString
	mov		EAX, calc_3
	call	WriteDec
	call	CrLf

	mov		EAX, value_A			; A-C
	call	WriteDec
	mov		EDX, OFFSET minus_0
	call	WriteString
	mov		EAX, value_C
	call	WriteDec
	mov		EDX, OFFSET equals_0
	call	WriteString
	mov		EAX, calc_4
	call	WriteDec
	call	CrLf

	mov		EAX, value_B			; B+C
	call	WriteDec
	mov		EDX, OFFSET plus_0
	call	WriteString
	mov		EAX, value_C
	call	WriteDec
	mov		EDX, OFFSET equals_0
	call	WriteString
	mov		EAX, calc_5
	call	WriteDec
	call	CrLf

	mov		EAX, value_B			; B-C
	call	WriteDec
	mov		EDX, OFFSET minus_0
	call	WriteString
	mov		EAX, value_C
	call	WriteDec
	mov		EDX, OFFSET equals_0
	call	WriteString
	mov		EAX, calc_6
	call	WriteDec
	call	CrLf

	mov		EAX, value_A			; A+B+C
	call	WriteDec
	mov		EDX, OFFSET plus_0
	call	WriteString
	mov		EAX, value_B
	call	WriteDec
	mov		EDX, OFFSET plus_0
	call	WriteString
	mov		EAX, value_C
	call	WriteDec
	mov		EDX, OFFSET equals_0
	call	WriteString
	mov		EAX, calc_7
	call	WriteDec
	call	CrLf


; Goodbye
	call	CrLf
	mov		EDX, OFFSET goodbye_1
	call	WriteString
	call	CrLf


	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
