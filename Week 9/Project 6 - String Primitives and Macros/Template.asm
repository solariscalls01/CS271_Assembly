TITLE String Primitives and Macros       (Dy_B.asm)

; Author: Brian Dy
; Last Modified: 12/4/2022
; OSU email address: DyB@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 6                Due Date: 12/4/2022
; Description: A program to implement and test two macros for string processing. Uses two macros mGetString and mDisplayString and two procedures ReadVal and WriteVal which invoke the macros. User enters 10 signed integers which displays the sum and displays the averages. 

INCLUDE Irvine32.inc

MAXSIZE = 100

; ---------------------------------------------------------------------------------
; Name: mDisplayString
;
; A macro to print the desired string, which is stored in memory
;
; Preconditions: do not use edx arguments
;
; Receives:
; aString = array address
; 
; returns: prints the string 
; ---------------------------------------------------------------------------------
mDisplayString	MACRO	aString
	PUSH	EDX
	MOV		EDX, aString
	CALL	WriteString
	CALL	CrLf
	POP		EDX

ENDM

; -----------------------------------------------------------------------
; ---------------------------------------------------------------------------------
; Name: mGetString
;
; Displays the userprompt and stores the inputted string into memory
;
; Preconditions: do not use edx, ecx as arguments
;
; Receives:
; PROMPT = array address
; inString = array type
; MAXSIZE = array length
; sLen	= array size
;
; returns: inString = generated string address

; -----------------------------------------------------------------------
mGetString	MACRO	PROMPT, inString, MAXSIZE, sLEN
	PUSH		EDX
	PUSH		ECX
	MOV			EDX, PROMPT
	CALL		WriteString
	MOV			EDX, inString
	MOV			ECX, MAXSIZE
	CALL		ReadString
	MOV			sLen, EAX
	POP			ECX		
	POP			EDX

ENDM
; -----------------------------------------------------------------------


.data
	intro				Byte	"PROGRAMMING ASSIGNMENT 6: Designing low-level I/O Procedures", 13, 10, 0
	intro2				BYTE	"Written by: Brian Dy", 13, 10, 0
	instructions		BYTE	"Please provide 10 signed decimal integers. ", 13, 10
						BYTE	"Each number needs to be small enough to fit inside a 32 bit register. After you have finished inputting ", 13,10
						BYTE	"the raw numbers I will display a list of the integers, their sum, and their average value.", 0		
	prompt				BYTE	"Please enter a signed number: ", 0
	inString			BYTE	MAXSIZE DUP(?)	;input user string
	outString			BYTE	MAXSIZE DUP(?)	;out user string
	errorMsg			BYTE	"That is not a valid input.", 13, 10, 0
	enteredNums			BYTE	"You entered the following numbers: ", 13, 10, 0
	avg					BYTE	"The truncated average is: ", 13, 10, 0
	sum					BYTE	"The sum of these numbers is: ", 13, 10, 0
	sLen				DWORD	?
	storeNum			SDWORD	?
	numArray			SDWORD	10 DUP(?)	; array that stores our 10 numbers
	convertString		SDWORD	0
	sumNum				SDWORD	0
	endMsg				BYTE	"Thanks for playing. I don't know how to do the next part...", 13, 10, 0


.code

main PROC

; print the introduction
	PUSH	OFFSET	Intro	; EBP + 16
	PUSH	OFFSET	intro2	; EBP + 12
	PUSH	OFFSET	instructions	; EBP + 8
	CALL	Introduction	; EBP + 4

; setLoop
	MOV		ECX, 11  ; sets loop array to 10 for 10 signed integers in the array
	MOV		EBX, ECX	; store counter in EBX to keep track of ECX

_getUserInput:
	PUSH	OFFSET PROMPT	; EBP + 32
	PUSH	OFFSET storeNum	; EBP + 28
	PUSH	convertString	; EBP + 24
	PUSH	OFFSET inString	; EBP + 20
	PUSH	oFFSET outString	; EBP + 16
	PUSH	OFFSET MAXSIZE	; EBP + 12
	PUSH	sLen	; EBP + 8
	Call	ReadVal
	
	
	DEC		EBX
	MOV		ECX, EBX
	MOV		EAX,storeNum
	Add		sumNum, EAX
	STOSD	
	loop	_getuserInput

_printValues:
	PUSH	OFFSET enteredNums	; EBP + 20
	PUSH	OFFSET inString	; EBP + 16
	PUSH	OFFSET outString	; EBP + 12
	PUSH	sLen	; EBP + 8
	CALL	WriteVal

_printSum:
	PUSH	OFFSET sum	; EBP + 20
	PUSH	OFFSET inString	; EBP + 16
	PUSH	OFFSET outString	; EBP + 12
	PUSH	sLen	; EBP + 8
	CALL	WriteVal	

_printAverage:
	PUSH	OFFSET avg
	PUSH	OFFSET inString
	PUSH	OFFSET outString
	PUSH	sLen	; EBP + 8
	CALL	WriteVal

