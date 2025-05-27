TITLE Project 3 - Data Validation, Looping, and Constants     (Proj3_azevedoe.asm)

; Author: Eric Azevedo 
; Last Modified: 02/07/24
; OSU email address: azevedoe@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 3                 Due Date: 02/11/24
; Description: A program that takes user-input negative integers between the specified bounds, then displaying statistics of the input values including minimum, maximum, and average values values, total sum, and total number of valid inputs. 

INCLUDE Irvine32.inc

; (insert macro definitions here)

LOWER_RANGE_1 = 200
UPPER_RANGE_1 = 100
LOWER_RANGE_2 = 50
UPPER_RANGE_2 = 1

.data

intro_1				BYTE	"Welcome to the Integer Accumulator by Eric Azevedo", 0
intro_2				BYTE	"We will be accumulating user-input negative integers between the specified bounds, then displaying statistics of the input values including minimum, maximum, and average values values, total sum, and total number of valid inputs.", 0
intro_3				BYTE	"What is your name? ", 0
user_name			BYTE	33	DUP(0)		;string to be entered by user
intro_4				BYTE	"Hello there, ", 0
prompt_1			BYTE	"Please enter numbers in [-200, -100] or [-50, -1].", 0
prompt_2			BYTE	"Enter a non-negative number when you are finished, and input stats will be shown.", 0
prompt_3			BYTE	"Enter number: ", 0
value_input			SDWORD	?				;value to be entered by user
invalid_input		BYTE	"This is not a number we're looking for (Invalid Input)!", 0
response_1_1		BYTE	"You entered ", 0
amount_num			SDWORD	0				;to be determined
response_1_2		BYTE	" vaild numbers.", 0
response_2			BYTE	"The maximum valid number is ", 0
max_num				SDWORD	200				;set to lowest value possible (will be negated later) so that the vaild values will overwrite this
response_3			BYTE	"The minimum valid number is ", 0
min_num				SDWORD	1				;set to the highest value possible (will be negted later) so that the vaild values will overwrite this
response_4			BYTE	"The sum of your valid numbers is ", 0
sum_num				SDWORD	?				;to be determined
response_5			BYTE	"The rounded average is ", 0
round_num			SDWORD	?				;to be determined
unique_message		BYTE	"You did not input any values. Why?", 0
outro_1				BYTE	"We have to stop meeting like this. Farewell, ", 0

.code
main PROC


;introduce user
	mov		EDX, OFFSET intro_1
	call	WriteString
	call	CrLf
	mov		EDX, OFFSET	intro_2
	call	WriteString
	call	CrLf


;get user's name
	mov		EDX, OFFSET	intro_3
	call	WriteString
	mov		EDX, OFFSET user_name
	mov		ECX, 32
	call	ReadString
	mov		EDX, OFFSET intro_4
	call	WriteString
	mov		EDX, OFFSET user_name
	call	WriteString
	call	CrLf


;prompt asking user to enter numbers
	call	CrLf
	mov		EDX, OFFSET prompt_1
	call	WriteString
	call	CrLf
	mov		EDX, OFFSET	prompt_2
	call	WriteString
	call	CrLf

;negate the proper values
	neg		max_num
	neg		min_num


;input user's numbers 
_input:
	call	CrLf
	mov		EDX, OFFSET prompt_3
	call	WriteString
	call	ReadInt
	mov		value_input, EAX


_signFlagCheck:
	JNS		_NonNegativeInput	


_lR1:
	mov		EBX, LOWER_RANGE_1
	neg		EBX
	cmp		value_input, EBX						;if input is less than -200, jump to invaild input
	jl		_InvaildInput


_uR2:
	mov		EBX, UPPER_RANGE_2
	neg		EBX
	cmp		value_input, EBX						;if input is greater than -1, jump to nonnegative input
	jg		_NonNegativeInput

_uR1:
	mov		EBX, UPPER_RANGE_1 
	neg		EBX
	cmp		value_input, EBX						;if input is less than -100, jump to vaild input 
	jle		_VaildInput


_lR2:
	mov		EBX, LOWER_RANGE_2 
	neg		EBX
	cmp		value_input, EBX						;if input is greater than -50, jump to vaild input. If less than, invailed input
	jge		_VaildInput
	jmp		_InvaildInput


_vaildInput:
	mov		EAX, value_input
	add		amount_num, 1							;will add 1 to amount num to represent the amount of vaild numbers					
	add		sum_num, EAX							;add vaild num to sum num to represent the sum of all the vaild numbers
	cmp		max_num, EAX
	jle		_AddMax


_continueVaildInput:
	cmp		min_num, EAX
	jge		_AddMin


_continueVaildInput2:
	jmp		_Input


_addMax:
	mov		max_num, EAX							;move vaild input into max_num since vaild input is the max
	jmp		_ContinueVaildInput


_addMin:
	mov		min_num, EAX							;move vaild input into min num since vaild input is the min
	jmp		_ContinueVaildInput2
	

_invaildInput:
	mov		EDX, OFFSET invalid_input
	call	WriteString
	jmp		_Input


;comfirmation of number of inputs 
_nonNegativeInput:
	mov		EAX, amount_num							;if user did not input any values
	mov		EBX, 0
	cmp		EAX, EBX
	je		_uniqueMessage
	call	CrLf
	mov		EDX, OFFSET response_1_1
	call	WriteString
	mov		EAX, amount_num
	call	WriteDec
	mov		EDX, OFFSET response_1_2
	call	WriteString
	call	CrLf


;results
	mov		EDX, OFFSET response_2	
	call	WriteString
	mov		EAX, max_num
	call	WriteInt
	call	CrLf
	mov		EDX, OFFSET response_3
	call	WriteString
	mov		EAX, min_num
	call	WriteInt 
	call	CrLf
	mov		EDX, OFFSET	response_4
	call	WriteString
	mov		EAX, sum_num
	call	WriteInt
	call	CrLf


;calculate and give average response
	mov		EAX, sum_num
	cdq
	idiv	amount_num
	mov		round_num, EAX
	mov		EDX, OFFSET response_5
	call	WriteString
	mov		EAX, round_num
	call	WriteInt
	call	CrLf
	jmp		_outro


_uniqueMessage:
	call	CrLf
	mov		EDX, OFFSET unique_message	
	call	WriteString
	call	CrLf

_outro:
;outro
	call	CrLf
	mov		EDX, OFFSET outro_1
	call	WriteString
	mov		EDX, OFFSET user_name
	call	WriteString
	call	CrLf


	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
