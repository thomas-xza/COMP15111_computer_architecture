B main


x DEFW 0
y DEFW 0
z DEFW 0
operation DEFW 0


op0	DEFB	"Note: this calculator has no overflow detection as Bennett does not allow access to the CPSR register (so that we could AND bits 28, 27 of the CPSR register).  \0"
op1	DEFB	"Operand 1:  \0"
op2	DEFB	"Operand 2:  \0"
op3	DEFB	"Please select your operation (+,-):  \0"
op4	DEFB	"Result of operation:  \0"

	ALIGN

	
main

	MOV R0, #0		; empty main register
	ADR R0, op0		; move PC to location of op0
	SVC 3			; output r0 as string
	MOV R0, #10		; load newline (ASCII '\n')
	SVC 0


	ADR R0, op1		; move PC to location of op1
	SVC 3			; output r0 as string


	SVC 5			; input int to r0;
	STR R0, x	
	;;  ADD R1, R0, #0   	; r1 = r0


	ADR R0, op2		; move PC to location of op2
	SVC 3			; output r0 as string


	SVC 5			; input int to r0		
	STR R0, y
	;; ADD R2, R0, #0 r2 = r0


input_operand
	ADR R0, op3		; move PC to location of op3
	SVC 3			; output r0 as string


	SVC 1			; input char
	SVC 0			; output char entered
	STR R0, operation


output_begin
	MOV R0, #10		; load newline (ASCII '\n')
	SVC 0
	ADR R0, op4		; move PC to location of op4
	SVC 3			; output r0 as string


selection_process
	LDR R1, x
	LDR R2, y
	LDR R4, operation

	MOV R0, #43		; load 43 (ASCII '+')
	CMP R0, R4
	BEQ addition

	MOV R0, #45		; load 45 (ASCII '-')
	CMP R0, R4
	BEQ subtraction
	B end


addition
	ADD R0, R1, R2		; r0 = r1 + r2
	STR R0, z
	SVC 4			; output r0 as integer
	B end

	
subtraction
	SUB R0, R1, R2		; r0 = r1 + r2
	STR R0, z
	;; AND R0, CPSR, #134217728	;  apparently CPSR is not accessible within bennett
	SVC 4			; output r0 as integer
	B end


end
	SVC 2		        ; stop the program

