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
k       SDWORD  ?
n       SDWORD  ?
x       SDWORD  ?
y       SDWORD  ?
z       SDWORD  ?
yes     BYTE    "Yes",13,10,0
no      BYTE    "No",13,10,0
maybe   BYTE    "Maybe",13,10,0

; (insert variable definitions here)

.code
main PROC

; (insert executable instructions here)

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
