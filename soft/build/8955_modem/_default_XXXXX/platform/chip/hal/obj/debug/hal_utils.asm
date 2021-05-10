# 1 "src/hal_utils.S"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "D:/Desktop/watch/RDA8955_W17.44_IDH/soft/target/8955_modem/include/fpconfig.h" 1
# 1 "<command-line>" 2
# 1 "src/hal_utils.S"
# 13 "src/hal_utils.S"
# 1 "D:/Desktop/watch/RDA8955_W17.44_IDH/soft/platform/chip/regs/8955/include/regdef.h" 1
# 14 "src/hal_utils.S" 2
# 43 "src/hal_utils.S"
    .text
    .set nomips16
    .global hal_CallWithStack
    .ent hal_CallWithStack

hal_CallWithStack:





    move $8, $29
    move $29, $4

    subu $29, $29, 48
    sw $8, 40($29)
    sw $31, 44($29)

    move $9, $5
    move $4, $6
    move $5, $7
    lw $6, 16($8)
    lw $7, 20($8)
    lw $2, 24($8)
    sw $2, 16($29)
    lw $2, 28($8)
    sw $2, 20($29)
    lw $2, 32($8)
    sw $2, 24($29)
    lw $2, 36($8)
    sw $2, 28($29)
    jal $9

    lw $31, 44($29)
    lw $29, 40($29)
    jr $31

    .end hal_CallWithStack
