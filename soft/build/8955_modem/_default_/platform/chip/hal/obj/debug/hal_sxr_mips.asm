# 1 "src/hal_sxr_mips.S"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "D:/Desktop/watch/RDA8955_W17.44_IDH/soft/target/8955_modem/include/fpconfig.h" 1
# 1 "<command-line>" 2
# 1 "src/hal_sxr_mips.S"
# 28 "src/hal_sxr_mips.S"
# 1 "D:/Desktop/watch/RDA8955_W17.44_IDH/soft/platform/chip/regs/8955/include/regdef.h" 1
# 29 "src/hal_sxr_mips.S" 2
# 1 "D:/Desktop/watch/RDA8955_W17.44_IDH/soft/platform/chip/regs/8955/include/cp0.h" 1
# 30 "src/hal_sxr_mips.S" 2
# 1 "D:/Desktop/watch/RDA8955_W17.44_IDH/soft/platform/chip/regs/8955/include/global_macros.h" 1
# 31 "src/hal_sxr_mips.S" 2
# 1 "D:/Desktop/watch/RDA8955_W17.44_IDH/soft/platform/chip/regs/8955/include/sys_irq_asm.h" 1
# 23 "D:/Desktop/watch/RDA8955_W17.44_IDH/soft/platform/chip/regs/8955/include/sys_irq_asm.h"
# 1 "D:/Desktop/watch/RDA8955_W17.44_IDH/soft/platform/chip/regs/8955/include/globals_asm.h" 1
# 24 "D:/Desktop/watch/RDA8955_W17.44_IDH/soft/platform/chip/regs/8955/include/sys_irq_asm.h" 2
# 32 "src/hal_sxr_mips.S" 2


# 1 "src/halp_gdb_stub.h" 1
# 35 "src/hal_sxr_mips.S" 2
# 1 "src/halp_irq_handler.h" 1
# 36 "src/hal_sxr_mips.S" 2



.extern sxr_IrqStack_pointer
# 85 "src/hal_sxr_mips.S"
    .section .sramtext, "awx", @progbits


    .balign 0x10

    .globl sxr_TaskSwap
    .ent sxr_TaskSwap
sxr_TaskSwap:
    .frame $29, 0, $31

    bnez $27, $L_TaskSwap_in_irq



    li $8, (((0xa0000000 | 0x01A01000) & 0xffff8000) + (0x01A01000 & 0x8000))
    lw $8, (((0x01A01000) & 0x7fff) - (0x01A01000 & 0x8000)) + 0x00000014($8)

    subu $29, $29, (20) # update task SP




    sw $16,0($29) # save $16
    sw $17,4($29) # save $17
# 119 "src/hal_sxr_mips.S"
    sw $31,12($29) # save Pc from ctx
    sw $8,16($29) # save CTX Type (>=0 is from function - <0 is From IT) + Critical section flag


    sw $29, 0($4)

    lw $29,0($5) # load Sp from ctx





    li $8, (((0xa0000000 | 0x01A01000) & 0xffff8000) + (0x01A01000 & 0x8000))

    lw $9,16($29) # restore CTX type and SC
    lw $17,4($29) # restore $17
    lw $16,0($29) # restore $16
# 145 "src/hal_sxr_mips.S"
    lw $4,8($29) # restore task param




    bltz $9, $L_TaskSwap_big

    lw $31, 12($29) # restore PC
    addu $29, $29, (20)



    sw $9, (((0x01A01000) & 0x7fff) - (0x01A01000 & 0x8000)) + 0x00000014($8)


    jr $31

$L_TaskSwap_big:


    li $25, (0xff00 | 0x0004 | 0)
    mtc0 $25, $12



    sw $9, (((0x01A01000) & 0x7fff) - (0x01A01000 & 0x8000)) + 0x00000014($8)

    lw $24, 12($29) # restore PC
    addu $29, $29, (20)




    lw $8, 0($29)
    lw $9, 4($29)
    mtlo $8
    mthi $9

    lw $2,8($29)
    lw $3,12($29)
    lw $5,16($29)
    lw $6,20($29)
    lw $7,24($29)
    lw $10,36($29)







    lw $25,44($29)
    lw $31,48($29)
    .set noat
    lw $at,52($29)
    .set at






    move $26,$24

    lw $24,40($29)



    lw $8,28($29)
    lw $9,32($29)

    addu $29, $29, (56)

    .set noreorder
    jr $26
    rfe
    .set reorder

$L_TaskSwap_in_irq:

    sw $28,0($4) # save old Sp to ctx
    lw $28,0($5) # load New Sp from ctx
    jr $31
# 237 "src/hal_sxr_mips.S"
    .type sxr_TaskSwap,@function
    .size sxr_TaskSwap,.-sxr_TaskSwap
    .end sxr_TaskSwap
# 254 "src/hal_sxr_mips.S"
    .text


    .globl sxr_TaskSetUp
    .ent sxr_TaskSetUp
sxr_TaskSetUp:
    .frame $29, 0, $31

    lw $8,0($4) # load Sp from ctx
    lw $9,4($4) # load Pc from ctx

    subu $8,$8,16
    subu $8, $8, (20) # update task SP
    li $10,1

    sw $5,8($8) # save task param
    sw $9,12($8) # save Pc from ctx
    sw $10,16($8) # save CTX Type (>=0 is from function - <0 is From IT) + SC

    sw $8,0($4) # save new Sp to ctx

    jr $31

    .type sxr_TaskSetUp,@function
    .size sxr_TaskSetUp,.-sxr_TaskSetUp
    .end sxr_TaskSetUp
