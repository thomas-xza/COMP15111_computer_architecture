;by default it will branch to label 'part1'

	B part1 ; part1 or part2 or part3



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
  MOV R2,#0           ;len = 0
                        ;while string[len:]:
                        ;   len =len+ 1

	;;  contents of R1 = string

	
	;;  MOV R2, #4294967295
	;;  STR R3, all_ones		;;  Doesn't work

	;;  CMP and AND doesn't work, as cannot access CPSR register (Bennett restriction)
	
	;;  Other ideas:
	;;    1. AND each bit individually
	;;    2. Bitshift right 8 times, AND the last position with 1
	;;  		- This is a big reverse engineering effort, but learn some Assembly I guess

	;;  But LSR also doesn't work
	;;	So...

	;;  Lecture notes imply some instructions can indirectly access CPSR register
	
	;;	The truth is, I have been avoiding them because I don't like videos/presentations...
	;;	I like books/texts!
	

	MOV R7, #0

	
char_loop_count
	
	LDRB R8, [R1], #1
	CMP R8, #0
	ADD R7, R7, #1
	BNE char_loop_count

	
	ADD R7, R7, #-1		;;  Ahmed gave this one away, in the live lecture


	
;R2 must contain the length of the string
; don't remove these lines
  MOV  R0,R2
  SVC  4
  MOV  R0, #10
  SVC  0
  MOV  PC, LR



;************************** part 2 **************************
printstringReverse

;Your code goes here replacing the 2 lines given below
  MOV  R0,R1
  SVC  3







; don't remove these lines
	MOV  R0, #10	; given - output end-of-line
	SVC  0		; given
	MOV  PC, LR	; given

;************************** part 3 ***************************
stringCopy

;Your code goes here replacing the 2 lines given below
  MOV  R0,R1
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
