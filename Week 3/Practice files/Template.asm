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

; (insert variable definitions here)

.code
main PROC

mov	EAX, 0
mov	EBX, 1
mov ECX, 10

_sumloop:
add eax, ebx
inc	ebx
loop _sumloop

call	writedec

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
