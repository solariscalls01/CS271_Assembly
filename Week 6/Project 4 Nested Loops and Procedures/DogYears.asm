TITLE Dog Years Calculator	(DogYears.asm)

; Author: Brian Dy
; Last Modified: 10/3/2022
; OSU email address: Dyb@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number:                 Due Date: 
; Description: This program will introduce the programmer, get the user's name and age, calculate the
	;users age in "dog years", and report the result.

INCLUDE Irvine32.inc

DOG_FACTOR = 7



.data

userName	BYTE	33 DUP(0)		;string to be entered by the user
userAGE		DWORD	?				; integer to be entered by the user
intro_1		BYTE	"Hi, my name is Lassie, and I'm here to tell you your age in dog years!"	,0
prompt_1	BYTE	"What's your name?",0
intro_2		BYTE	"Nice to meet you, ", 0
prompt_2	BYTE	"What's your age?",0
dogAge		DWORD	?				; to be calculated... 
result_1	BYTE	"Wow, that's ", 0
result_2	BYTE	" in dog years!", 0
goodbye		BYTE	"So long and farewall ", 0


.code
main PROC

; Introduce the programmer
	mov		EDX, OFFSET intro_1
	call	WriteString
	call	CrLF


; get user's name
	mov		EDX, OFFSET prompt_1
	call	WriteString
	; Preconditions of Readstring: (1) Max length saved in ECX, (2) EDX holds pointer to string
	mov		EDX, OFFSET userName
	mov		ECX, 32
	call	Readstring


; Get the User's Age
	mov		EDX, OFFSET prompt_2
	call	WriteString
	; Preconditions of ReadDec: 
	call	ReadDec
	; Postconditions of ReadDec: Value is saved in EAX
	mov		userAge, EAX

; calculate age in dog years
	mov		EAX, userAge
	mov		EBX, DOG_FACTOR
	mul		EBX
	mov		dogAge, EAX
	

; report the result
	mov		EDX, OFFSET result_1
	call	WriteString
	mov		EAX, dogAge
	call	WriteDec
	mov		EDX, OFFSET result_2
	call	WriteString
	call	CrLF


; say goodbye
	mov		EDX, OFFSET goodbye
	call	WriteString
	mov		EDX, OFFSET	userName
	call	WriteString
	call	CrLF

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
