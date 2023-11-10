;by default it will branch to label 'part1'

	B part2; part1 or part2 or part3



buffer	DEFS 100,0


is		DEFB	" >> is \0"
        ALIGN
strsize		DEFB	"The length of string >> \0 "
        ALIGN

s1	DEFB "seven\0"
	ALIGN
s2	DEFB "six\0"
	ALIGN
s3	DEFB "five\0"
	ALIGN
s4	DEFB "four\0"
	ALIGN
s5	DEFB "three\0"
	ALIGN
s6	DEFB "two\0"
	ALIGN
s7	DEFB "one\0"
	ALIGN
s8	DEFB "COMP15111 \0"
	ALIGN
s9	DEFB "Fundamentals of Computer Architecture\0"
	ALIGN

pause     DEFB    "PAUSE EXECUTION"
	ALIGN


printstring
	MOV  R0,R1
	SVC  3
	MOV  R0, #10
	SVC  0
	MOV  PC, LR



;************************** part 1 **************************
stringLength

; R2 must contain the length of the string.
;by default R2 contains integer value zero, you need to write a
;piece of assembly code to calculate the length of the string pointed by R1
				;your code goes here

	;;  MOV R2, #4294967295
	;;  STR R3, all_ones		;;  Doesn't work

	;;  CMP and AND doesn't work, as cannot access CPSR register (Bennett restriction)
	
	;;  Other ideas:
	;;    1. AND each bit individually
	;;    2. Bitshift right 8 times, AND the last position with 1
	;;  		- This is a big reverse engineering effort, but learn some Assembly I guess

	;;  But LSR also doesn't work
	;;  Nonetheless they all go back to CMP

	;;  Lecture notes imply some branch instructions can indirectly access CPSR register.
	
	;;  The truth is, I don't like videos/powerpoints, so I have only been reading course texts.

	;;  But you have to just follow the template course, because Bennett is a limited emulator.
	;;  	Understand Christos' dismay with Bennett now.


;;;  A CALL TO `stringLength` EXITS WITH
;;;    length as integer in r2
;;;    position of last byte in r3

	
  MOV R2,#0           ;len = 0
                        ;while string[len:]:
                        ;   len =len+ 1

	;;  contents of R1 = string

	

	MOV R2, #0

	
byte_loop_count
	
	ADD R2, R2, #1		; add 1 to r2
	LDRB R8, [R1], #1	; load byte from r1 to r8 and increment PC
	CMP R8, #0		; compare r8 with 0, store result in CPSR
	MOV R3, R1		; store for later reuse
	BNE byte_loop_count	; using CPSR comparison bit, branch/not to byte_loop_count

	ADD R2, R2, #-1		; deincrement the extra counter (Ahmed gave this away in lecture)

	ADD R3, R3, #-1
	
;R2 must contain the length of the string
; don't remove these lines
  MOV  R0,R2
  SVC  4
  MOV  R0, #10
  SVC  0
  MOV  PC, LR



;************************** part 2 **************************
printstringReverse

;;;   Note that this function expects that the string to print is in R1
;;;   And that R2 is unused

	MOV R12, LR		;  put address of callee in R12

	ADR LR, reverse_process ;  put address of reverse_process in LR (for later return)

	B stringLength		;  branch off to get the string length
	
reverse_process			;  branches back to here

	MOV r4, r2		;  copy r2 to r4 (contains string length)
	
        ADR R0, pause           ; move PC to location of op4
        SVC 3                   ; output r0 as string	
	
byte_loop_out

	LDRB R0, [R3], #-1	;  deincrement address within r3 by 1, load contents to r0
	SVC 0			

	MOV  R0, #10		;  output newline
	SVC  0	
	
	ADD R4, R4, #-1
	
	CMP R4, #0		;  compare r4 with 0, store result in CPSR
	BNE byte_loop_out	; using CPSR comparison bit, branch/not to byte_loop_count

	SVC 0

	

	MOV LR, R12		;  prepare to branch back to callee
	
	;; MOV R0, R2
	;; SVC 4
	;; MOV R0, R1
	;; SVC 3





; don't remove these lines
	MOV  R0, #10	; given - output end-of-line
	SVC  0		; given
	MOV  PC, LR	; given

;************************** part 3 ***************************
stringCopy
					;Your code goes here replacing the 2 lines given below
  MOV  R12,R2
  SVC  3



; don't remove this line
  MOV  PC, LR	; given



;*********************** the various parts ********************
part1
  ADR R1, strsize
  MOV  R0,R1
  SVC  3
  ADR R1, s1
  MOV  R0,R1
  SVC  3
  ADR R2, is
  MOV  R0,R2
  SVC  3
  ADR R1, s1
  BL stringLength


  ADR R1, strsize
  MOV  R0,R1
  SVC  3
  ADR R1, s2
  MOV  R0,R1
  SVC  3
  ADR R2, is
  MOV  R0,R2
  SVC  3
  BL stringLength

  ADR R1, strsize
  MOV  R0,R1
  SVC  3
  ADR R1, s3
  MOV  R0,R1
  SVC  3
  ADR R2, is
  MOV  R0,R2
  SVC  3
  BL stringLength

  ADR R1, strsize
  MOV  R0,R1
  SVC  3
  ADR R1, s4
  MOV  R0,R1
  SVC  3
  ADR R2, is
  MOV  R0,R2
  SVC  3
  BL stringLength

  ADR R1, strsize
  MOV  R0,R1
  SVC  3
  ADR R1, s5
  MOV  R0,R1
  SVC  3
  ADR R2, is
  MOV  R0,R2
  SVC  3
  BL stringLength

  ADR R1, strsize
  MOV  R0,R1
  SVC  3
  ADR R1, s6
  MOV  R0,R1
  SVC  3
  ADR R2, is
  MOV  R0,R2
  SVC  3
  BL stringLength

  ADR R1, strsize
  MOV  R0,R1
  SVC  3
  ADR R1, s7
  MOV  R0,R1
  SVC  3
  ADR R2, is
  MOV  R0,R2
  SVC  3
  BL stringLength

  ADR R1, strsize
  MOV  R0,R1
  SVC  3
  ADR R1, s8
  MOV  R0,R1
  SVC  3
  ADR R2, is
  MOV  R0,R2
  SVC  3
  BL stringLength

  ADR R1, strsize
  MOV  R0,R1
  SVC  3
  ADR R1, s9
  MOV  R0,R1
  SVC  3
  ADR R2, is
  MOV  R0,R2
  SVC  3
  BL stringLength
  SVC 2


part2	ADR R1, s1
  BL  printstringReverse
  ADR R1, s2
  BL  printstringReverse
  ADR R1, s3
  BL  printstringReverse
  ADR R1, s4
  BL  printstringReverse
  ADR R1, s5
  BL  printstringReverse
  ADR R1, s6
  BL  printstringReverse
  ADR R1, s7
  BL  printstringReverse
  ADR R1, s8
  BL  printstringReverse
  ADR R1, s9
  BL  printstringReverse
  SVC 2


part3	ADR R1, s8
  ADR R2, s9
  ADR R3, buffer
  BL  stringCopy
  ADR R1, buffer
  BL printstring

  SVC 2


	
