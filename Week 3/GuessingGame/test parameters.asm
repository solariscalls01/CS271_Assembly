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

	k       SDWORD  11
	n       SDWORD  10
	x       SDWORD  ?
	y       SDWORD  ?
	z       SDWORD  ?
	yes     BYTE    "Yes",13,10,0
	no      BYTE    "No",13,10,0
	maybe   BYTE    "Maybe",13,10,0
	prompt_1	BYTE	"Enter number for k: ", 0
	prompt_2	BYTE	"Enter number for n", 0
	userInput	SDWORD	?
; (insert variable definitions here)

.code
main PROC
mov		EAX, k
cmp		eax, n
JL		_maybe
JG		_True1
mov		EDx, offset	no
call	writestring
JMP		_True2


_Maybe:
	mov		EDx, offset maybe
	call	writestring
	jmp		_theend

_True1:
	mov		EDX, offset no
	call	writestring
	jmp	_Theend

_True2:
	mov		edx, offset	yes
	call	writestring
	jmp		_theend

_TheEnd:

; (insert executable instructions here)

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
