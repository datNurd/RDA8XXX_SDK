# 1 "src/mid.S"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "D:/Desktop/watch/RDA8955_W17.44_IDH/soft/target/8955_modem/include/fpconfig.h" 1
# 1 "<command-line>" 2
# 1 "src/mid.S"

# 1 "D:/Desktop/watch/RDA8955_W17.44_IDH/soft/platform/chip/regs/8955/include/regdef.h" 1
# 3 "src/mid.S" 2
# 15 "src/mid.S"
.globl mult32_r1
.ent mult32_r1
mult32_r1:
 mult $4,$5
 li $15,32
 subu $15,$15,$6
 mflo $8
 mfhi $9

 srl $8,$8,$6
 sll $9,$9,$15

 or $2,$8,$9
 jr $31

.end mult32_r1
# 41 "src/mid.S"
.globl div_320_320
.ent div_320_320
div_320_320:
 divu $2,$4,$5
 jr $31

.end div_320_320
