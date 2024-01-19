TITLE Prime Numbers       (Primes.asm)

; This program prompts the user to enter n in the range [1 .. 200].
; If the n is out of range, the user is re-prompted until the value entered is in range [1 .. 200].
; Then it calculates and displays n prime numbers(including the nth prime).

INCLUDE Irvine32.inc

UPPERBOUND = 200
LOWERBOUND=1
TRUE = 1
FALSE = 0

.data
	welcome		BYTE	"Prime Numbers Programmed by Euclid",0
	prompt1		BYTE	"Enter the number of primes you would like to see.",0
	prompt2		BYTE	"I'll accept orders for up to 200 primes.",0
	prompt3		BYTE	"Enter the number of primes to display [1..200]: ",0
	n			DWORD	?	;number of primes
	errorMsg	BYTE	"No primes for you! Number out of range. Try again.",0
	byeMsg		BYTE	"Results certified by Euclid. Goodbye.",0	
	spaces3		BYTE	"   ",0
	colNum		DWORD	1	; column counter
.code

main PROC
; Display programmer & program name 
	call	introduction
; Prompt for integer n in range [1...200] 
	call	getUserData
; If n is valid, Call and display all primes up to nth prime
	call	showPrimes
; display farewell message
	call	farewell
	exit
main ENDP

;-------------------------------------------------------------------------
introduction PROC
; Displays program name , programmer name and user instructions
; receives: none
; returns: none
; preconditions: none
; registers changed: edx
;-------------------------------------------------------------------------
	mov	edx, OFFSET welcome
	call	WriteString			; display program name and programmer name
	call	Crlf
	call	Crlf
	mov		edx, OFFSET prompt1 
	call	WriteString			; display instructions for user
	call	Crlf
	mov		edx, OFFSET prompt2
	call	WriteString			; display instructions for user
	call	Crlf
	call	Crlf
	ret
introduction ENDP
;-------------------------------------------------------------------------

;-------------------------------------------------------------------------
getUserData PROC
; prompts for integer n in [1..200] and validates n.
; If n is out of range, it re-prompts until valid number is entered.
; receives: none
; returns: n in EAX
; preconditions: n in range [1..200], edx initialized
; registers changed: eax, edx
;-------------------------------------------------------------------------
GetNum:
	mov		edx, OFFSET prompt3
	call	WriteString					; prompt user to enter n
	call	ReadDec						; read number into n
	mov		n, eax					
	call validate
	cmp eax,0							; EAX=0 means, n is invalid
	je		InvalidMsg					; if n < 1 or n>200, n is invalid 
	call	Crlf						
	mov eax,n
	ret									; if n is valid, go to main 
InvalidMsg:
	mov edx, OFFSET errorMsg
	call WriteString					; display error message
	call	Crlf
	jmp		GetNum						; try again and re-prompt
	ret
getUserData ENDP
;-------------------------------------------------------------------------
;-------------------------------------------------------------------------
validate PROC
; Cheack whether the input is in the range[1..200] or not. If it is
; out of range,return boolean value 0. Otherwise, return 1.
; receives: n in EAX
; returns: Boolean value(0 or 1) in EAX
; preconditions: none
; registers changed: EAX
;-------------------------------------------------------------------------
	cmp eax,LOWERBOUND
	jl		InvalidInput				; if n < 1, n is invalid 
	cmp		eax, UPPERBOUND
	jg		InvalidInput				; if n > 200, n is invalid 
	mov eax,TRUE						; if n is valid, return true
	ret
InvalidInput:
	mov eax,FALSE						; if n is invalid, return false
	ret
validate ENDP
;-------------------------------------------------------------------------

;-------------------------------------------------------------------------
showPrimes PROC
; Calculates and displays all of the prime numbers up to nth prime.
; Diplays prime number 10 per each line with 3 spaces between two numbers
; receives: n in EAX
; returns: none
; preconditions: n is in [1..200], colNum = 1
; registers changed: eax, ebx, ecx, edx
;-------------------------------------------------------------------------
	mov ecx,eax						; intialize loop counter with n
	mov ebx,2						; p=2
	primeLoop:
		mov eax,ebx					; pass p to isPrime in EAX
		call isPrime				; call isPrime
		cmp eax,1					; EAX=1 means p is prime number 
		jne nextNum					; if p is not prime, goto label nextNUm
		dec ecx						; if p is prime, to balance loop counter,
									; decrease ecx by 1
		mov eax,ebx					
		call WriteDec				; display prime number p
		mov	edx, OFFSET Spaces3
		call WriteString			; display 3 spaces between two numbers
		jmp nextNum					; go to label nextNum
	nextRow:	call crlf			; go to next row
		mov colNum,1				; reset colNum to 1
	nextNum:
		inc ecx						; increment ecx by 1 to balance loop counter
		inc ebx
		Loop primeLoop				; ECX= ECX-1; loop exits when ECX=0
		call crlf
		ret
showPrimes ENDP
;-------------------------------------------------------------------------

;-------------------------------------------------------------------------
isPrime PROC USES ECX EBX
; Checks whether a number is prime or not. If given number is prime, returns
; boolean value 1. Otherwise, returns 0.
; receives: A number in EAX
; returns: boolean value(0 or 1) in EAX
; preconditions: eax is in [1..200]
; registers changed: eax, ebx, ecx, edx
;-------------------------------------------------------------------------
		mov ecx,eax							; copy the number p into ECX
		mov esi, 2							; i=2
  startLoop:
		cmp esi,ecx							
		jge	PrimeNum						; if i>=p, p is prime and goto PrimeNum
		mov edx,0
		mov eax,ecx
		div	esi								; calculate p/i. EAX=p/i and EDX=p%i
		cmp	edx, 0							
		je	NotPrime						; if remainder = 0, p is not prime
		inc	esi								; otherwise, continue search
		jmp	startLoop
PrimeNum:	
	mov eax, TRUE							; if p is prime , return true
	ret
NotPrime:
	mov eax, FALSE							; if p is not prime, return true
	ret
isPrime ENDP
;-------------------------------------------------------------------------

;-------------------------------------------------------------------------
farewell PROC
;Displays a farewell message
;receives: none
;returns: nothing
;preconditions: none
;registers changed: edx
;-------------------------------------------------------------------------
	call	Crlf
	mov		edx, OFFSET byeMsg
	call	WriteString							; say bye
	call	Crlf
	ret
farewell ENDP
;-------------------------------------------------------------------------
END main