.data
    matA:
        .word 1,2,3,4
    matB:
        .word 5,6,7,8
    matC:
        .word 0,0,0,0
    promt1:
        .asciiz "Mat A: \n"
    new_line: 
    	.asciiz "\n" 
    space: 
    	.asciiz " "

.text
main:
    la $s2, matA
    j print


print:
    la $a0, promt1
    la $a1, matA
    jal printMat

    #exit
    li $v0, 10
    syscall

printMat:
    li $v0, 4 #print string
    syscall
    addi $a2,$0,0	
	
PL4:	bge	$a2,$s1,PL1
		addi $a3,$0,0
PL3:	bge	$a3,$s1,PL2

		lw	$a0,0($a1)
		li	$v0,1
		syscall
		la	$a0,space
		li	$v0,4
		syscall
		addi $a1,$a1,4
		addi $a3,$a3,1
		b 	PL3

PL2:	addi	$a2,$a2,1
		la	$a0,new_line
		li	$v0,4
		syscall
		b	PL4
PL1:	jr	$ra

