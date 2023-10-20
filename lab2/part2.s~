
	B main

op1	DEFB	"Operand 1:  \0"
op2	DEFB	"Operand 2:  \0"
op3	DEFB	"Result of Addition:  \0"

	ALIGN

main
  ADR	R0, op1			; printf("Operand 1: ")
  SVC 3				; output string (from r0)

  SVC 5			    	; input int to R0




  ADD R1, R0, #0   		; add r0 contents to zero, store in r1

  ADR R0, op2			; printf("Operand 2: ")
  SVC 3				; output string (from r0)

  SVC 5			    	; input int to R0

  ADD R1, R1, R0		; add r1 to r0, store in r1

  ADR R0, op3			; move PC to location of op3
  SVC 3				; output int		printf(operand 1 + operand 2)

  ADD R0, R1, #0
  SVC 4	
	
  SVC 2		        ; stop the program
