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
count = 100
.data
	list	DWORD	COUNt	DUP(?)
	
; (insert variable definitions here)

.code
main PROC
	
	PUSH	offset	list
	push	count
	call	arrayfill
; (insert executable instructions here)

	Invoke ExitProcess,0	; exit to operating system
main ENDP
arrayfill PROC
PUSH	EBP			; Build stack frame
MOV		EBP, ESP	
PUSH	EAX			; preserve used registers
PUSH	ECX
PUSH	EDI

MOV		ECX, [EBP + 8]		; list length into ECX
MOV		EDI, [EBP + 12]		; address of list into EDI


POP		EDI
POP		ECX
POP		EAX			; restore used registers
POP		EBP
RET 8
arrayfill ENDP

; (insert additional procedures here)

END main
