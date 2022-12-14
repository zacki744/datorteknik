@ Define constants for some SWI operations (ARMSIM 1.9.1)
.EQU SWI_PRINT_STRING,	0x69
.EQU SWI_PRINT_INT, 	0x6b
.EQU SWI_STOP,		0x11

@------ DATA SECTION ------
.data
@the dataset to serch
test:
    .word 1
    .word 2
    .word 3
    .word 4
    .word 5
    .word 6
    .word 7
    .word 8
    .word 9
    .word 10
    .word 11                @ one variable larger then the rest as a stopmark

textC: 
.asciz "\n"

.text
.global main
/*******************************************************************
Main function
*******************************************************************/
main:
    LDR r4, =test           @ init r3 as the list of numbers 1-10
	B Loop                  @ call the loop

/*******************************************************************
Loop throw the numbers 1-10 and call the factorial funtion 
*******************************************************************/
Loop:
    BL print_int            @ print res
    MOV r0, #1 		        @ Load r0 stdout handle (1)
    LDR r3 , =1             @ init r3 with 1
    LDR r2 , [ r4 ]         @ assign one of the numbers from the list
    CMP r2 , #11            @ if the number is larger than 10
    BGE finish              @ then end
    ADD r4 , r4 , #4        @ incriment the pionter in r4 to incriment it
    BL factorial            @ call factorial

/*******************************************************************
Calculate the factorial number of any given number in a recursive fasion storing the result in r3
*******************************************************************/
factorial:
    MULS r3,r2,r3           @ Multiply the current res with n-1
    SUBS r2, r2,#1          @ n-1
    CMP r2,#1               @ check if r2 is larger than 1
    BLE Loop                @ if it is call this function
    BL factorial            @ go back too loop
/*******************************************************************
output
*******************************************************************/
print_int:
	STMDB SP!, {LR}		    @ PUSH for ARMSim 1.9.1
    LDR r1, =textC
	SWI SWI_PRINT_STRING	@ Print a new line
    MOV r1, r3		        @ Load r1 with the integer value to print
	SWI SWI_PRINT_INT	    @ Print the integer
    LDMIA SP!, {PC}		    @ POP for ARMSim 1.9.1

/*******************************************************************
End of program call
*******************************************************************/
finish:
    SWI SWI_STOP


