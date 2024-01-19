Arrays, Addressing and Stack-Passed Parameters 

; Author: Brian Dy
; Last Modified: 11/20/2022
; OSU email ADDress: DyB@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 5                Due Date: 11/20/2022
; Description: This file is provided as a template from which you may work
;              when developing assembly projects in CS271.

INCLUDE Irvine32.INC

; (insert macro definitions here)
ARRAYSIZE = 200
LO = 15
HI = 50
; (insert constant definitions here)

.data
intro				BYTE	"Generating, Sorting, and Counting Random integers!               Programmed by Brian Dy", 13, 10, 0
intro2				BYTE	"This program generates 200 random integers between 15 and 50, Inclusive.", 13, 10, 0
intro3				BYTE	"It then displays the original list, sorts the list using Bubble Sort method (referenced from book), displays", 13, 10
					BYTE	"the median value of the list, displays the list sorted in ascending order, and finally displays the number", 13, 10 
					BYTE	"of instances of each generated value, starting with the lowest number.", 13, 10, 0
randArray			DWORD	200 DUP(0)
errorMsg			BYTE	"Input invalid, please pick a number between [15 - 50]: ", 13, 10, 0
emptySpace			BYTE	"  ", 13, 10, 0
printStatement		BYTE	"Your unsorted random numbers: ", 13, 10, 0
MedianStatement		BYTE	"The median value of the array: ", 13, 10, 0
SortedStatement		BYTE	"Your sorted random numbers: ", 13, 10, 0
InstancesStatement	BYTE	"Your list of instances of each generated number, starting with the smallest value: ", 13, 10, 0
countArray			DWORD	200 DUP(0)	; initialize new Array to store count values for instances
ClosingStatement	BYTE	"Goodbye and thanks for using my program", 13, 10, 0

; (insert variable definitions here)

.code
main PROC
	; print the introduction for the program
	PUSH	OFFSET INTRO	; + 16 on the stack
	PUSH	OFFSET INTRO2	; + 12 on the stack
	PUSH	OFFSET intro3	 ; +8 stack
	CALL	INTRODUCTION	; +4 on the stack
	CALL	Randomize	; initialize the randomize module


	; Create the array
	PUSH	OFFSET	randArray	; + 20
	PUSH	ARRAYSIZE	; + 16
	PUSH	HI	; + 12
	PUSH	LO	; + 8
	CALL	fillArray


	; display the unsorted list 
	PUSH	OFFSET	printStatement	; +20
	PUSH	OFFSET	randArray	; + 16
	PUSH	ARRAYSIZE	; + 12
	PUSH	offset	emptySpace	; + 8
	CALL	displayArray	; + 4


	; Sort the Array
	PUSH	OFFSET randArray	; +8
	PUSH	ARRAYSIZE	; +4
	CALL	SortList	;


	; Print the Median Value of the Array
	PUSH	OFFSET	MedianStatement		; + 16
	PUSH	OFFSET	randArray	; + 12
	PUSH	ARRAYSIZE	; + 8
	CALL	displayMedian	; + 4


	; display the sorted list
	PUSH	OFFSET	SortedStatement ; +16
	PUSH	OFFSET	randArray ; +12
	PUSH	ARRAYSIZE ; + 8
	PUSH	OFFSET	emptySpace ; +4
	CALL	displayArray ; 


	; display the countList
	PUSH	OFFSET InstancesStatement	; + 24
	PUSH	OFFSET	randArray	; + 20
	PUSH	OFFSET	CountArray	; + 16
	PUSH	ARRAYSIZE	; + 12
	PUSH	OFFSET	emptySpace	; + 8
	CALL	countList	; + 4


	; Print the closing message
	PUSH	OFFSET	ClosingStatement
	CALL	ClosingMessage

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; ***************************************************************
Introduction PROC
; Procedure to introduce the program 
; Preconditions: None
; Registers Changed: EDX
; Receives: Receives Intro, Intro2, Intro3
; Returns: None

	PUSH	EBP
	MOV		EBP, ESP
	MOV		EDX, [EBP + 16]
	CALL	WriteString
	CALL	Crlf
	MOV		EDX, [EBP + 12]
	CALL	WriteString
	CALL	Crlf
	MOV		EDX, [EBP + 8]
	CALL	WriteString
	CALL	Crlf
	POP		EBP
	RET		12

Introduction ENDP
; ***************************************************************

; ***************************************************************

fillArray PROC
; Procedure set the array and fill the arrays with random numbers within 15-50 range
; Registers Changed: EAX
; Receives: Address for ARRAYSIZE, randArray, HI, LO
; Returns: None
	PUSH	EBP
	MOV		EBP, ESP
	MOV		ESI, [EBP + 20]	; Access randArray and put values into ESI
	MOV		ECX, [ebp + 16]	; Set ECX count from ARRAYSIZE
	
	_GenerateNumber:

		MOV		EAX, [EBP + 12]	; address for hi value
		SUB		EAX, [EBP + 8]	; hi value - low value and store that into EAX
		CALL	RandomRange
		ADD		EAX, [EBP + 8]	; ADD the lower value (15) into the EAX in order to be > 15
		MOV		[ESI], EAX	; store current value from EAX into current ESI
		ADD		ESI, TYPE randArray	; Increment the ESI by 4 bytes to access next memory ADDress
		loop	_generateNumber	; loops the value set from the ARRAYSIZE from line 112

	POP		EBP
	RET		16

fillArray ENDP
; ***************************************************************

; ***************************************************************

