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

a		SDWORD	?
b		SDWORD	?
sum		SDWORD	?
rule1	BYTE	"Enter a lower limit and an upper limit, and I'll show",13, 10
		BYTE	"the summation of integers from lower to upper.", 13, 10, 13, 10, 0
prompt1	BYTE	"Lower limit: ", 0
prompt2	BYTE	"Upper limit: ", 0
out1	BYTE	"The summation of integers from ", 0
out2	BYTE	" to ", 0
out3	BYTE	" is: ", 0


; (insert variable definitions here)

.code
main PROC

	call	introduction
	call	getdata			; add data validation
	call	calculate
	call	showresults


; Procedure to introduce the program
; precondtions: rules 1 and rules 2 are strings that describe the program and rules. 
; postconditions: EDX changed
; receives: 
; returns: 
; 

introduction PROC
	mov		EDx, offset rule1
	call	writestring
	ret
introduction ENDP



; gets two values from the user (a and b). Hopefully a is less than b. 
; preconditions: none
; postconditions: EAX
; receives: none
; returns: user input values for global variables a and b
getdata PROC
	mov		EDX, offset prompt1
	call	writestring		; "lower limit: "
	call	readint		; lower limit into EAX
	mov		a, eax		; lower limit into a

	mov		EDX, offset prompt2
	call	writestring		; "upper limit: "
	call	readint		; upper limit into EAX
	mov		b, eax		; upper limit into b

	ret
getdata ENDP


; calculate the summation of integers from a to b
; precontions: a <= b
; postconditions: EAX
; receives: a and b are global variables
; returns: global variables (sum) = a + (a + 1) + ... + b
calculate PROC
	; initialize registers
	mov		EAX, 0
	mov		EBX, a



_sumloop:
	add		EAX, EBX	; sum = sum + new a
	inc		EBX			; a = a + 1
	cmp		EBX, b
	jle		_sumloop

	mov		sum, EAX



	ret
calculate ENDP

; display results of summation (a + ... + b = sum)
; precontions: sum has been calculated
; postconditions: ??? 
; receives: 
; returns: global variables (sum) = a + (a + 1) + ... + b
showresults PROC

	; identify the output
	mov		EDX, offset out1	
	call	writestring		; "the summation of integers from "
	mov		EAX, a
	call	writeint		; display a
	mov		EDX, offset out2
	call	writestring		; " to "
	mov		EAX, b
	call	writeint		; display b
	mov		EDX, offset out3
	call	writestring		; " is "
	mov		EAX, sum
	call	writeint
	call	crlf
	ret

showresults ENDP


	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
