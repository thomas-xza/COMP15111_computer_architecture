
	B main

op1	DEFB	"Operand 1:  \0"
op2	DEFB	"Operand 2:  \0"
op3	DEFB	"Please select your operation (+,-):  \0"
op4	DEFB	"Result of operation:  \0"

	ALIGN

main
  ADR R0, op1			; move PC to location of op1
  SVC 3				; output r0 as string

	
  SVC 5			    	; input int to r0
  ADD R1, R0, #0   		; r1 = r0

	
  ADR R0, op2			; move PC to location of op2
  SVC 3				; output r0 as string

	
  SVC 5			    	; input int to r0
  ADD R2, R0, #0		; r2 = r0

	
  ADR R0, op3			; move PC to location of op3
  SVC 3				; output r0 as string


outputbegin
  ADR R0, op4			; move PC to location of op4
  SVC 3				; output r0 as string

  
addition
  ADD R0, R1, R2		; r0 = r1 + r2
  SVC 4				; output r0 as integer

	
subtraction
  SUB R0, R1, R2		; r0 = r1 + r2
  SVC 4				; output r0 as integer

	
  SVC 2			        ; stop the program
