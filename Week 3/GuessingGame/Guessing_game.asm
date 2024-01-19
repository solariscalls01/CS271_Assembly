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
RIGHT_NUMBER = 7
; (insert constant definitions here)

.data

; (insert variable definitions here)
greeting			BYTE	"Welcome to the number guessing game! Guess until you get it right!",13,10, 0
prompt				BYTE	"Pick a number between 1 - 10: ", 0
userVal				DWORD	?	; user's guess
correct_string	BYTE	"Amazing! You got it right!", 13, 10, "You've won the game!", 0
above_string		BYTE	"Too High! Try Again:", 0
below_string		BYTE	"Too low! Try again: ", 0

.code
main PROC

;	Greet the user
	mov		EDX, offset greeting
	call	writestring



;	Get user guess
	mov		EDX, offset prompt
	call	writestring

_startloop:
	call	readdec
	mov		userval, EAX
	

;	Evaluate user guess and print appropriate response
	CMP		userval, RIGHT_NUMBER


; if equal, jump to correct
	JE	_correct

; if less than, print "less" string and jump to user guess
	jb	_below
; if greater than, print "above" string and jump to user guess
	; THIS POINT MEANS value is ABOVE correct guess
	mov		edx, offset above_string
	call	writestring
	jmp _startloop

_below:			; guess is below correct value
	mov		EDX, offset below_string
	call	writestring
	jmp		_startloop
	





_correct:
	mov		edx, offset correct_string
	call	writestring


_Finished:
	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
