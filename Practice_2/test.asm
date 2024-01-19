TITLE Programming Assignment #1    (Project01.asm)

; Author:									Andrew Pierno
;
; Description: Write and test a MASM program to perform the following tasks:
;	1. Display your name and program title on the output screen.
;	2. Display instructions for the user.
;	3. Prompt the user to enter two numbers.
;	4. Calculate the sum, difference, product, (integer) quotient and remainder of the numbers.
;	5. Display a terminating message.
;	EC: Validate second number is less than the first
; 	EC: Loop until user decides to quit
; 	EC: Calculates and displays division as floating point number rounded to .001

INCLUDE Irvine32.inc

.data
	greeting	byte	'testing this function',13, 10,  0
	another		byte	'this is another test',13,10,0


.code
main PROC
	push EBP
	mov		EBP, ESP
	sub		ESP, 8
	MOV		DWORD PTR	[ebp-4], 10
	mov		DWORD PTR	[ebp-8], 20
	mov		ESP, EBP
	POP		EBP
	ret
main ENDP
	INVOKe exitprocess, 0


END main