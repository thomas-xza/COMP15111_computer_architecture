
	B main

op1	DEFB	"Operand 1:  \0"
op2	DEFB	"Operand 2:  \0"
op3	DEFB	"Result of Addition:  \0"

	ALIGN

main
  ADR	R0, op1			; printf("Operand 1: ")
  SVC 3				; output string (from r0)

  SVC 5			    	; input int to R0
  STR R0, x			; store r0 to mem location x
  
  ;;   ADD R1, R0, #0   	; r1 = r0 + 0

	
  ADR R0, op2			; printf("Operand 2: ")
  SVC 3				; output string (from r0)

  SVC 5			    	; input int to R0
  STR R0, y			; store r0 to mem location y
	
  ;;  ADD R1, R1, R0		; r1 = r1 + r0

	
  LDR R1, x
  LDR R2, y

	
  ADR R0, op3			; move PC to location of op3
  SVC 3				; output int		printf(operand 1 + operand 2)

  ADD R0, R1, R2		; r0 = r1 + r2
  STR R0, z			; store r0 to mem location z
	
  SVC 4				; output integer in decimal
	
  SVC 2			        ; stop the program

	
x DEFW 0
y DEFW 0
z DEFW 0
