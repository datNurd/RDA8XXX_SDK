# 1 "src/hal_gdb.S"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "D:/Desktop/watch/RDA8955_W17.44_IDH/soft/target/8955_modem/include/fpconfig.h" 1
# 1 "<command-line>" 2
# 1 "src/hal_gdb.S"
# 26 "src/hal_gdb.S"
# 1 "D:/Desktop/watch/RDA8955_W17.44_IDH/soft/platform/chip/regs/8955/include/regdef.h" 1
# 27 "src/hal_gdb.S" 2
# 1 "D:/Desktop/watch/RDA8955_W17.44_IDH/soft/platform/chip/regs/8955/include/cp0.h" 1
# 28 "src/hal_gdb.S" 2
# 1 "src/halp_gdb_stub.h" 1
# 29 "src/hal_gdb.S" 2
# 39 "src/hal_gdb.S"
    .set nomips16
    .globl hal_DbgGdbPrintf
    .globl dbg_GdbPrint
    .ent hal_DbgGdbPrintf
    .frame $29, 0, $31
hal_DbgGdbPrintf:
dbg_GdbPrint:
    break 15
    jr $31
    nop
    .type hal_DbgGdbPrintf,@function
    .size hal_DbgGdbPrintf,.-hal_DbgGdbPrintf
    .end hal_DbgGdbPrintf






    .data

    .globl hal_GdbGBreak
hal_GdbGBreak:
    .word hal_GdbBreaks
    .word hal_GdbBreakSoftBreakPoint
    .word hal_GdbBreakRaise
    .word hal_GdbBreaks
    .word hal_GdbBreaks
    .word hal_GdbBreakBreakPoint
    .word hal_GdbBreaks
    .word hal_GdbBreakDivBy0
    .word hal_GdbBreaks
    .word hal_GdbBreaks
    .word hal_GdbBreaks
    .word hal_GdbBreaks
    .word hal_GdbBreaks
    .word hal_GdbBreaks
    .word hal_GdbBreaks
    .word hal_GdbBreakPrint
