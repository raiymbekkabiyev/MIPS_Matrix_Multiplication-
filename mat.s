.data
    matA:
        .word 1,2,3,4
    matB:
        .word 5,6,7,8
    matC:
        .word 0,0,0,0
    promt1:
        .asciiz "Mat A: \n"

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





