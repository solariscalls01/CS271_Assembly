TITLE Program 3 Data Validation, Looping, and Constants

; Author: Brian Dy
; Last Modified: 10/30/2022
; OSU email ADDress: DyB@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number:  3             Due Date: 10/30/2022
; Description: A program to allow a user to input signed integers and displays the sum of all negative numbers, the averages of those numbers, as well as the maximum number and minimum number. Program ends once a non-negative integer is given. 


INCLUDE Irvine32.INC

; (insert macro definitions here)

; Set the constants for the program for comparison operators 

CHECKPOSITIVE = 0	; Assigns a constant to check if the user inputs a non-negative number
TWOHUNDRED = -200
ONEHUNDRED = -100
FIFTY = -50
ONE = -1


; (insert constant definitions here)

.data

	Greeting			BYTE	"Welcome to the Integer Accumulator by Brian Dy", 13, 10, 0
	introduction		BYTE	"We will be accumulating user-input negative integers between the specified bounds, then displaying",13, 10
						BYTE	"statistics of the input values including minimum, maximum, and average values values, total sum,",13,10,"and total number of valid inputs.", 13,              10, 0
	getNamePrompt		BYTE	"What is your name? ", 0
	userName			BYTE	31 DUP(0)
	greetUser			BYTE	"Hello there, ", 0
	endMessage			BYTE	"So long there, ", 0
	instructions		BYTE	"Please enter numbers in [-200, -100] or [-50, -1].", 13, 10, 0
	instructions2		BYTE	"Enter a non-negative number when you are finished and input stats will be shown.", 13, 10, 0
	getNumberPrompt		BYTE	"Enter a number: ", 13, 10, 0
	userNumber			SDWORD	?
	errorMsg			BYTE	"This is not a number we're looking for (INVALID INPUT). Enter a number between [-200 and -100] or [-50 and -1]", 13, 10, 0
	maxNumber			SDWORD	0	
	minNumber			SDWORD	0
	sumValues			SDWORD	?
	roundedAvg			SDWORD	?
	storeNumber			SDWORD	?	; used to store number in a register for later 
	errorMessage2		BYTE	"Must enter a number between [-50, -1]", 13, 10,0 
	counter				SDWORD	0
	totalSum			SDWORD	0
	validNumbers		BYTE	" valid numbers were entered. ", 13, 10, 0
	sumSentence			BYTE	"The sum of your valid numbers is: ", 0
	getAverage			BYTE	"The average of your numbers is: ", 0
	minNumberSentence	BYTE	"The minimum valid number is: ", 0
	maxNumberSentence	BYTE	"The maximum valid number is: ", 0



.code
main PROC



; Print the greetings and intructions

	;	Print the introduction

	MOV		EDX,OFFSET greeting
	CALL	WriteString
	CALL	Crlf
	MOV		EDX, OFFSET	introduction
	CALL	WriteString
	CALL	Crlf

	;	Greet the user

	MOV		EDX, OFFSET greetUser
	CALL	WriteString
	MOV		EDX, OFFSET userName
	CALL	WriteString
	CALL	Crlf

	;	Display instructions for the user

	MOV		EDX, OFFSET	instructions
	CALL	WriteString
	CALL	Crlf
	MOV		EDX, OFFSET instructions2
	CALL	WriteString
	CALL	Crlf


; Get user input
;	Get the User's name

	MOV		EDX, OFFSET	getNamePrompt
	CALL	WriteString
	MOV		EDX, OFFSET userName
	MOV		ECX, 30
	CALL	ReadString
	CALL	Crlf


_GetNumber:	
	;	Get a valid number from the user

	MOV		EDX, OFFSET	getNumberPrompt
	CALL	WriteString
	CALL	ReadInt	
	CMP		EAX, CHECKPOSITIVE	
	JGE		_CheckPositive	; if user enters a non-negative number, program jumps to print data results
	JMP		_Check200		; checks the first condition if user input is < -200]



; Validation checks to determine if numbers are valid

_Check200:	
	; check if number is <= -200. If number satisfies the conditions, it jumps to check if user input number is <= -100, otherwise throws an error message

	CMP		EAX, TWOHUNDRED
	JL		_Error
	JMP		_Check100	


