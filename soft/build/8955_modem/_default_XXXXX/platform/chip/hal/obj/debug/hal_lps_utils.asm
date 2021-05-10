# 1 "src/hal_lps_utils.S"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "D:/Desktop/watch/RDA8955_W17.44_IDH/soft/target/8955_modem/include/fpconfig.h" 1
# 1 "<command-line>" 2
# 1 "src/hal_lps_utils.S"
# 28 "src/hal_lps_utils.S"
# 1 "D:/Desktop/watch/RDA8955_W17.44_IDH/soft/platform/chip/regs/8955/include/regdef.h" 1
# 29 "src/hal_lps_utils.S" 2
# 1 "D:/Desktop/watch/RDA8955_W17.44_IDH/soft/platform/chip/regs/8955/include/cp0.h" 1
# 30 "src/hal_lps_utils.S" 2
# 1 "D:/Desktop/watch/RDA8955_W17.44_IDH/soft/platform/chip/regs/8955/include/global_macros.h" 1
# 31 "src/hal_lps_utils.S" 2
# 1 "D:/Desktop/watch/RDA8955_W17.44_IDH/soft/platform/chip/regs/8955/include/sys_irq_asm.h" 1
# 23 "D:/Desktop/watch/RDA8955_W17.44_IDH/soft/platform/chip/regs/8955/include/sys_irq_asm.h"
# 1 "D:/Desktop/watch/RDA8955_W17.44_IDH/soft/platform/chip/regs/8955/include/globals_asm.h" 1
# 24 "D:/Desktop/watch/RDA8955_W17.44_IDH/soft/platform/chip/regs/8955/include/sys_irq_asm.h" 2
# 32 "src/hal_lps_utils.S" 2


# 1 "src/halp_gdb_stub.h" 1
# 35 "src/hal_lps_utils.S" 2
# 1 "src/halp_irq_handler.h" 1
# 36 "src/hal_lps_utils.S" 2


.extern sxr_IrqStack_pointer
.extern hal_LpsDeepSleep
.extern hal_LpsLightSleep
# 68 "src/hal_lps_utils.S"
    .globl hal_LpsDeepSleepWrapper
    .ent hal_LpsDeepSleepWrapper
hal_LpsDeepSleepWrapper:
    .frame $29, 32, $31



    mfc0 $9, $12
    li $8, ~1
    and $8, $9
    mtc0 $8, $12
    .set noat
    li $at, 0x00001000
    or $27, $27, $at
    .set at

    lw $8, sxr_IrqStack_pointer
    addiu $8, $8, -32
    sw $9, 24($8)
    sw $29, 20($8)
    sw $31, 16($8)
    move $29, $8

    jal hal_LpsDeepSleep

    .set noat
    li $at, ~0x00001000
    and $27, $27, $at
    .set at
    lw $9, 24($29)
    lw $31, 16($29)
    lw $29, 20($29)
    mtc0 $9, $12
    jr $31

    .type hal_LpsDeepSleepWrapper,@function
    .size hal_LpsDeepSleepWrapper,.-hal_LpsDeepSleepWrapper
    .end hal_LpsDeepSleepWrapper
# 130 "src/hal_lps_utils.S"
    .globl hal_LpsLightSleepWrapper
    .ent hal_LpsLightSleepWrapper
hal_LpsLightSleepWrapper:
    .frame $29, 32, $31



    mfc0 $9, $12
    li $8, ~1
    and $8, $9
    mtc0 $8, $12
    .set noat
    li $at, 0x00001000
    or $27, $27, $at
    .set at

    lw $8, sxr_IrqStack_pointer
    addiu $8, $8, -32
    sw $9, 24($8)
    sw $29, 20($8)
    sw $31, 16($8)
    move $29, $8

    jal hal_LpsLightSleep

    .set noat
    li $at, ~0x00001000
    and $27, $27, $at
    .set at
    lw $9, 24($29)
    lw $31, 16($29)
    lw $29, 20($29)
    mtc0 $9, $12
    jr $31

    .type hal_LpsLightSleepWrapper,@function
    .size hal_LpsLightSleepWrapper,.-hal_LpsLightSleepWrapper
    .end hal_LpsLightSleepWrapper
