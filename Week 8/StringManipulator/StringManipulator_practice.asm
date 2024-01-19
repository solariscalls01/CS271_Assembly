TITLE Programming Assignment #1    (Project01.asm)

; Author:							
;

INCLUDE Irvine32.inc

MAXSIZE = 101

.data

inString		Byte	MAXSIZE	DUP(?)	; prints the "inputted" string value
outString		BYTE	MAXSIZE	DUP(?)	; produces the outputted value
userString		BYTE	"The starting string: ", 0
dupString		BYTE	"The Duplicate String: ", 0
capString		BYTE	"The capitalized String: ", 0
revString		BYTE	"The reverse String: ", 0
prompt			BYTE	"Enter a string (MAX 100 Chars)", 0
sLen			DWORD	?

.code
 main PROC
; -------********************************************
 ; get user input:
 	MOV		EDX, offset prompt
	CALL	WriteString
	MOV		EDX, offset inString
	MOV		ECX, MAXSIZE
	CALL	ReadString
	MOV		sLen, EAX
	call	crlf

	; print the starting string
	MOV		EDX, offset userstring
	CALL	WriteString
	MOV		EDX, offset inString
	CALL	WriteString
	call	crlf


; -------********************************************
 ; duplicate the string
	; set up the loop counter and indexes 
	CLD		; clear the direction flag
	mov		ECX, SLen
	MOV		ESI, OFFSET	inString
	MOV		EDI, OFFSET	outString

	
	; duplicate the string
	MOV		ESI, OFFSET	instring
	MOV		EDI, offset	outString
	REP		MOVSB



	; print the string
	MOV		EDX, offset dupString
	CALL	WriteString
	MOV		EDX, offset outString
	CALL	WriteString
	call	crlf

; -------********************************************
 ; capitalize the string

	; set up the loop counter and indexes	
	CLD		; clears the direction flag. 
	mov		ECX, SLen
	MOV		ESI, OFFSET	inString
	MOV		EDI, OFFSET	outString
	
	; capitalize string
	; how this works is that you look at the hex value for the character values. lower case a - z starts from 97 and 122 respectively. Therefore, we need to subtract 32
	; from the values to get its respective capital letters 

	_capLoop:
	LODSB			; puts byte in AL. LODSB takes whatever value is in memory at location pointead by the ESI and copies to AL register. 
	CMP		AL, 97		; this is the hex value for "a"
	JL		_AlreadyCap
	CMP		AL, 122		; this is the hex value for "z"
	JG		_alreadyCap
	SUB		AL, 32

	_alreadycap:
	STOSB		; copy whatever value is in the AL register that is pointed by the EDI register. 
	LOOP	_capLoop



	; print the string
	MOV		EDX, offset capString
	CALL	WriteString
	MOV		EDX, offset outString
	CALL	WriteString
	call	crlf
	call	crlf

; -------********************************************
 ; reverse the string

	; set up the loop counter and indexes 
	
	mov		ECX, SLen
	MOV		ESI, OFFSET	inString	; ESI source points at the BEGINNING of the string
	; need our source to point at the END of the string in order to reverse. think string[-1]
	ADD		ESI, ECX	; ECX is the length of the string. 
	DEC		ESI		; forget why this was in the video. But needed to access the lower memory address or something. 
	MOV		EDI, OFFSET	outString	; EDI source poitns at the end of the output string 
	
	; reverse string
	_revloop:
	STD	; reverses the direction flag. setting the direction flag to go the reverse direction. allows to read the input in reverse order 
	LODSB
	CLD	; clears the direction flag after reading it (set direction flag back to normal direction) in order to store string to the output
	STOSB
	LOOP _revloop


	; print the string

	MOV		EDX, offset revString
	CALL	WriteString
	MOV		EDX, offset outstring
	CALL	WriteString
	call	crlf
	call	crlf
; -------********************************************

	exit	; exit to operating system
main ENDP

END main