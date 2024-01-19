TITLE Project One Basic Arithmetic Program     (Proj1_dyb.asm)

; Author: Brian Dy
; Last Modified: 10/11/2022
; OSU email address: dyb@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: Project 1                Due Date: 10/16/2022
; Description: A simple arithmetic program where a user enters 3 numbers and the program adds/ subtracts and outputs the values

INCLUDE Irvine32.inc

; (insert macro definitions here)

; (insert constant definitions here)

.data

 username				BYTE	"Brian Dy", 0																	; Displays the name
 programtitle			BYTE	"Elementary Arithmetic by: ", 0													; Display the title of the project
 introduction			BYTE	"Enter 3 numbers A > B > C, and i'll show you the sums and differences.",0		; Display the introduction for the user  
 prompt_1				BYTE	"Enter the first number: ", 0													; Prompt the user to enter the first number
 prompt_2				BYTE	"Enter the second number: ", 0													; Prompt the user to enter the second number
 prompt_3				BYTE	"Enter the third number: ", 0													; Prompt the user to enter the third number
 first_number			DWORD	?
 second_number			DWORD	?
 third_number			DWORD	?
 closing_message		BYTE	"Thanks for using Elementary Arithmetic! Goodbye!",0							; Displays the closing statement for the program
 sum					DWORD	?
 difference				DWORD	?
 first_number_string	BYTE	"First number: ", 0																; Variable to display the "first number" string
 second_number_string	BYTE	"Second number: ", 0															; Variable to display the "second number" string
 third_number_string	BYTE	"Third number: ", 0																; Variable to display the "Third number" string
 plus_sign_symbol		BYTE	" + ",0																			; Variable symbol to add the "+" string
 equal_sign				BYTE	" = ", 0																		; Variable symbol to add the "=" string
 subtract_sign_symbol	BYTE	" - ", 0																		; Variable symbol to add the "-" string
 sum_a_b				DWORD	?																				; Creates the variable to add A + B						
 sum_a_c				DWORD	?																				; Creates the Variable to add A + C
 difference_a_c			DWORD	?																				; Creates the variable to subtract A - C
 difference_b_c			DWORD	?																				; Creates the variable to Subtract B - C
 sum_a_b_c				DWORD	?																				; Creates the Variables to add A + B + C


.code
main PROC

	; Introduction
		; Display your name and program title on the output screen
		; Display Instructions for the user

		mov		EDX, offset programtitle
		call	WriteString
		mov		EDX, offset username
		call	WriteString
		call	Crlf
		mov		EDX, offset introduction
		call	WriteString
		call	Crlf



	; Get the Data
		; Prompt the user to enter three numbers (A, B, C) in strictly descending order
		; Prompt for the first number
		mov		EDX, offset prompt_1
		call	WriteString
		call	readdec
		mov		first_number, EAX

		; Prompt for the second number input
		mov		EDX, offset	prompt_2
		call	WriteString	
		call	readdec
		mov		second_number, EAX

		; Prompt for the third number
		mov		EDX, offset prompt_3
		call	WriteString
		call	readdec
		mov		third_number, EAX
		call	Crlf




	; Calculate the required values
		; calculate A + B
		mov		EAX, first_number
		add		EAX, second_number	
		mov		sum_a_b, EAX


		; Calculate A - B
		mov		EAX, first_number
		sub		EAX, second_number
		mov		difference, EAX

		; Calculate A + C
		mov		EAX, first_number
		add		EAX, third_number
		mov		sum_a_c, EAX

		; Calculate A - C
		mov		EAX, first_number
		SUB		EAX, third_number
		mov		difference_a_c, EAX

		; Calculate B + C
		mov		EAX, second_number
		add		EAX, third_number
		mov		sum, EAX

		; Calculate B - C
		mov		EAX, second_number
		sub		EAX, third_number
		mov		difference_b_c, EAX

		; Calculate A + B +C
		mov		EAX, first_number
		add		EAX, second_number
		add		EAX, third_number
		mov		sum_a_b_c, EAX



	; Calculate and display the sum and differences: (A+B, A-B, A + C, A - C, B + C, B - C, A + B + C)

		; Get the numbers for A, B, C by getting the prompts
		mov		EAX, first_number
		mov		EDX, offset first_number_string
		call	WriteString
		call	WriteDec
		call	Crlf
		mov		EAX,second_number
		mov		EDX, offset second_number_string
		call	WriteString
		call	WriteDec
		call	Crlf
		mov		EAX, third_number
		mov		EDX, offset third_number_string
		call	WriteString
		call	WriteDec
		call	Crlf

		; add and display A + B = sum
		call	Crlf
		mov		EAX, first_number
		call	WriteDec
		mov		EDX, offset plus_sign_symbol
		mov		EAX, second_number
		call	WriteString
		call	WriteDec
		mov		EDX, offset equal_sign
		mov		EAX, sum_a_b
		call	WriteString
		call	WriteDec

		; Subtract and display A - B = difference
		call	Crlf
		mov		EAX, first_number
		call	WriteDec
		mov		EDX, offset subtract_sign_symbol
		mov		EAX, second_number
		call	WriteString
		call	WriteDec
		mov		EDX, offset equal_sign
		call	WriteString
		mov		EAX, difference
		call	WriteDec

		; Add and display A + C = sum
		call	Crlf
		mov		EAX, first_number
		call	WriteDec
		mov		EDX, offset plus_sign_symbol
		mov		EAX, third_number
		call	WriteString
		call	WriteDec
		mov		EDX, offset equal_sign
		call	WriteString
		mov		EAX, sum_a_c
		call	WriteDec

		;Subtract and Display A - C = Difference
		call	Crlf
		mov		EAX, first_number
		call	WriteDec
		mov		EDX, offset subtract_sign_symbol
		mov		EAX, third_number
		call	WriteString
		call	WriteDec
		mov		EDX, offset equal_sign
		call	WriteString
		mov		EAX, difference_a_c
		call	WriteDec

		; Add and Display B + C = sum
		call	Crlf
		mov		EAX, second_number
		call	WriteDec
		mov		EDX, offset plus_sign_symbol
		mov		EAX, third_number
		call	WriteString
		call	WriteDec
		mov		EDX, offset equal_sign
		call	WriteString
		mov		EAX, sum
		call	WriteDec

		; Subtract and display B - C = difference
		call	Crlf
		mov		EAX, second_number
		call	WriteDec
		mov		EDX, offset subtract_sign_symbol
		mov		EAX, third_number
		call	WriteString
		call	WriteDec
		mov		EDX, offset equal_sign
		call	WriteString
		mov		EAX, difference_b_c
		call	WriteDec

		; Add and Display A + B + C = Sum
		call	Crlf
		mov		EAX, first_number
		call	WriteDec
		mov		EDX, offset plus_sign_symbol
		mov		EAX, second_number
		call	WriteString
		call	WriteDec
		mov		EDX, offset plus_sign_symbol
		mov		EAX, third_number
		call	WriteString
		call	WriteDec
		mov		EDX, offset equal_sign
		call	WriteString
		mov		EAX, sum_a_b_c
		call	WriteDec
		call	Crlf

	; Say goodbye
		; Display a closing message
		call	Crlf
		mov		EDX, offset	closing_message
		call	WriteString
		call	Crlf


	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
