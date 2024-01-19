TITLE Program Template     (template.asm)

; Author: 
; Last Modified:
; OSU email address: ONID_ID@oregonstate.edu
; Course number/section:   CS271 Section ???
; Project Number:                 Due Date:
; Description: This file is provided as a template from which you may work
;              when developing assembly projects in CS271.

INCLUDE Irvine32.inc

; (insert macro definitions here)
UPPERLIMIT = 200
LOWERLIMIT = 1
; (insert constant definitions here)

.data

	Greeting		Byte	"Prime Numbers Programmed by Brian Dy ",13, 10, 0
	Intro			Byte	"Enter the number of prime numbers you would like to see.", 13, 10, 0
	Intro2			Byte	"I'll accept the orders for up to 200 primes.", 13, 10, 0
	Instructions	Byte	"Enter the number of primes to display [1 ... 200]: ", 0
	errorMsg		BYTE	"No primes for you! Number out of range. Try Again!", 13, 10, 0
	lowerValue		SDWORD	0
	userInput		SDWORD	?
	out1			BYTE	"The  prime numbers are: ", 13, 10, 0
	endMsg			BYTE	13, 10, "Not the cleanest looking code, but get's the job done (I think). Thanks.", 13, 10, 0
	printPrimes		SDWORD	?
	threeSpaces		BYTE	"   ", 0
	nextRow			DWORD	0		; sets the first row for the first 10 prime numbers shown


; (insert variable definitions here)

.code
main PROC
; Display the introduction and programmers name
	CALL	Introduction
; Get the user input data ranging from 1 - 200
	CALL	getUserData
; Show the prime numbers depending on what the user would like to see
	CALL	showPrimes
; Display a closing statement
	CALL	farewell

	Invoke ExitProcess,0	; exit to operating system
main ENDP


; ------------------------------------------------------
Introduction PROC
; Procedure to introduce the program.
; Preconditions: rules1 and rules2 are strings that describe the program and rules. 
; Postconditions: EDX changed

; Print the greeting and introductions
	MOV		EDX, OFFSET Greeting
	CALL	WriteString
	MOV		EDX, OFFSET Intro
	CALL	WriteString
	MOV		EDX, OFFSET Intro2
	CALL	WriteString
	CALL	Crlf
	RET
Introduction ENDP
; ------------------------------------------------------

; ------------------------------------------------------
getUserData PROC
_getUserData: 
; Get User Input
	MOV		EDX, OFFSET	Instructions
	CALL	WriteString
	MOV		EDX, OFFSET	userInput
	CALL	WriteString
	CALL	ReadInt			; user input in EAX
	MOV		UserInput, EAX		; store value into EBX register for later
	MOV		ECX, Userinput
	CMP		EAX, UPPERLIMIT
	JG		_Validate
	CMP		EAX, LOWERLIMIT
	JL		_Validate
	RET

	_Validate:
		MOV		EDX, OFFSET errorMsg
		CALL	WriteString
		JMP		_getUserData 
		RET

getUserData ENDP

; ------------------------------------------------------


; ------------------------------------------------------

showPrimes PROC
	; Display the intro for Prime number sentence
	CALL	Crlf
	mov		EDX, OFFSET out1
	CALL	WriteString
	
; Start checking if the numbers are prime starting with the value 2		
_CheckPrimes:
	MOV		EAX, Userinput		; Resets the EAX to evaluate appropriately with modulo operators
	INC		lowervalue			; increment this every loop until it hits the userinputted value
	CMP		nextRow, 10
	JE		_nextRow
	JMP		_Skip1

_Skip1:
	CMP		lowervalue, 1
	JE		_CheckPrimes
	JMP		_isDivisibleby2

_isDivisibleby2:
	CMP		lowervalue, 2
	JE		_printPrime
	MOV		EDX, 0				; set remainder value to 0
	MOV		EBX, 2		; set the uservalue to be divided by 2
	MOV		EAX, lowervalue
 	DIV		EBX
	CMP		EDX, 0		; if EDX has a remainder, then need to check if the value is divisible by 3
	JG		_isDivisibleby3
	JE		_CheckPrimes

_printPrime:
; Prints the prime number if it passes all the checksf
	MOV		EAX, lowervalue		
	CALL	WriteDec
	MOV		EDX, OFFSET	threespaces
	CALL	WriteString
	INC		nextRow
	LOOP	_CheckPrimes
	RET

_isDivisibleby3:
	CMP		lowervalue, 3
	JE		_printPrime
	MOV		EDX, 0
	MOV		EBX, 3
 	MOV		EAX, lowervalue
	DIV		EBX
	CMP		EDX, 0
	JE		_CheckPrimes
	JG		_isDivisibleby5


_isDivisibleby5:
	CMP		lowervalue, 5
	JE		_printPrime
	MOV		EDX, 0
	MOV		EBX, 5
	MOV		EAX, lowervalue
	DIV		EBX
	CMP		EDX, 0
	JE		_CheckPrimes
	JG		_isDivisibleby7

_isDivisibleby7:
	CMP		lowervalue, 7
	JE		_printPrime
	MOV		EDX, 0
	MOV		EBX, 7
	MOV		EAX, lowervalue
	DIV		EBX
	CMP		EDX, 0
	JE		_CheckPrimes
	JG		_isDivisibleby11

_isDivisibleby11:
	CMP		lowervalue, 11
	JE		_printPrime
	MOV		EDX, 0
	MOV		EBX, 11
	MOV		EAX, lowervalue
	DIV		EBX
	CMP		EDX, 0
	JE		_CheckPrimes
	JG		_printPrime

_nextRow:
	Call	Crlf
	MOV		nextRow, 1		; resets the row count for the next row
	JMP		_CheckPrimes
showPrimes ENDP

; ------------------------------------------------------

farewell PROC
	CALL	Crlf
	MOV		EDX, OFFSET	endMsg
	CALL	WriteString
	RET

farewell ENDP

; ------------------------------------------------------




; (insert additional procedures here)

END main
