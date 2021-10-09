.data
    matA:
        .word 1,2,3,4
    matB:
        .word 5,6,7,8
    matC:
        .word 0,0,0,0
    promt1:
        .asciiz "Mat A: \n"
    promt2:
        .asciiz "Mat B: \n"
    new_line: 
    	.asciiz "\n" 
    space: 
    	.asciiz " "
    n:
        .word 2
.text
main:
    la $s1, n
    lw $s1, 0($s1)
    la $s2, matA
    la $s3, matB
    j print


print:
    la $a0, promt1
    la $a1, matA
    jal printMat

    la $a0, promt2
    la $a1, matB
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
#---------------------------------------------------------
.data
    matA:
        .word 1,2,3,4
    matB:
        .word 5,6,7,8
    matC:
        .word 0,0,0,0
    promt1:
        .asciiz "Mat A: \n"
    promt2:
        .asciiz "Mat B: \n"
    promt3:
        .asciiz "Mat C: \n"
    new_line:
        .asciiz "\n"
    space:
        .asciiz " "
    n:
        .word 2
.text
main:
    la $s1, n
    lw $s1, 0($s1)

    la $a0, matA
    la $a1, matB
    la $a2, matC
    jal mm

    la $s2, matA
    la $s3, matB
    la $s4, matC
    j print


print:
    la $a0, promt1
    la $a1, matA
    jal printMat

    la $a0, promt2
    la $a1, matB
    jal printMat

    la $a0, promt3
    la $a1, matC
    jal printMat

    #exit
    li $v0, 10
    syscall

printMat:
    li $v0, 4 #print string
    syscall
    addi $a2,$0,0

    PL4:
        bge $a2,$s1,PL1
        addi $a3,$0,0
    PL3:
        bge $a3,$s1,PL2

        lw $a0,0($a1)
        li $v0,1
        syscall
        la $a0,space
        li $v0,4
        syscall
        addi $a1,$a1,4
        addi $a3,$a3,1
        b PL3

    PL2:
        addi $a2,$a2,1
        la $a0,new_line
        li $v0,4
        syscall
        b PL4
    PL1:
        jr $ra


mm:
    #save $s0, $s1, $s2
    addi $sp, $sp, -12
    sw $s0, 8($sp)
    sw $s1, 4($sp)
    sw $s2, 0($sp)

    #creating the nested for-pass addresses as parameters
    addiu $t2, $zero, 1
    andi $t0, 0x0
    andi $t1, 0x0

for:
    ##set address of a[i][k] in a register
    sll $t0, $s0, 1
    add $t0, $t0, $s2
    sll $t0, $t0, 3
    add $t0, $t0, $a0 ##$t0 contains a[i][k] address
    ldc1 $f0, 0($t0)

    ##set address of b[k][j] in a register
    sll $t1, $s2, 1
    add $t1, $t1, $s1
    sll $t1, $t1, 3
    add $t1, $t1, $a1 ##$t1 contains b[k][j] address
    ldc1 $f2, 0($t1)

    ##set address of c[i][j] in a register
    sll $t3, $s0, 1
    add $t3, $t3, $s1
    sll $t3, $t3, 3
    add $t3, $t3, $a2 ##t3 contains address of c[i][j]
    ldc1 $f4, 0($t3)
    #multiply a[i][k]*b[k][j]
    mul.d $f0, $f0, $f2
    add.d $f4, $f4, $f0
    sdc1 $f4, 0($t3)



    bne $s2, $t2, L1 #if k!=2 go to L1
    andi $s2, 0x0 #else k=0

    bne $s1, $t2, L2 #if j!=2 go to L2
    andi $s1, 0x0

    bne $s0, $t2, L3 #if i!=2 go to L3
    j EXIT

    L1:
        addiu $s2, $s2, 1
        j for

    L2:
        addiu $s1, $s1, 1
        j for

    L3:
        addiu $s0, $s0, 1
        j for
    EXIT:
        #return previous values to registers
        lw $s2, 0($sp)
        lw $s1, 4($sp)
        lw $s0, 8($sp)
        addi $sp, $sp, 12
        jr $ra
