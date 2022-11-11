@ Define constants for some SWI operations (ARMSIM 1.9.1)
.EQU SWI_PRINT_STRING,	0x69
.EQU SWI_PRINT_INT, 	0x6b
.EQU SWI_STOP,		0x11

@------ DATA SECTION ------
.data
@ the datasett to serch
test:
    .word 1
    .word 3
    .word 5
    .word 7
    .word 9
    .word 8
    .word 6
    .word 4
    .word 2
    .word 0
@ the diferent text outputs
textA: 
.asciz " Lab1 , Assignment 2\n"

textB: 
.asciz " The max is: "

textC: 
.asciz "\n Done \n"

.text
.global main
@ r3 = result
@ r2 = the current objekt of the list
@ r1 = the list
@ r0 = stdout handle
main:
	MOV r0, #1 		        @ Load r0 stdout handle (1)
	LDR r1, =textA          @ Load r1 with first output text
	SWI SWI_PRINT_STRING	@ Print r1
    MOV r0 , #0             @ Init r0 as 0
    LDR r3 , =0             @ Init r3 as 0
    LDR r1, =test           @ set r1 to the list
	BL findMax              @ call find max fuction
    SWI SWI_STOP            @ safty stop

/*******************************************************************
Function finding maximum value in a zero terminated integer array
*******************************************************************/
findMax:
    /* Add code to find maximum value element here ! */
    LDR r2 , [ r1 ]         @ load new current from list
    CMP r2 , #0             @ if r2 == 0 its the end of the list
    BEQ finish              @ breakpoint
    ADD r1 , r1 , #4        @ add offset to incriment index of list
    CMP r2, r3              @ check if current > largest_Found
    BGT newBiggest          @add new largest found int
    BAL findMax             @ recursive functioncall

/*******************************************************************
Function that stores the currently largest variable in r3
*******************************************************************/
newBiggest:
    MOV r3, r2              @ moves he newly found lagest to r3     
    BL findMax              @ return to loop
/*******************************************************************
Print
*******************************************************************/
print_int:
	STMDB SP!, {LR}		    @ PUSH for ARMSim 1.9.1
    LDR r1, =textB          
	SWI SWI_PRINT_STRING	@ Print a new line
    MOV r1, r3		        @ Load r1 with the integer value to print
	MOV r0, #1 		        @ Load r0 stdout handle (1)
	SWI SWI_PRINT_INT	    @ Print the integer
	LDMIA SP!, {PC}		    @ POP for ARMSim 1.9.1
/*******************************************************************
end of program. Final prints of res
*******************************************************************/
finish:
    MOV r1, r0		        @ Load r1 with the integer value to print
	MOV r0, #1 		        @ Load r0 stdout handle (1)
	bl print_int            @ print result
    LDR r1, =textC          @ Load final text
	SWI SWI_PRINT_STRING    @print textC
.end