TITLE Program Template     (template.asm)

; Author: Brian Dy
; Last Modified: 11/20/2022
; OSU email ADDress: DyB@oregonstate.edu
; Course number/section:   CS271 Section 400
; ProJEct Number: 5                Due Date: 11/20/2022
; Description: This file is provided as a template from which you may work
;              when developing assembly proJEcts in CS271.

INCLUDE Irvine32.INC

; (insert macro definitions here)
ARRAYSIZE = 200
LO = 15
HI = 50
; (insert constant definitions here)

.data
intro				BYTE	"Generating, Sorting, and Counting Random integers!               Programmed by Brian Dy", 13, 10, 0
intro2				BYTE	"This program generates 200 random integers between 15 and 50, INClusive.", 13, 10, 0
intro3				BYTE	"It then displays the original list, sorts the list, displays the median value of the list,", 13, 10
					BYTE	"displays the list sorted in ascending order, and finally displays the number of instances of each", 13, 10
					BYTE	"generated value, starting with the lowest number.", 13, 10, 0
dataArray			DWORD	200 DUP(0)
errorMsg			BYTE	"Input invalid, please pick a number between [15 - 50]: ", 13, 10, 0
emptySpace			BYTE	"  ", 13, 10, 0

printStatement		BYTE	"Your unsorted random numbers: ", 13, 10, 0
MedianStatement		BYTE	"The median value of the array: ", 13, 10, 0
SortedStatement		BYTE	"Your sorted random numbers: ", 13, 10, 0
InstancesStatement	BYTE	"Your list of instances of each generated number, starting with the smallest value: ", 13, 10, 0
countArray			DWORD	200 DUP(0)
ClosingStatement	BYTE	"Goodbye and thanks for using my program", 13, 10, 0

; (insert variable definitions here)

.code
main PROC
	; print the introduction for the program
	PUSH	OFFSET INTRO	; + 16 on the stack
	PUSH	OFFSET INTRO2	; + 12 on the stack
	PUSH	OFFSET intro3	 ; +8 stack
	CALL	INTRODUCTION	; +4 on the stack


	; Create the array
	PUSH	OFFSET	dataArray	; + 20
	PUSH	ARRAYSIZE	; + 16
	PUSH	HI	; + 12
	PUSH	LO	; + 8
	CALL	fillArray


	; display the unsorted list 
	PUSH	OFFSET	printStatement	; +20
	PUSH	OFFSET	dataArray	; + 16
	PUSH	ARRAYSIZE	; + 12
	PUSH	offset	emptySpace	; + 8
	CALL	displayArray	; + 4
	CALL	Crlf


	; Print the Median Value of the Array
	PUSH	OFFSET	MedianStatement		; + 16
	PUSH	OFFSET	dataArray	; + 12
	PUSH	ARRAYSIZE	; + 8
	call	displayMedian	; + 4


	; Sort the Array
	PUSH	OFFSET DataArray	; +8
	PUSH	ARRAYSIZE	; +4
	CALL	SortList	;


	; display the sorted list
	PUSH	OFFSET	SortedStatement ; +16
	PUSH	OFFSET	DataArray ; +12
	PUSH	ARRAYSIZE ; + 8
	PUSH	OFFSET	emptySpace ; +4
	CALL	displayArray ; 

	; display the countList
	PUSH	OFFSET InstancesStatement	; + 24
	PUSH	OFFSET	DataArray	; + 20
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
; Postconditions: None
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


fillArray PROC
; Procedure set the array and fill the arrays with random numbers within 15-50 range
; Postconditions: EBP, ECX, EAX
; Receives: Address for ARRAYSIZE, dataArray, HI, LO
; Returns: None
	PUSH	EBP
	MOV		EBP, ESP
	MOV		ESI, [EBP + 20]	; Access DataArray and put values into ESI
	MOV		ECX, [ebp + 16]	; Set ECX count from ARRAYSIZE
	
	_GenerateNumber:

		MOV		EAX, [EBP + 12]	; hi value
		SUB		EAX, [EBP + 8]	; hi value - low value and store that into EAX
		CALL	RandomRange
		ADD		EAX, [EBP + 8]	; ADD the lower value (15) into the EAX in order to be > 15
		MOV		[ESI], EAX	; store current value from EAX into current ESI
		ADD		ESI, TYPE dataArray	; INCrement the ESI by 4 bytes to access next memory ADDress
		loop	_generateNumber	; loops the value set from the ARRAYSIZE from line 112

	POP		EBP
	RET		16


