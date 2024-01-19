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
	uArr	DWORD	10 DUP(?)
; (insert variable definitions here)

.code
main PROC
	MOV		ESI, offset	myArr
	MOV		EDI, offset	uArr
	MOV		EAX, [ESI+4]
	MOV		[EDI], EAX
	Call	WriteInt
	mov		EBX, [EDI-12]
	MOV		EAX, EBX
	call	writeint
	
; (insert executable instructions here)

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
