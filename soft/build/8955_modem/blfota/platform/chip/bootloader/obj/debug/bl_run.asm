# 1 "src/bl_run.S"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "D:/Desktop/watch/RDA8955_W17.44_IDH/soft/target/8955_modem/include/fpconfig.h" 1
# 1 "<command-line>" 2
# 1 "src/bl_run.S"
# 13 "src/bl_run.S"
# 1 "D:/Desktop/watch/RDA8955_W17.44_IDH/soft/platform/chip/regs/8955/include/regdef.h" 1
# 14 "src/bl_run.S" 2

    .set nomips16

    .global bl_run_with_stack
    .ent bl_run_with_stack
bl_run_with_stack:

    addiu $29, $29, -24
    sw $16, 16($29)
    sw $31, 20($29)
    move $16, $6
    move $29, $6
    jalr $5
    move $29, $16
    lw $7, 20($29)
    lw $16, 16($29)
    jr $7

    .end bl_run_with_stack
