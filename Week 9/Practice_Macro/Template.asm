TITLE String Primitives and Macros       (Primes.asm)

; Author: Brian Dy
; Last Modified: 12/4/2022
; OSU email address: DyB@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 6                Due Date: 12/4/2022
; Description: A program to implement and test two macros for string processing. 

INCLUDE Irvine32.inc

; mGetString MACRO

mWrite	Macro	TEXT
	LOCAL	String
	.data
	string	Byte	Text,0
	.code
	push	EDX
	mov	EDX, offset	string
	call	WriteString
	POP		EDX
ENDM


.data
	
						
.code

main PROC

	mWrite	"Please enter your first name"


main ENDP

;-------------------------------------------------------------------------
END main