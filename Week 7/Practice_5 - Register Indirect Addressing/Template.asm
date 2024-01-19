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

; (insert constant definitions here)

.data
	myArr	DWORD	100, 400, 900
	
; (insert variable definitions here)

.code
main PROC
	MOV		ESI, offset	myArr		; Address of first element of myArr into ESI
	MOV		ECX, LENGTHOF	MyArr	; Number of elements of myArr into ECX
_printArr:
	MOV		EAX, [ESI]				; n-th element of my ARR into EAX
	call	WriteDec
	Call	CRLF
	ADD		ESI, Type MyArr		; increment ESI by 4 to point to the next element of myArr
	loop	_PrintArr
	exit
	
; (insert executable instructions here)

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
