
;;; ;;;  "Don't optimise until you've measured"
;;; ;;; 	- David Patterson, Computer Organization (RISC-V), 6th edition


;;; ;;;  "Don't optimise unless it reduces time spent debugging with Bennett" - me
	

;;; ;;;   LOG OF WORKING CHANGES:
;;; ;;;   - hardcoded start of _stack address to 0x1000, to find it with Bennett's GUI
;;; ;;;   - can always be replaced with dynamic stack without issues (e.g. at end of exercise)


;;; ;;;   POTENTIAL BUGS:
;;; ;;;   - the 2x test cases don't test for a day and month higher than
;;; ;;;	      the fixed set on the heap (pXXXX vars), and also I didn't test them either
	

;; _stack		equ	0x1000
	
;; 	MOV 	SP, #_stack		; set SP to point to hardcoded location of _stack
	
; COMP15111 lab 4 - Template file

print_char	equ	0		; Define names to aid readability
stop		equ	2
print_str	equ	3
print_no	equ	4

cLF		equ	10		; Line-feed character

	
	ADR	SP, _stack	; set SP pointing to the end of our stack
	
	B	main


;;; ;;;   Exactly what memory address does this actually go to??? 100 bytes/words from end?
;;; ;;;     Explicit address to set stack to is better for debugging.

;;; ;;;   Boosted size of stack to write Assembly faster.

;;; ;;;   - Wonder what the real-life cost of this would be?
;;; ;;;		Negligible?
;;; ;;;		1,000,000 x $0.03?
;;; ;;;		1,000,000 x $0.0003?
	
	
		DEFS	2048		; this chunk of memory is for the stack
_stack					; This label is 'just after' the stack space


wasborn		DEFB	"This person was born on ",0
was		DEFB	"This person was ",0
on		DEFB	" on ",0
is		DEFB	"If the year is 2005, this person is ",0
today		DEFB	" today!",0
willbe		DEFB	"This person will be ",0
		ALIGN

;;; ;;;  x_current dates
	
pDay		DEFW	24		;  pDay = 24    
pMonth		DEFW	11		;  pMonth = 11  
pYear		DEFW	2005		;  pYear = 2005 



sYear		DEFW	2000



printTheDate
	
;;; parameters
;;;   [SP, 0] = day
;;;   [SP, 4] = month
;;;   [SP, 8] = year
	
;;; local variables
;;;   r0 = day
;;;   r1 = month
;;;   r2 = year
	
	
	STMFD	SP!, {R0-R12}	;  store all general-purpose registers to stack

