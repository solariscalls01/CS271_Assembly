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
count = 100
array	WORD	count	DUP(?)
space	BYTE	"  ", 13, 10, 0


.code
 main PROC

push offset array
push count
call ArrayFill

	exit	; exit to operating system
main ENDP

ArrayFill PROC
push ebp
mov	ebp, esp
pushad
mov ESI, [ebp + 12]
mov ecx, [ebp + 8]
cmp ecx, 0
je L2

L1:
	Mov	EAX, 10000h
	call	randomrange
	mov		[esi], ax
	add		ESI, type word
	call	writedec
	mov		EDX, offset	Space
	call	writestring
	loop L1
l2:	popad
	pop		EBP
	RET 8
ArrayFill ENDP

END main