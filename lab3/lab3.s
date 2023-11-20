				;by default it will branch to label 'part1'

B part2; part1 or part2 or part3


;;;   Comment out the "SVC 2" lines at the end to test all fast
;;;     Note that part2 reuses some functionality from part1 (with links)
;;;     This is against the spec but, I learnt more, which is why I'm here right
	

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

	;;  But LSR also doesn't work in Bennett
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
	LDRB R8, [R1], #1	; load byte from r1 to r8 and increment R1
	CMP R8, #0		; compare r8 with 0, store result in CPSR
	MOV R3, R1		; store for later reuse
	BNE byte_loop_count	; using CPSR comparison bit, branch/not to byte_loop_count

	ADD R2, R2, #-1		; deincrement the extra counter (Ahmed gave this away in lecture)
	ADD R3, R3, #-1		; deincrement the final byte position
	
;R2 must contain the length of the string
; don't remove these lines
  MOV  R0,R2
  SVC  4
  MOV  R0, #10
  SVC  0
  MOV  PC, LR



;************************** part 2 **************************
printstringReverse


;;; ;;;;  Second attempt below - with actual stack,
;;; ;;;;    because thinking of taking microcontrollers course (but aren't they programmed in C?)


;;; ;;;   Plan:

;;; ;;;   1. add chars to stack, compare with zero, loop if not zero, iterate quantity
;;; ;;;   2. pop chars from stack, decrement quantity, compare with zero

;;; ;;;   Psuedoinstruction PUSH & POP a bit inappropriate because we are operating on bytes...
;;; ;;;   There could be a PUSHB or POPB but instead we have LDRB manipulating addresses too...
;;; ;;;   OK PUSH {R1} doesn't work in Bennett - it only changes the stack pointer?
;;; ;;;   Aw hell, we're Bennett guinae pigs.


;;; ;;;   It seems weird to put addresses on the stack, but LDRB only works with addresses...
;;; ;;;   Will use AND to put actual values on stack, feels more sane.
	


;;; ;;;   OK THIS IS THE TRICK TO MAKING PUSH AND POP ACTUALLY WORK WITH BENNETT:
	
MOV R13, #2048	;  set the stack pointer to an empty address



MOV R2, #0	;  reset the byte iteration counter

	
byte_loop_push

	;  LDRB SHOULD ONLY LOAD 1 BYTE, LIKE RISC-V - NO ADDRESS MANIPULATION	
	
	LDRB R0, [R1,R2]		;  r1 contains address, load 4 LSBs of [ r1 address location + r2 bytes ] to r0
	ADD R2, R2, #1		;  add 1 to r2, to load next char

	PUSH {R0}
	
	;; verbose, manual implementation of PUSH {R1}

	;; ADD R13, R13, #-4	;  move stack pointer backwards by 4 bytes
	;; STR R0, [R13]		;  store contents of r0 (an address) to location of r13
	
	;; SVC 0			;  FOR DEBUGGING: Output byte

	CMP R0, #0	   	;  compare r4 with 0, store result in CPSR
	BNE byte_loop_push	;  using CPSR comparison bit, branch/don't to byte_loop_push

	
pop_last_stack_value

	POP {R0}
	
	;; LDR R0, [R13]		;  load contents of r13 to r0, to pop the last 0 from stack
	;; ADD R13, R13, #4	;  add 4 to r13

	
byte_loop_pop
	
	;; verbose, manual implementation of POP {R1}
	
	;; LDR R0, [R13]		;  load contents of r13 to r0
	;; ADD R13, R13, #4	;  add 4 to r13 (move stack pointer)

	POP {R0}

	
	SVC 0			
	
	CMP R13, #2048	   	;  compare r13 with top of stack address, store result in CPSR
	BNE byte_loop_pop	;  using CPSR comparison bit, branch/don't to byte_loop_pop

	
	LDRB R0, [R3], #-1	;  load final char
	;; SVC 0

	MOV  R0, #10		;  output newline
	SVC  0	
	
	

	

;;;;;;;;;;; ;;; First fully functional attempt below, but no stack
;;;;;;;;;;; ;;; LDRB does indeed suck
	

;;;   Note that this function expects that the string to print is in R1
;;;   And that R2 is unused
	

;; 	MOV R12, LR		;  put address of callee in R12

;; 	ADR LR, reverse_process ;  put address of reverse_process in LR (for later return)

;; 	B stringLength		;  branch off to get the string length
	
;; reverse_process			;  branches back to here

;; 	;;;   R3 now contains the address of the end of the string
;; 	;;;   R2 now contains the length of the string

;; 	MOV r4, r2		;  copy r2 to r4 (contains string length)
	
;;         ;; ADR R0, pause           ; move PC to location of op4
;;         ;; SVC 3                   ; output r0 as string	
	
;; byte_loop_out


;; 	;; LDRB R0, [R3], #-1	; #-1 deincrement address within r3 by 1, load contents of r3 to r0
;; 	LDRB R0, [R3], #-1	;  Should be 2 separate instructions, arguably - more RISC like
;; 	SVC 0			

;; 	ADD R4, R4, #-1
	
;; 	CMP R4, #0		;  compare r4 with 0, store result in CPSR
;; 	BNE byte_loop_out	;  using CPSR comparison bit, branch/don't to byte_loop_out

;; 	LDRB R0, [R3], #-1	;  load final char
;; 	SVC 0

;; 	MOV  R0, #10		;  output newline
;; 	SVC  0	
	
	

;; 	MOV LR, R12		;  prepare to branch back to callee
	

;;; ;;;;;;;;;;;;;;;;;;;;  END OF FIRST ATTEMPT

	

; don't remove these lines
	MOV  R0, #10	; given - output end-of-line
	SVC  0		; given
	MOV  PC, LR	; given

;************************** part 3 ***************************
stringCopy
					;Your code goes here replacing the 2 lines given below

	
;;;   RISC-V might be the future, ARM (and Intel) might be totally screwed someday.
;;; 	There is no advantage to commit to it unless they choose to fund me (and potentially
;;; 	oversubscribed). I have to hedge my bets.
;;;   Also, Bennett is not a joy to work with.

stringCopy_init
	
	MOV R12, LR		;  put address of callee in R12	
	
	ADR R3, buffer
	

byte_loop_strcopy

	LDRB R4, [R1], #1	;  load byte from R1 to R4 and increment R1
	STRB R4, [R3], #1	;  store byte from R4 to R3 and increment R3
	
	;; MOV R0, R4
	;; SVC 0
	
	CMP R4, #0		;  compare r8 with 0, store result in CPSR
	BNE byte_loop_strcopy	;  using CPSR comparison bit, branch/not to byte_loop_count


concat_string_out_init

	MOV R4, #0
	LDRB R4, [R3], #-1

	
byte_loop_strjoin

	LDRB R4, [R2], #1	;  load byte from R1 to R4 and increment R1
	STRB R4, [R3], #1	;  store byte from R4 to R3 and increment R3
	
	;; MOV R0, R4
	;; SVC 0
	
	CMP R4, #0		;  compare r8 with 0, store result in CPSR
	BNE byte_loop_strjoin	;  using CPSR comparison bit, branch/not to byte_loop_count



stringCopy_ending

	
	MOV LR, R12		;  address of R12 in LR (prepare to branch back to callee)
	
	


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


