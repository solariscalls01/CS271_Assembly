TITLE Program Template     (template.asm)

; Author: Brian Dy
; Last Modified: 11/20/2022
; OSU email ADDress: DyB@oregonstate.edu
; Course number/section:   CS271 Section 400
; ProJEct Number: 5                Due Date: 11/20/2022
; Description: This file is provided as a template from which you may work
;              when developing assembly proJEcts in CS271.

INCLUDE Irvine32.inc
quiz2   MACRO pVar, qVar
        LOCAL _Label1
	PUSH  EAX
	PUSH  ECX
	MOV   EAX, pVar
	MOV   ECX, qVar
_Label1:
        MUL   pVar
	LOOP  _Label1

	MOV   pVar, EAX
	POP   ECX
	POP   EAX
ENDM

.data
xVar   DWORD   3
yVar   DWORD   3
.data
str1     BYTE    "Introduction",0

.code
main PROC
  MOV    EBX, 3
  MOV    EDX, 3
  quiz2  EBX, EDX
  exit  ; exit to operating system
main ENDP

END main