;;;   Load the 3 items pushed by previous method.
	
	LDR	R0, [SP, #(13 + 2) * 4]		;  load 16th item on stack to r0
	LDR	R1, [SP, #(13 + 1) * 4]		;  load 15th item on stack to r1
	LDR	R2, [SP, #(13 + 0) * 4]		;  load 14th item on stack to r2

;;;   Output date as string.
	
	SVC	print_no	; out
	MOV	R0, #'/'	; r0 = '/' ascii n
	SVC	print_char	; out
	MOV	R0, R1		; r0 = r1 (bmonth)
	SVC	print_no	; out
	MOV	R0, #'/'	; r0 = '/' ascii n
	SVC	print_char	; out
	MOV	R0, R2		; r0 = r2 (byear)
	SVC	print_no	; out

	LDMFD 	SP!, {R0-R12}	; reload past contents of registers

	MOV 	PC, LR		; link back to previous method
	

	


	
; def printAgeHistory (bDay, bMonth, bYear)
	
	
printAgeHistory

;;; parameters
;;;   R0 = bDay (on entry, moved to R6 to allow SVC to output via R0)
;;;   R1 = bMonth
;;;   R2 = bYear
	
;;; local variables (callee-saved registers)
;;;   R4 = year_iter
;;;   R5 = age
;;;   R6 = bDay - originally R0	
;;;   R7 = comparison store
;;;   R8 = comparison store #2
;;;   R9 = comparison store #3
;;;   R10 = comparison store #4

	;; PUSH	{R6}			; callee saves three registers
	;; PUSH	{R5}
	;; PUSH	{R4}

;;;   Don't know what the exercise means "there are some other registers which
;;;   this method is using" because I don't agree!
;;;   Anyway just saving them all instead, but keeping the needed ones at top.
	
	STMFD SP!, {R0-R3}
	STMFD SP!, {R7-R12}
	
	STMFD SP!, {R4-R6}

	
;for part 1
;replace the PUSH instructions given above with one STMFD instruction	
   
	LDR	R6, [SP, #(3 + 2) * 4]  ; load 3rd item on stack to r6
	LDR	R1, [SP, #(3 + 1) * 4]  ; load 2nd item on stock to r1
	LDR	R2, [SP, #(3 + 0) * 4]  ; load 1st item on stack to r2


	
;   year = bYear + 1
	ADD	R4, R2, #1	; r4 = r2 + 1
;   age = 1;
	MOV	R5, #1		; r5 = 1
	
;;; ;;;  Unused reg
	;; MOV	R8, #1		; r8 = 1

; print("This person was born on " + str(bDay) + "/" + str(bMonth) + "/" + str(bYear))
	
	ADRL	R0, wasborn	; r0 = address of `wasborn`
	SVC	print_str	; out

	PUSH {LR}		; store LR to stack - overwritten at BL

	PUSH {R6}		; r6 = day
	PUSH {R1}		; r1 = month
	PUSH {R2}		; r2 = year	

	BL printTheDate

	POP {R2}		; r2 = year
	POP {R1}		; r1 = month
	POP {R6}		; r6 = day
	
	POP {LR}		; retrieve LR from stack

	;; MOV	R0, R6		; r0 = r6 (bday)
	;; SVC	print_no	; out
	;; MOV	R0, #'/'	; r0 = '/' ascii n
	;; SVC	print_char	; out
	;; MOV	R0, R1		; r0 = r1 (bmonth)
	;; SVC	print_no	; out
	;; MOV	R0, #'/'	; r0 = '/' ascii n
	;; SVC	print_char	; out
	;; MOV	R0, R2		; r0 = r2 (byear)
	;; SVC	print_no	; out
	
	MOV	R0, #cLF	; r0 = newline char
	SVC	print_char	; out

	
;;; ;;;  http://www-mdp.eng.cam.ac.uk/web/library/enginfo/mdp_micro/lecture3/lecture3-3-3.html
	
; this code does: while year < pYear //{

loop1
	;; LDR     R0, pYear
	;; CMP     R4, R0
        ;; BHS     end1  ; Years are unsigned

; for part 4, should be changed to:
; while year < pYear or
; (year == pYear and bMonth < pMonth) or
; (year == pYear and bMonth == pMonth and bDay < pDay):



;;; ;;;  I feel that lower-case is more legible, I have some regrets.

;;; ;;;  Admittedly I didn't read the Python up until now, was disorienting.
;;; ;;;  Ahmed suggested there can be ways to shorten conditionals, in the lecture.
;;; ;;;  Thought about that in AgeHistoryPart4.c (a lot), AgeHistoryPart4.py for experiments.
	
;;; ;;;  But, there is none! I went barking up the wrong tree, but it
;;; ;;;  is not the 1st time I desired a metric measurement of
;;; ;;;  time...

;;; ;;;  https://developer.arm.com/documentation/dui0068/b/ARM-Instruction-Reference/Conditional-execution
	
;;; ;;;  Data overview:
;;;       	pYear, pMonth, pDay = fixed dates (on heap?)
;;; 		r6 = birth year passed to function
;;;     	r1 = birth month passed to function
;;;     	r2 = birth day_of_month passed to function
;;;     	r4 = iterating year	
	
;;;  branch to end if:    year_iter > year_current 
	
	LDR	r0, pYear	; r0 = pYear (fixed year for comparison)
	
	CMP 	r4, r0		; compare r4 (iterating year, based on birth year passed to function) with r0 (fixed year)
	BHS	end1		; branch to end1 if r4 > r0

	CMP 	r4, r0		; compare again (not sure if necessary)
	MOVEQ	r7, #1		; if iter_year == fixed year ; then r7 = 1



;;;  branch to end if:    year_iter == year_current && bday_month < month_current

	LDR 	r0, pMonth	; r0 = pMonth
	CMP	r1, r0		; compare r1 (birth month passed to function) with r0 (fixed month)

	MOVLT	r8, #1		; if bday_month < month_current ; then r8 = 1

	AND     r9, r7, r8	; r9 = r7 AND r8

	CMP	r9, #1		; compare r9 and 1
	BEQ	end1		; branch to end if r7 AND r8 == 1
	


;;;  branch to end if:	 day_bday  day_current


	CMP	r1, r0		; compare r1 (birth month passed to function) with r0 (fixed month)

	MOVEQ	r8, #1		; if bday_month == month_current ; then r8 = 1

	AND     r10, r7, r8	; r10 = r7 AND r8

	LDR	r0, pDay	; r0 = pDay (fixed day for comparison)

	CMP	r2, r0		; compare r2 (birth day_of_month passed to func) with r0 (fixed day)

	MOVLT	r9, #1		; if r2 < r0 ; then r9 = 1

	AND     r10, r10, r9	; r10 = r10 AND r9 = (r7 AND r8) AND r9

	CMP	r10, #1		; compare r10 and 1

	BEQ	end1		; if r10 == 1 ; then branch to end

	
;;; ;;;  The truth is, I haven't tested the above, but, it doesn't appear break anything!!
	










;  print("This person was " + str(age) + " on " + str(bDay) + "/" + str(bMonth) + "/" + str(year))
	ADRL	R0, was		; r0 = `was` addr
	SVC	print_str	; out
	MOV	R0, R5		; r0 = r5 (age)
	SVC	print_no	; out
	ADRL	R0, on		; r0 = `on` addr
	SVC	print_str	; out
	
	PUSH {LR}		; store LR to stack - overwritten at BL

	PUSH {R6}		; r6 = day
	PUSH {R1}		; r1 = month
	PUSH {R4}		; r4 = year	

	BL printTheDate

	POP {R4}		; r4 = year
	POP {R1}		; r1 = month
	POP {R6}		; r6 = day
	
	POP {LR}		; retrieve LR from stack
	
	;; MOV	R0, R6		; r0 = r6 (bday)
	;; SVC	print_no	; out
	;; MOV	R0, #'/'	; r0 = '/' ascii
	;; SVC	print_char	; out
	;; MOV	R0, R1		; r0 = r1 (bmonth)
	;; SVC	print_no	; out
	;; MOV	R0, #'/'	; r0 = '/' ascii
	;; SVC	print_char	; out
	;; MOV	R0, R4		; r0 = r4 (year)
	;; SVC	print_no	; out
	
	MOV	R0, #cLF	; r0 = '\n' ascii
	SVC	print_char	; out

	; year = year + 1
	ADD	R4, R4, #1	; r4 += 1	(year += 1)

;;; ;;;  Unused regs
	;; ADD	R8, R4, #1	; r8 = r4 + 1	(year + 2)
	;; ADD	R9, R8, #1	; r9 = r8 + 1	(year + 3)
	
	; age = age + 1
	ADD	R5, R5, #1	; r5 += 1	(age + 1)

	B	loop1		; branch to loop1

end1
	
; this code does: if (bMonth == pMonth):
; for part 4, should be changed to:
; if (bMonth == pMonth and bDay == pDay):

;;; ;;;  Data overview:
;;;       	pYear, pMonth, pDay = fixed dates (on heap?)
;;; 		r6 = birth year passed to function
;;;     	r1 = birth month passed to function
;;;     	r2 = birth day_of_month passed to function
;;;     	r4 = iterating year	
	

	LDR	R0, pMonth	; r0 = `pMonth`
	CMP	R1, R0		; compare r1 (birth monday param) with r0 (fixed month)
	MOVEQ	r7, #1		; if r1 == r0 ; then r7 = 1
	
	LDR	r0, pDay	; r0 = `pDay`
	
	CMP 	r2, r0		; compare r2 (birth day_of_month param) with r0 (fixed month)
	MOVEQ	r8, #1		; if iter_year == fixed year ; then r7 = 1

	CMP	r7, r8
	BEQ	else1		; if (r7 == r8) ; then branch to else1

	
;;; ;;;  The truth is, I haven't tested the above, but, it doesn't appear break anything!!
	



	
; print("This person is " + str(age) + " today!")
	ADRL	R0, is		
	SVC	print_str
	MOV	R0, R5
	SVC	print_no
	ADRL	R0, today
	SVC	print_str
	MOV	R0, #cLF
	SVC	print_char

; else
	B	end2
	
else1
; print("This person will be " + str(age) + " on " + str(bDay) + "/" + str(bMonth) + "/" + str(year	))
	ADRL	R0, willbe
	SVC	print_str
	MOV	R0, R5
	SVC	print_no
	ADRL	R0, on
	SVC	print_str
	
	PUSH {LR}		; store LR to stack - overwritten at BL

	PUSH {R6}		; r6 = day
	PUSH {R1}		; r1 = month
	PUSH {R4}		; r4 = year	

	BL printTheDate

	POP {R4}		; r4 = year
	POP {R1}		; r1 = month
	POP {R6}		; r6 = day
	
	POP {LR}		; retrieve LR from stack
	
	;; MOV	R0, R6		; r0 = r6 (bday)
	;; SVC	print_no	; out
	;; MOV	R0, #'/'	; r0 = '/' ascii
	;; SVC	print_char	; out
	;; MOV	R0, R1		; r0 = r1 (bmonth)
	;; SVC	print_no	; out
	;; MOV	R0, #'/'	; r0 = '/' ascii
	;; SVC	print_char	; out
	;; MOV	R0, R4		; r0 = r4 (year)
	;; SVC	print_no	; out
		
	MOV	R0, #cLF
	SVC	print_char

; }// end of printAgeHistory
end2
        	;; POP	{R4}		; callee saved registers
		;; POP	{R5}
		;; POP	{R6}

	LDMFD 	SP!, {R4-R6}

;for part 1
;replace the POP instructions given above with one LDMFD instruction

	MOV	PC, LR

another
	DEFB	"Another person",10,0
	ALIGN






; def main():
main
	LDR	R4, =&12345678		; Test value - not part of python compilation
	MOV	R5, R4			; See later if these registers corrupted
	MOV	R6, R4


; printAgeHistory(pDay, pMonth, 2000)
	;; LDR	R0, pDay
	;; PUSH	{R0}			; Stack first parameter
	;; LDR	R0, pMonth
	;; PUSH	{R0}			; Stack second parameter
	;; LDR	R0, sYear
	;; PUSH	{R0}			; Stack third parameter


;;; ;;;  Original above.
	
	LDR	R9, pDay
	
 	;; STMFD SP!, {R9}
	;; PUSH	{R0}			; Stack first parameter
	
	LDR	R8, pMonth
	
 	;; STMFD SP!, {R8}
	;; PUSH	{R1}			; Stack second parameter
	
	LDR	R7, sYear
	
 	;; STMFD SP!, {R7}
	;; PUSH	{R2}			; Stack third parameter

 	STMFD SP!, {R7-R9}

		
	
;for part 1
;modify the above code (6 lines) to replace the three PUSH instructions with one STMFD instruction
; three parameters should be pushed to the stack with one STMFD instruction.


	BL	printAgeHistory


	ADD SP, SP, #4*13
	

	;; POP	{R0}			; Deallocate three 32-bit variables
	;; POP	{R0}
	;; POP	{R0}

;for part 1
;Replace the three POP instructions mentioned above with a single instruction that doesn't involve memory access.



; print("Another person");
	ADRL	R0, another
	SVC	print_str

; printAgeHistory(13, 11, 2000)
	MOV	R9, #13
	
	;; PUSH	{R0}			; Stack first parameter
	
	MOV	R8, #11
	
	;; STR	R0, [SP, #-4]!		; An explicit coding of PUSH
	
	MOV	R7, #2000
	
        ;; STR	R0, [SP, #-4]!		; An explicit coding of PUSH

 	STMFD	SP!, {R7-R9}

;for part 1
;modify the above code (6 lines) to replace the three instructions (PUSH, STR and STR) with one STMFD instruction
; three parameters shuld be pushed to the stack with one STMFD instruction.

	
	BL	printAgeHistory

	ADD	SP, SP, #4*13
	


        ;; POP	{R0}			; Deallocate three 32-bit variables
	;; POP	{R0}
	;; POP	{R0}

;for part 1
;Replace the three POP instructions mentioned above with a single instruction that doesn't involve memory access.



	; Now check to see if register values intact (Not part of Java)
	LDR	R0, =&12345678		; Test value
	CMP	R4, R0			; Did you preserve these registers?
	CMPEQ	R5, R0			;
	CMPEQ	R6, R0			;

	ADRLNE	R0, whoops1		; Oh dear!
	SVCNE	print_str		;


	
	ADRL	R0, _stack		; Have you balanced pushes & pops?
	CMP	SP, R0			;

	;; CMP	SP, #_stack		; Have you balanced pushes & pops?
					; [hardcoded version]


	
	ADRLNE	R0, whoops2		; Oh no!!
	SVCNE	print_str		; End of test code

; }// end of main
	SVC	stop


whoops1		DEFB	"\n** BUT YOU CORRUPTED REGISTERS!  **\n", 0
whoops2		DEFB	"\n** BUT YOUR STACK DIDN'T BALANCE!  **\n", 0