_Check100:	
	;check if the number is <= -100. If the numbers pass the condition, jump to the assignmax label in order to assign current maxNumber. 

	CMP		EAX, ONEHUNDRED
	JG		_Check50
	JMP		_CheckMax


_Check50:	
	;check if number is <= -50

	CMP		EAX, FIFTY
	JL		_Error
	JGE		_Check1


_Check1:	
	; check if number is <= -1. If the numbers pass the condition, jump to the assignmin label in order to assign current minNumber.

	CMP		EAX, ONE
	JMP		_CheckMax


_CheckPositive:	
	; check if number is positive. Will end the user input once the input is > -1
	JMP	_ValidNumbers



; Calculations

_ADDValue:	
	; sums the values of the valid numbers the user has inputted

	ADD		sumValues, EAX
	MOV		EAX, sumValues
	MOV		totalSum, EAX
	CALL	Crlf
	INC		counter		; increments the counter +1 and number is used to calculate the average of the valid number inputs
	JMP		_GetNumber 


_CheckMax:
	; checks the numbers in the range of [-50, -1]. If current max number > user input, maximum (closest from 0) valid user value entered will be assigned to maxNumber
	CMP		EAX, maxNumber
	JE		_AssignMin	;  uses the JE (equal) in order to make sure that it does not assign the same value to the minNumber. Otherwise, EAX is				assigned to the max number
	JL		_AssignMax	;	Required to initially set max number from original EAX value as starting maxNumber is set to 0. EAX from input will be < maxNumber which this is needed to assign a new maxNumber
	JG		_AssignMax	;	Once max number is assigned, this section is needed to determine and set maxNumber and find out if userinput > current maxNumber. 
	JMP		_AssignMin	

_AssignMax:
	; Assigns maxNumber after CheckMax checks if current max number is > user input. 
	MOV		maxNumber, EAX
	JMP		_AssignMin



_AssignMin:	
	; After maxNumber has been checked.  Will jump to this section to see if the minimum (farthest from 0) valid user value entered will be assigned to the minNumber. 
	CMP		EAX, minNumber
	JG		_ADDValue
	MOV		minNumber, EAX
	JMP		_ADDValue



; Display the results for all the items

_ValidNumbers:	
	; displays the total "valid numbers" the user has inputted
	CALL	Crlf
	MOV		EAX, counter
	CALL	WriteDec
	MOV		EDX, OFFSET validNumbers
	CALL	WriteString
	JMP		_DisplaySum

_DisplaySum:	
	; displays the sum of all the valid numbers the user has inputted

	CALL	Crlf
	MOV		EDX, OFFSET sumSentence
	CALL	WriteString
	MOV		EAX, totalSum
	CALL	WriteInt
	JMP		_DisplayMinNumber

_DisplayMinNumber:	
	; displays the minimum (farthest from 0) valid user value entered

	CALL	Crlf
	MOV		EDX, OFFSET minNumberSentence
	CALL	WriteString
	MOV		EAX, minNumber
	CALL	WriteInt
	JMP		_DisplayMaxNumber

_DisplayMaxNumber:	
	; displays the the maximum (closest from 0) valid user value entered

	CALL	Crlf
	MOV		EDX, OFFSET maxNumberSentence
	CALL	WriteString
	MOV		EAX, maxNumber
	CALL	WriteInt
	JMP		_DisplayAverage

_DisplayAverage:		
	; calculates and displays the average of the summed numbers divided by the amount of times the user has inputted a valid number 

	CALL	Crlf
	MOV		EDX, OFFSET	getAverage
	CALL	WriteString
	MOV		EDX, counter
	MOV		EAX, totalSum
	CDQ
	idiv	counter
	CALL	writeint
	CALL	Crlf
	JMP		_EndingMessage


_Error:		
	; display user error message if user inputs an invalid number

	MOV		EDX, OFFSET	errorMsg
	CALL	WriteString
	JMP		_GetNumber



; Closing statement

_EndingMessage:
	CALL	Crlf
	MOV		EDX, OFFSET endMessage
	CALL	WriteString
	MOV		EDX, OFFSET	userName
	CALL	WriteString
	CALL	Crlf


	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert ADDitional procedures here)

END main

