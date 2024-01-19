TITLE Program Nested Loops and Procedures   (template.asm)

; Author: Brian Dy
; Last Modified: 11/13/2022
; OSU email address: DyB@oregonstate.edu
; Course number/section:    CS271 Section 400
; Project Number: 4                 Due Date: 11/13/2022
; Description: A program to showcase the prime numbers ranging from 1 - 200. User enters the number of primbes to be displayed

INCLUDE Irvine32.inc

; (insert macro definitions here)
UPPERLIMIT = 200
LOWERLIMIT = 1
TRUE = 1
FALSE = 0
; (insert constant definitions here)

.data

	Greeting		Byte	"Prime Numbers Programmed by Brian Dy ",13, 10, 0
	Intro			Byte	"Enter the number of prime numbers you would like to see.", 13, 10, 0
	Intro2			Byte	"I'll accept the orders for up to 200 primes.", 13, 10, 0
	Instructions	Byte	"Enter the number of primes to display [1 ... 200]: ", 0
	errorMsg		BYTE	"No primes for you! Number out of range. Try Again!", 13, 10, 0
	lowerValue		SDWORD	0	; variable to set the denominator. Value is incremented after each iteration
	userInput		SDWORD	?	
	out1			BYTE	"The  prime numbers are: ", 13, 10, 0
	endMsg			BYTE	13, 10, "These are your prime numbers. Thanks.", 13, 10, 0
	threeSpaces		BYTE	"   ", 0	; prints 3 blank spaces after each prime number has been printed
	nextRow			DWORD	0		; sets the first row for the first 10 prime numbers shown
	checkCount		SDWORD	?	; variable to end the loop prime procedure. Userinputted value gets stored here and is decremented after each iteration. If Checkcount = 0, loop ends. 


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


;----------------------------------------------------------
Introduction PROC
; Procedure to introduce the program.
; Preconditions: Intro and Intro2 are strings that describe the program and rules. 
; Postconditions: EDX changed
; Receives: None
; Returns: None
;---------------------------------------------------------- 

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
;----------------------------------------------------------

;----------------------------------------------------------
getUserData PROC
; Procedure to get the user data to check for the prime numbers. 
; Preconditions: Validates the numbers between 1 - 200. If number is > 200, will prompt user to try again
; Postconditions: Changes the values of EDX, ECX
; Receives: Receives the userInputted value. 
; Returns; None
;----------------------------------------------------------
_getUserData: 
; Print the instructions for the user and get the userInputted value
	MOV		EDX, OFFSET	Instructions
	CALL	WriteString
	MOV		EDX, OFFSET	userInput
	CALL	WriteString
	CALL	ReadInt			
	MOV		UserInput, EAX		; store value into EAX register to the userInput value
	CMP		EAX, UPPERLIMIT	; Checks for number validation. If > 200, will jump to _validate label and print error message
	JG		_Validate
	CMP		EAX, LOWERLIMIT	;	Checks for number validation. if < 1, will jump to _validate label and print error message
	JL		_Validate
	RET

	_Validate:
	; Validation for 1 < n < 200. Will print error message and ask user to try again. 
		MOV		EDX, OFFSET errorMsg
		CALL	WriteString
		JMP		_getUserData 
		RET

getUserData ENDP

;----------------------------------------------------------


;----------------------------------------------------------

showPrimes PROC
; display n prime numbers; utilize counting loop and the LOOP instruction to keep track of the number primes displayed
; candidate primes are generated within counting loop and are passed 
; Preconditions: EAX value must be validated from the getUserData PROC
; Postconditions: changes the EAX, EBX, ECX
; Receives: Receives the userInput value from getUserData PROC
; Returns: None
;----------------------------------------------------------
	; Display the intro for Prime number sentence
	CALL	Crlf
	mov		EDX, OFFSET out1
	CALL	WriteString

	MOV		ECX, EAX		; save userInput value to the ECX register to compare lowerbound for comparison / stop point
	MOV		checkCount, EAX	; Save the EAX user input value to the checkCount. When checkout = 0, the program stops
	MOV		EBX, 2			; start the denominator count to 2.	
	startLoop:
	; starts the loop to run through the denominator and move to the EAX value. 
		MOV		EAX, EBX	; 
		CALL	isPrime
		CMP		EAX, 1		; if the value of EAX is 1 (TRUE)
		JNE		nextNum		; if EAX is < 1, (FALSE), will jump to the nextNum label and increment ECX and EBX to check for the next values 
		INC		nextRow		; increments the nextRow counter and compares if nextRow = 11. 
		CMP		nextRow, 11
		JE		_nextRow	; Jumps to the _nextRow label if value = 11 in order to clear the line and start a new line for the next numbers to print. 
		MOV		EAX, EBX	; Moves the stored EBX value to EAX in order to print the prime number
		call	WriteDec
		
		MOV		EDX, offset threespaces	; prints 3 spaces after the writeDec
		call	WriteString
		DEC		checkCount	; decrements the checkCount from the initial user inputted value. 
		JMP		nextNum

	nextNum:
	; if checkcount = 0, it will exit the procedures and jump to the closing farewell statement, else continue the loop
		INC		EBX		; increments the EBX (numerator)
		CMP		CheckCount, 0	
		JE		farewell	; if checkCount = 0, will jump to the farewell Procedure, else continue with the loop
		Loop	startLoop
		call	Crlf
		ret

_nextRow:
	Call	Crlf
	MOV		nextRow, 0		; resets the row count to 0 for the next row
	JMP		startLoop

	
showPrimes ENDP
;----------------------------------------------------------

;----------------------------------------------------------

isPrime PROC
; Procedure to check if the numbers are prime.
; Preconditions: userInputted value must be in range 1 - 200
; Postconditions: Changes the EAX values
; Receives: EAX value from showPrimes PROC
; Returns: sets EAX to 0 or 1 depending on EDX value
	MOV		ECX, EAX	; gets the value from EAX (received from EBX) and stores in the ECX register
	MOV		lowerValue, 2	; sets the value 2 to the lower value

startLoop:
	CMP		lowerValue, ECX	
	JE		printPrime	; if the lower value is equal to the ECX value, means there is nothing else that can divide the ECX value and thus, will be prime
	MOV		EDX, 0	; sets the EDX (remainder value) to 0
	MOV		EAX, ECX	; moves the value from ECX to EAX in order to divide numerator (EAX) from denominator (lowerValue)	
	DIV		lowerValue
	CMP		EDX, 0	; check if there is a remainder
	JE		notPrime	; if EDX = 0 (meaning there are multiple divisors), else not a prime value
	INC		lowerValue	; increments the lower value to the next number and restarts the loop (increments the denominator) 
	JMP		startLoop

printPrime:
; sets the value of the EAX to 1 if the number is a prime number and returns to the showPrimes PROC and continues the rest of the procedure following the call sign
	MOV		EAX, TRUE
	RET

notPrime:
; ; sets the value of the EAX to 0 if the number is not a prime number and returns to the showPrimes PROC and continues the rest of the procedure following the call sign
	MOV		EAX, FALSE
	RET

	
isPrime ENDP
;----------------------------------------------------------


;----------------------------------------------------------

farewell PROC
; Procedure to print a closing statement from the .data endMsg 
; Preconditions: None
; Postconditions: None
; Receives: None
; Returns: None
;----------------------------------------------------------
	CALL	Crlf
	MOV		EDX, OFFSET	endMsg
	CALL	WriteString

farewell ENDP

;----------------------------------------------------------




; (insert additional procedures here)

END main