fillArray ENDP
; ***************************************************************

displayArray PROC
; Procedure to display the values in the arrays
; Preconditions: None
; Postconditions: None
; Receives: Address of the dataArray, ARRAYSIZE, emptySpace, printStatement
; Returns: None
	PUSH	EBP
	MOV		EBP, ESP
	MOV		EDX, [EBP + 20]		; ADDress for unsorted print statement
	CALL	WriteString
	MOV		ESI, [EBP + 16]		; ADDress for data array
	MOV		ECX, [EBP + 12]	; ADDress for array size
	MOV		EDX, [EBP + 8]	; ADDress for printing empty spaces
	MOV		EBX, 0	; set counter for row
	
	_printNum:
	MOV		EAX, [ESI]
	call	writedec
	MOV		AL, 32	; print empty space
	call	WriteChar
	Call	WriteChar
	ADD		ESI, 4
	INC		EBX
	CMP		EBX, 19
	JG		_NextRow

	
	_nextNum:
	loop	_printNum
	POP		EBP
	CALL	CRLF
	RET	16

	_NextRow:
		CALL	CRLF
		MOV		EBX, 0
		JMP		_nextNum
	
displayArray ENDP

; ***************************************************************

displayMedian PROC
; Procedure to get print the median value for the array 
; Preconditions: None
; Registers Changed: EAX, ESI, EDX
; Receives: address for ARRAYSIZE, medianStatement, DataArray
; Returns: None
	; need to get the middle number of the array. Should take the whole array and divide by 2 which should produce the middle number. Need to loop through the ESI values until it hits the 100th digit. 
	PUSH	EBP
	MOV		EBP, ESP
	MOV		EDX, [EBP + 16]	; print the median statement
	CALL	WriteString
	MOV		ESI, [EBP + 12]	; get the Data array

	_Arraydivision:
	; get the array size of 200 and divide by 2
	MOV		EBX, 2	; used to divide by 2
	MOV		EDX, 0	; remainder value
	MOV		EAX, LENGTHOF ARRAYSIZE; get the count of the arraysize (200) and MOVe to EAX for division
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
sortList PROC
;-------------------------------------------------------
; BubbleSort
; Sort an array of 32-bit signed integers in ascending
; order, using the bubble sort algorithm.
; Receives: address to dataArray and ARRAYSIZE
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
countList PROC
; Procedure to count the number of instances of each generated number starting with the smallest value
; Preconditions: None
; Postconditions: None
; Receives: None
; Returns: None

	PUSH	EBP
	MOV		EBP, ESP
	MOV		EDX, [EBP + 24]	; address for printing statement
	CALL	WriteString
	MOV		ECX, [EBP + 12]	; loop counter for counting the array
	DEC		ECX	; subtract 1 from the counter in order to not print the last "1"
	MOV		ESI, [EBP + 20]
	MOV		EDX, 0	; sets the row count

	_NewCount:
	MOV		EAX, 1	; initializes the EAX to start counting

	Count:
	MOV		EBX, [ESI]	; get first value in the ESI 
	CMP		EBX, [ESI + 4]	; compare with the next value. if they match, increment EAX counter
	JNE		_printNum
	INC		EAX
	ADD		ESI, 4	; get the next ESI value
	loop	Count

	_NextRow:
	CALL	CRLF
	MOV		EDX, 0
	JMP		_newCount

	_printNum:
	Call	WriteDec
	MOV		AL, 32	; print empty space
	call	WriteChar
	Call	WriteChar
	ADD		ESI, 4	; increment the ESI value
	INC		EDX
	CMP		EDX, 19
	JE		_NextRow
	loop	_newCount	; loop back in order to reset EAX counter to 1 to start counting next values
	POP	EBP
	RET	20


	



countList ENDP
; ***************************************************************




; ***************************************************************
ClosingMessage PROC
; Procedure to print a closing statement from the .data endMsg 
; Preconditions: None
; Postconditions: None
; Receives: None
; Returns: None
	CALL	Crlf
	MOV		EDX, OFFSET	ClosingStatement
	call	WriteString
	RET

ClosingMessage ENDP
; (insert ADDitional procedures here)
; ***************************************************************
END main
