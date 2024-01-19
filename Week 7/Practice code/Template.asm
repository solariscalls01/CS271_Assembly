INCLUDE Irvine32.inc

.data
myNumber    DWORD    5
myOutput    DWORD    10
myString    BYTE    "Hello! This is a sample program.",13,10,0

.code
main PROC
    ; Pass a parameter by value. This places the current value of myNumber 
    ; on the stack.
    PUSH    myNumber
    ; Pass parameters by reference. This places the starting address of 
    ; a variable onto the stack.
    PUSH    OFFSET myOutput
    PUSH    OFFSET myString
    
    ; Pushes the 4-byte return address on to the stack. 
    CALL    testProc
    
    Invoke ExitProcess, 0
main ENDP

testProc PROC
    ; Preserve the stack pointer. Pushes 4 more bytes onto the stack.
    PUSH    EBP
    MOV     EBP, ESP
    
    ; Retrieve the address of myString from the stack.
    ; We use base-offset addressing to peek into the stack,
    ; rummage around, and get parameters that we pushed.
    MOV     EDX, [EBP + 8]
    ; Now EDX holds the address of myString. 
    CALL    WriteString
    CALL    Crlf
    
    ; Retrieve the address of myOutput.
    MOV     EDX, [EBP + 12]
    ; Now EDX holds the address of myOutput.
    ; This is where it gets fun! We have the address of myOutput. 
    ; We could access its value, like so. Note that EDX holds the address,
    ; so we MUST dereference again to get at the value stored there.
    MOV        EAX, [EDX]
    ; That dereferences the address in EDX and moves the current value 
    ; stored there (10) into EAX.
    CALL    WriteInt
    CALL    Crlf
    ; We could also modify the value stored there.
    ; Note that this can't be used with immediate values, so we'll 
    ; put our new value into EBX.
    MOV     EBX, 150
    MOV     [EDX], EBX
    MOV     EAX, [EDX]
    CALL    WriteInt
    CALL    Crlf
    ; This changed the value stored in myOutput! Super important for 
    ; Projects 5 and 6.
    
    ; Finally, we can retrieve the value we pushed.
    MOV     EAX, [EBP + 16]
    ; Now EAX contains the value 5.
    CALL    WriteInt
    CALL    Crlf
    
    POP     EBP
    ; We pushed 3 4-byte things before we called the procedure, so we 
    ; clear 12 bytes off the stack when we return.
    RET     12
testProc ENDP
END main