; endMsg
	PUSH	OFFSET	endMsg	
	CALL	ClosingMessage
	

main ENDP
; -----------------------------------------------------------------------
Introduction PROC
; Procedure to introduce the program 
; Preconditions: None
; Registers Changed: EDX
; Receives: Receives Intro, Intro2, Instructions
; Returns: None 

	PUSH	EBP
	MOV		EBP, ESP
	MOV		EDX, [EBP + 16]
	CALL	WriteString
	MOV		EDX, [EBP + 12]
	CALL	WriteString
	CALL	CrLf
	MOV		EDX, [EBP + 8]
	CALL	WriteString
	CALL	CrLf
	POP		EBP
	RET		12

Introduction ENDP
; -----------------------------------------------------------------------

; -----------------------------------------------------------------------
ReadVal PROC
; Procedure to read the value of the user
; Preconditions: None
; Registers Changed: ESI, EDI
; Receives: Receives storenum, convertstring, inString, MAXSIZE, sLen
; Returns: None

	PUSH	EBP
	MOV		EBP, ESP
	MOV		EDI, numArray

	_getString:
		mGetString	[EBP + 32], [EBP + 20], [EBP + 12], [EBP + 8]

		MOV		ESI, [EBP + 20]	; gets the user input to the ESI source
		MOV		EDI, [EBP + 28]	; 
		MOV		ECX, [EBP + 8]	; push length of input to ECX loop counter. e.g., if user enters 2 digits, will loop 2x, 3 digits = 3x etc... 

	_checkEmptyValue:	
		; checks if the user inputted value is an empty string e.g., if user just hits enter for the input value
		CMP		EAX, 0
		JZ		_error

	_checkOverFlow:
		; Checks if the user input is > 11 characters and prints an error message 
		MOV		EAX, [EBP + +8]
		CMP		EAX, 11
		JG		_error

	_checkSign:
		; checks whether the user inputs a + or - when entering an integer. 
		MOV		AL, [ESI]		; gets value of ESI and store into AL reg
		CMP		AL, 43			; 43 is the decimal sign for "+"
		JE		_positiveSign
		CMP		AL, 45			; 45 is the decimal sign for the "-"
		JE		_negativeSign	; if negative sign is detected jump to the _negativesign label
		JMP		_convertString	

	_positiveSign:	
		; check if user decides to enter a + in front of a number e.g., +31
		INC		ESI
		DEC		ECX
		JMP		_convertString
	
	_negativeSign:
		; checks if user decides to enter a signed integer "-" e.g., -21
		inc		ESI		; increment the ESI counter to access the - value. Hex value for negative sign = 2d
		DEC		ECX		; decrement ECX counter due to the '-' sign digit. e.g., -1 is considered 2 values therefore decrease ECX to only account for the 1. 


	_convertString:
		LODSB	; puts byte in AL register 

	; Check if value is between 48-57 for the decimal values to convert to char string numbers
		CMP AL, 48
		JL	_error
		CMP	AL, 57
		JG	_error

		PUSH		EBX			; preserve the loop counter to add back into ECX
		SUB			AL, 48
		MOV			EBX, [ebp+24]
		PUSH		EAX
		MOV			EAX, 10d		; gets ready to add the value to 10 times the current total
		MUL			EBX
		MOV			EBX, EAX
		POP			EAX			; preserve the value back into EAX 
		ADD			EBX, EAX	; adds the strings together 
		MOV			[EBP + 24], EBX		; store into the convertstring variable 
		POP			EBX					; preserve loop counter back to EBX
		LOOP		_convertString

	_finish:
	POP		EBP
	RET		28

	_error:
	mDisplayString	OFFSET	errorMsg	; uses MACRO to print error message if incorrect input
	INC		EBX		; preserves the loop counter incase of error message to add back to ECX
	JMP	_finish


ReadVal ENDP
; -----------------------------------------------------------------------

; printSum
WriteVal PROC
	CALL	CRLF
	PUSH	EBP
	MOV		EBP, ESP
	MOV		EDX, [EBP + 20]
	CALL	WriteString


	POP	EBP
	RET 16

; -----------------------------------------------------------------------

; printAvg

	CALL	CRLF
	PUSH	EBP
	MOV		EBP, ESP
	MOV		EDX, [EBP + 20 ]
	CALL	WriteString


	POP	EBP
	RET 16
WriteVal ENDP



; -----------------------------------------------------------------------

ClosingMessage PROC
; Procedure to print a closing statement from the .data endMsg 
; Preconditions: None
; Postconditions: None
; Registers Changed: EDX
; Receives: None
; Returns: None
	CALL	CRLF
	PUSH	EBP
	MOV		EBP, ESP
	MOV		EDX, [EBP + 8]
	CALL	WriteString
	RET

ClosingMessage ENDP
;-------------------------------------------------------------------------
END main