displayArray PROC
; Procedure to display the values in the arrays
; Preconditions: None
; Postconditions: None
; Registers Changed: EAX, EDX
; Receives: Address of the randArray, ARRAYSIZE, emptySpace, printStatement
; Returns: None
	PUSH	EBP
	MOV		EBP, ESP
	MOV		EDX, [EBP + 20]		; Address for print statement
	CALL	WriteString
	MOV		ESI, [EBP + 16]		; Address for data array
	MOV		ECX, [EBP + 12]	; Address for array size
	MOV		EDX, [EBP + 8]	; Address for printing empty spaces
	MOV		EBX, 0	; set counter for row
	
	_printNum:
	MOV		EAX, [ESI]	; moves current value from ESI to EAX
	CALL	writedec
	MOV		AL, 32	; print empty space
	CALL	WriteChar
	ADD		ESI, 4	; increment current ESI value to obtain next value
	INC		EBX	; increment the row counter
	CMP		EBX, 19	; compare row counter. If > 19, will jump to print out next row of numbers
	JG		_NextRow

	
	_nextNum:
	LOOP	_printNum
	POP		EBP
	CALL	CRLF
	RET	16

	_NextRow:
		CALL	CRLF
		MOV		EBX, 0	; set current row counter back to 0
		JMP		_nextNum
	
displayArray ENDP

; ***************************************************************

; ***************************************************************

sortList PROC
;-------------------------------------------------------
; BubbleSort
; Sort an array of 32-bit signed integers in ascending
; order, using the bubble sort algorithm.
; Receives: address to randArray and ARRAYSIZE
; Returns: nothing
;-------------------------------------------------------
PUSH	EBP
MOV		EBP, ESP
MOV		ECX, [EBP + 8]	; address for datasize
DEC		ECX				; decrement ECX by 1

L1:
PUSH	ECX				; save out loop count
MOV		ESI, [EBP + 12]	;	point to first value

L2: 
MOV		EAX, [ESI]		; get array value
CMP		[ESI + 4], EAX	; compare a pair of values
JG		L3				; if [ESI] < = [ESI + 4], no exchange
XCHG	EAX, [ESI + 4]	; exchange the pair
MOV		[ESI], EAX

L3:
ADD		ESI, 4			; move both pointers forward
LOOP	L2				; inner loop

POP		ECX				; retrieve outer loop count
LOOP	L1				; else repeat outer loop

L4:
POP		EBP
CALL	Crlf
RET		8


sortList ENDP

; ***************************************************************

; ***************************************************************

displayMedian PROC
; Procedure to get print the median value for the array 
; Preconditions: None
; Registers Changed: EAX, ESI, EDX
; Receives: address for ARRAYSIZE, medianStatement, randArray
; Returns: None
	; need to get the middle number of the array. Should take the whole array and divide by 2 which should produce the middle number. Need to loop through the ESI values until it hits the 100th digit. 
	PUSH	EBP
	MOV		EBP, ESP
	MOV		EDX, [EBP + 16]	; print the median statement
	CALL	WriteString
	MOV		ESI, [EBP + 12]	; address for the Data array

	_Arraydivision:
	; get the array size of 200 and divide by 2
	MOV		EBX, 2	; used to divide by 2
	MOV		EDX, 0	; remainder value
	MOV		EAX, LENGTHOF ARRAYSIZE; get the count of the arraysize (200) and move to EAX for division
	CDQ
	IDIV	EBX	
	MOV		ECX, EAX	; get loop counter for _FindMedian to loop through ESI values
	
	_FindMedian:
	;	loops through the ESI values and is INCremented by the ECX amount. ECX obtained from _arraydivision
	ADD		ESI, 4
	MOV		EAX, [ESI]
	Loop	_findMedian	; loops through the ESI stored values

	_findMedianAverage:
	; gets the two middle numbers from the median array list and divides them by two to get the average of the two medians. 
	MOV		EAX, [ESI]	; gets the current ESI number from _findMedian
	ADD		EAX, [ESI - 4]	; ADDs the value from previous ESI value from line 192 and ADDs to [ESI-4]
	MOV		EBX, 2	; divide the two numbers from line 192 and line 193 
	CDQ
	IDIV	EBX	; returns the result from ADDing (line 192 + line 193) / 2 to get the average of the two median numbers. 
	CALL	WriteDec
	CALL	Crlf
	POP		EBP
	RET		12

displayMedian ENDP
; ***************************************************************

; ***************************************************************

countList PROC
; Procedure to count the number of instances of each generated number starting with the smallest value
; Registers Changed: EAX, EDX, 
; Receives: address for randArray, CountArray, ARRAYSIZE, InstancesStatement, emptySpace
; Returns: None

	PUSH	EBP
	MOV		EBP, ESP
	MOV		EDX, [EBP + 24]	; address for printing statement
	CALL	WriteString
	MOV		ECX, [EBP + 12]	; loop counter for counting the array
	MOV		ESI, [EBP + 20]
	MOV		EDX, 0	; sets the row count

	_NewCount:
	MOV		EAX, 1	; initializes the EAX to start counting

	_Count:
	MOV		EBX, [ESI]	; get first value in the ESI 
	CMP		EBX, [ESI + 4]	; compare with the next value. if they match, increment EAX counter
	JNE		_printNum
	INC		EAX
	ADD		ESI, 4	; get the next ESI value
	loop	_Count

	_NextRow:
	CALL	CRLF
	MOV		EDX, 0
	JMP		_newCount

	_printNum:
	CALL	WriteDec
	MOV		AL, 32	; print empty space
	CALL	WriteChar
	ADD		ESI, 4	; increment the ESI value

	INC		EDX
	CMP		EDX, 19
	JE		_NextRow
	LOOP	_newCount	; loop back in order to reset EAX counter to 1 to start counting next values
	POP	EBP
	RET	20

countList ENDP
; ***************************************************************

; ***************************************************************
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
; (insert ADDitional procedures here)
; ***************************************************************
END main
