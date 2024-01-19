TITLE Program Template     (template.asm)

; Author: Brian Dy
; Last Modified: 11/20/2022
; OSU email address: DyB@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 5                Due Date: 11/20/2022
; Description: This file is provided as a template from which you may work
;              when developing assembly projects in CS271.

INCLUDE Irvine32.inc

; (insert macro definitions here)
ARRAYSIZE = 5
LO = 15
HI = 50
; (insert constant definitions here)

.data
intro				BYTE	"Generating, Sorting, and Counting Random integers!               Programmed by Brian Dy", 13, 10, 0
intro2				BYTE	"This program generates 200 random integers between 15 and 50, inclusive.", 13, 10, 0
intro3				BYTE	"It then displays the original list, sorts the list, displays the median value of the list,", 13, 10
					BYTE	"displays the list sorted in ascending order, and finally displays the number of instances of each", 13, 10
					BYTE	"generated value, starting with the lowest number.", 13, 10, 0
dataArray			DWORD	200 DUP(0)
errorMsg			BYTE	"Input invalid, please pick a number between [15 - 50]: ", 13, 10, 0

UnsortedStatement	BYTE	"Your unsorted random numbers: ", 13, 10, 0
MedianStatement		BYTE	"The median value of the array: ", 13, 10, 0
SortedStatement		BYTE	"Your sorted random numbers: ", 13, 10, 0
InstancesStatement	BYTE	"Your list of instances of each generated number, starting with the smallest value: ", 13, 10, 0
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
	push   OFFSET dataArray
   push   ARRAYSIZE
   push   HI
   push   LO
   call   fillArray
   call   CrLf

	; Print UnsortedStatement
	PUSH	OFFSET	UnsortedStatement
	CALL	UnsortedTitle



	; Print the closing message
	PUSH	OFFSET	ClosingStatement
	CALL	ClosingMessage



	Invoke ExitProcess,0	; exit to operating system
main ENDP
; ***************************************************************
Introduction PROC
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
; Procedure to
; receives: address of array and value of ARRAYSIZE on system stack
; returns: fi
; preconditions:
; registers changed: eax, ebx, ecx, edi
; ***************************************************************
fillArray PROC
	push   ebp
   mov       ebp, esp
   mov       esi, [ebp+20]           ;address of array
   mov       ecx, [ebp+16]           ;arraySize
getNumber:
;generate a random number within our range
   mov       eax, [ebp+12]           ;hi
   sub       eax, [ebp+8]           ;lo
   inc       eax
   call   RandomRange
   add       eax, [ebp+8]           ;lo
;store the random number in our next array position
   mov       [esi], eax
   add       esi, 4
   loop   getNumber
   pop       ebp
   ret       16

fillArray ENDP
; ***************************************************************

UnsortedTitle PROC
	PUSH	EBP
	MOV		EBP, ESP
	MOV		EDX, [EBP + 8]
	CALL	WriteString
	ret	
UnsortedTitle ENDP




displayList PROC
	PUSH	EBP
	MOV		EBP, ESI





displayList ENDP
; ***************************************************************

sortList PROC

 


sortList ENDP
;----------------------------------------------------------

exchangeElements PROC



exchangeElements ENDP
;----------------------------------------------------------

displayMedian PROC




displayMedian ENDP
;----------------------------------------------------------




;----------------------------------------------------------
countList PROC




countList ENDP
;----------------------------------------------------------












;----------------------------------------------------------
ClosingMessage PROC
	CALL	Crlf
	MOV		EDX, OFFSET	ClosingStatement
	call	WriteString
	RET




ClosingMessage ENDP
; (insert additional procedures here)

END main

