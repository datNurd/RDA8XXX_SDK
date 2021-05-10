# 1 "src/zoom.S"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "D:/Desktop/watch/RDA8955_W17.44_IDH/soft/target/8955_modem/include/fpconfig.h" 1
# 1 "<command-line>" 2
# 1 "src/zoom.S"
# 1 "D:/Desktop/watch/RDA8955_W17.44_IDH/soft/platform/chip/regs/8955/include/regdef.h" 1
# 2 "src/zoom.S" 2

 .text
 .globl VidRec_bilinear_zoom
 .ent VidRec_bilinear_zoom
 .set noreorder
#void VidRec_bilinear_zoom(char* srcbuf,int src_width,int src_height,int cut_width,int cut_height,char* decbuf,int dec_width,int dec_height)
#function: zoom video image, YUV 4:2:0 to YUV 4:2:0
#2009/00/00 created by liyongjian
#2009/03/06 modified by liyongian fix the last row and line interpolation mistake.
VidRec_bilinear_zoom:
 subu $29, $29, 64
 sw $31, 60($29)
 sw $30, 56($29)
 sw $16, 52($29)
 sw $17, 48($29)
 sw $18, 44($29)
 sw $19, 40($29)
 sw $20, 36($29)
 sw $21, 32($29)
 sw $22, 28($29)
 sw $23, 24($29)

 lw $16, 80($29) #$16 = cut_height
 lw $17, 92($29)
 lw $18, 88($29) #$18 = dec_width
 sll $8, $7, 16
 sll $9, $16, 16
 div $8, $18
 subu $16, $6, $16
 mflo $8 #scaleH=(cut_width<<16)/dec_width
 subu $7, $5, $7

 mult $16, $5
 addu $4, $4, $7
 mflo $16
 addu $4, $4, $16

 div $9, $17
 lw $2, 96($29) #BuffA
 sll $3, $18, 1
 addu $3, $2, $3 #BuffB
 mflo $9 #scaleV=(cut_height<<16)/dec_height
 li $6, 0x0 #Accumulator
 cache 2, 0
 nop
 nop
 nop

 lw $16, 84($29) #char* decbuf
 li $19, -1
 sll $5, $5, 1
 addiu $17, $17, -1
loop_height_start:
 sra $20, $6, 16 #$20 = upline
 addiu $10, $20, 0x1
 mult $10, $5
 slt $11, $20, $19
 mflo $10
 bne $11, $0, row_interpolate
 addu $10, $4, $10 #delay slot $8=pLine??????

 move $21, $2 #$21 = ptempBuff
 move $2, $3
 move $3, $21
line_interpolate_start:
 move $22, $21 #$22 = pY
 move $23, $21 #$23 = pUV
 lw $18, 88($29)
 li $7, 0x0 #Accumulator2
 addiu $18, $18, -2

loop_width_start:
 sra $11, $7, 16
 sll $11, $11, 1
 addu $12, $11, $10
 sll $11, $11, 1
 addu $13, $11, $10

 andi $14, $7, 0xffff
 li $15, 0x10000
 subu $15, $15, $14

 lbu $24, 0($12)
 lbu $25, 2($12)

 mult $24, $15
 lbu $11, 1($13)
 madd $25, $14
 lbu $12, 5($13)
 mflo $24
 sra $24, $24, 16
 sb $24, 0($22)

 mult $11, $15
 addiu $22, $22, 0x2
 madd $12, $14
 lbu $24, 3($13)
 mflo $11
 sra $11, $11, 16
 lbu $25, 7($13)
 sb $11, 1($23)

 mult $24, $15
 addu $7, $7, $8
 madd $25, $14
 addiu $18, $18, -2
 mflo $24
 sra $24, $24, 16
 sb $24, 3($23)

 bne $18, $0, loop_width_start
 addiu $23, $23, 0x4
#for last point U V
 sra $11, $7, 16
 sll $11, $11, 1
 addu $12, $11, $10
 sll $11, $11, 1
 addu $13, $11, $10

 andi $14, $7, 0xffff
 li $15, 0x10000
 subu $15, $15, $14

 lbu $24, 0($12)
 lbu $25, 2($12)
 mult $24, $15
 lbu $11, 1($13) #load first U
 madd $25, $14
 lbu $12, 3($13) #load first V
 mflo $24
 sra $24, $24, 16
 sb $24, 0($22)
 sb $11, 1($23)
 sb $12, 3($23)

 lw $18, 88($29)
 addiu $22, $22, 0x2
 addu $7, $7, $8
 addiu $18, $18, -2

loop_width_start2:
 sra $11, $7, 16
 sll $11, $11, 1
 addu $12, $11, $10

 andi $14, $7, 0xffff
 li $15, 0x10000
 subu $15, $15, $14

 lbu $24, 0($12)
 lbu $25, 2($12)

 mult $24, $15
 addu $7, $7, $8
 madd $25, $14
 addiu $18, $18, -2
 mflo $24
 sra $24, $24, 16
 sb $24, 0($22)

 bne $18, $0, loop_width_start2
 addiu $22, $22, 0x2
 sb $24, 0($22) #for the last point Y

 beq $20, $19, line_interpolate_end #if(upLine!=lastLine)
 subu $10, $10, $5
 move $19, $20
 j line_interpolate_start
 move $21, $2

line_interpolate_end:
 addiu $19, $19, 1
row_interpolate:
 move $12, $2
 move $13, $3
 lw $18, 88($29)
 andi $14, $6, 0xffff
 li $15, 0x10000
 subu $15, $15, $14

row_loop_start:
 lbu $24, 0($12)
 lbu $25, 0($13)

 mult $24, $15
 lbu $23, 1($12)
 madd $25, $14
 lbu $22, 1($13)
 mflo $11
 sra $11, $11, 16
 sb $11, 0($16)

 mult $23, $15
 addiu $12, $12, 2
 madd $22, $14
 addiu $13, $13, 2
 mflo $11
 sra $11, $11, 16
 sb $11, 1($16)

 addiu $18, $18, -1
 bne $18, $0, row_loop_start
 addiu $16, $16, 2

 addiu $17, $17, -1
 bne $17, $0, loop_height_start
 addu $6, $6, $9

loop_height_end:

 move $13, $2
 lw $18, 88($29)
lastline_start:
 lw $24, 0($2)
 lw $25, 4($2)
 addiu $2, $2, 8
 sw $24, 0($16)
 sw $25, 4($16)
 addiu $18, $18, -4
 bne $18, $0, lastline_start
 addiu $16, $16, 8


 lw $31, 60($29)
 lw $30, 56($29)
 lw $16, 52($29)
 lw $17, 48($29)
 lw $18, 44($29)
 lw $19, 40($29)
 lw $20, 36($29)
 lw $21, 32($29)
 lw $22, 28($29)
 lw $23, 24($29)
 lw $2, 20($29)
 lw $3, 16($29)
 jr $31
 addu $29, $29, 64
 .set reorder
 .end VidRec_bilinear_zoom
