
	B main

op1	DEFB	"Operand 1:  \0"
op2	DEFB	"Operand 2:  \0"

	ALIGN

main
  ADR	R0, op1	; printf("Operand 1: ")
	SVC 3

	SVC	5		    ; input a digit to R0

  ADR	R0, op2	; printf("Operand 2: ")
	SVC 3


  SVC	5		    ; input a digit to R0

							; printf("Result of Addition: )
							; printf(operand 1 + operand 2)

	SVC 2		    ; stop the program