# 293 "src/hal_sxr_mips.S"
    .globl sxr_TaskFirst
    .ent sxr_TaskFirst
sxr_TaskFirst:
    .frame $29, 0, $31
# 306 "src/hal_sxr_mips.S"
    li $9, ((0xFFFFFFFF<<0) &~ (1<<15))




    li $8, (((0xa0000000 | 0x01A01000) & 0xffff8000) + (0x01A01000 & 0x8000))
    lw $0, (((0x01A01000) & 0x7fff) - (0x01A01000 & 0x8000)) + 0x00000014($8)




    sw $9, (((0x01A01000) & 0x7fff) - (0x01A01000 & 0x8000)) + 0x00000008($8)


    mtc0 $0, $13
    li $24, (0xff00 | 0x0001 | 0)
    mtc0 $24, $12


    lw $9,0($4) # load Sp from ctx
    lw $4,8($9) # restore task param
    lw $31,12($9) # restore RA
    lw $10,16($9) # We know we came from a function, need SC

    addu $29, $9, (20) # New Stack Pointer

    li $27, 0




    sw $10, (((0x01A01000) & 0x7fff) - (0x01A01000 & 0x8000)) + 0x00000014($8)

    jr $31

    .type sxr_TaskFirst,@function
    .size sxr_TaskFirst,.-sxr_TaskFirst
    .end sxr_TaskFirst
# 362 "src/hal_sxr_mips.S"
        .globl sxr_JobSetUp
        .ent sxr_JobSetUp

sxr_JobSetUp:


        lw $8, 0($5) # Job Sp
        lw $9, 4($5)
        lw $24, 8($5) # Job data
        lw $9, 0($9) # Job Pc

        subu $8, $8, (24)
        sw $24, 8($8) # Save job data
        sw $4, 12($8) # Save job number
        sw $9, 16($8) # Save job Pc
        sw $0, 20($8) # Save job InteruptStack

        sw $8, 0($5) # Save Job Sp in job context.


        j $31
    .type sxr_JobSetUp,@function
    .size sxr_JobSetUp,.-sxr_JobSetUp
    .end sxr_JobSetUp
# 397 "src/hal_sxr_mips.S"
        .section .sramtext, "awx", @progbits


        .balign 0x10

        .globl sxr_JobSwap
        .ent sxr_JobSwap

sxr_JobSwap:




        li $8, ( ((((0xa0000000 | 0x01A01000) & 0xffff8000) + (0x01A01000 & 0x8000))) | 0xa0000000 )
        lw $0, (((0x01A01000) & 0x7fff) - (0x01A01000 & 0x8000)) + 0x00000014($8)



#-------------





        subu $29, $29, 28

        sw $31, 24($29)
        sw $4, 20($29)
        sw $5, 16($29)

        jal JobSwap_SpyBefore

        lw $31, 24($29)
        lw $4, 20($29)
        lw $5, 16($29)

        addu $29, $29, 28


#-------------

        lw $8, sxr_Job
        subu $29, $29, (24)
        lb $9, 0($8) # Get current Job number

        sw $16, 0($29)
        sw $17, 4($29)
# 453 "src/hal_sxr_mips.S"
        sw $9, 12($29) # Save job number
        sw $31, 16($29) # Save Job Pc

        sw $29, 0($4) # Save Job Sp in old job context.

#-------------
        move $9, $0 # context Interrupt stack value
        bge $27, 0x01000000, $L_JS_comming_from_job
            lw $9, sxr_IrqStack_pointer
            beqz $27, $L_JS_comming_from_task
                sw $29, sxr_IrqStack_pointer
$L_JS_comming_from_task:
$L_JS_comming_from_job:
        sw $9, 20($29)
#-------------

        lw $29, 0($5) # Get Job Sp form new job context.






#-------------
        lw $9, 20($29) # context Interrupt stack value
        li $25, 0x01000000
        or $27, $27, $25
        beqz $9, $L_JS_going_to_job
            sw $9, sxr_IrqStack_pointer
            #li $25, ~0x01000000
            not $25
            and $27, $27, $25
$L_JS_going_to_job:
#-------------

        lw $16, 0($29)
        lw $17, 4($29)
# 502 "src/hal_sxr_mips.S"
        move $25, $4


        lw $4, 8($29) # Restore Job data
        lw $9, 12($29) # Restore job number
        lw $31, 16($29) # Restore Job PC
        sb $9, 0($8)
        addu $29, $29, (24)

 #-------------





        subu $29, $29, 28

        sw $31, 24($29)
        sw $4, 20($29)
        sw $5, 16($29)

        move $4, $25

        jal JobSwap_SpyAfter

        lw $31, 24($29)
        lw $4, 20($29)
        lw $5, 16($29)

        addu $29, $29, 28
        li $24, (((0xa0000000 | 0x01A01000) & 0xffff8000) + (0x01A01000 & 0x8000))


 #-------------


        li $9, 1
        sw $9, (((0x01A01000) & 0x7fff) - (0x01A01000 & 0x8000)) + 0x00000014($24)


        jr $31
    .type sxr_JobSwap,@function
    .size sxr_JobSwap,.-sxr_JobSwap
    .end sxr_JobSwap
