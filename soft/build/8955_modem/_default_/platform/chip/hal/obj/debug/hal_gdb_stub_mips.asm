# 1 "src/hal_gdb_stub_mips.S"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "D:/Desktop/watch/RDA8955_W17.44_IDH/soft/target/8955_modem/include/fpconfig.h" 1
# 1 "<command-line>" 2
# 1 "src/hal_gdb_stub_mips.S"
# 28 "src/hal_gdb_stub_mips.S"
# 1 "D:/Desktop/watch/RDA8955_W17.44_IDH/soft/platform/chip/regs/8955/include/regdef.h" 1
# 29 "src/hal_gdb_stub_mips.S" 2
# 1 "D:/Desktop/watch/RDA8955_W17.44_IDH/soft/platform/chip/regs/8955/include/cp0.h" 1
# 30 "src/hal_gdb_stub_mips.S" 2
# 1 "src/halp_irq_handler.h" 1
# 31 "src/hal_gdb_stub_mips.S" 2
# 1 "D:/Desktop/watch/RDA8955_W17.44_IDH/soft/platform/chip/regs/8955/include/sys_irq_asm.h" 1
# 23 "D:/Desktop/watch/RDA8955_W17.44_IDH/soft/platform/chip/regs/8955/include/sys_irq_asm.h"
# 1 "D:/Desktop/watch/RDA8955_W17.44_IDH/soft/platform/chip/regs/8955/include/globals_asm.h" 1
# 24 "D:/Desktop/watch/RDA8955_W17.44_IDH/soft/platform/chip/regs/8955/include/sys_irq_asm.h" 2
# 32 "src/hal_gdb_stub_mips.S" 2

.text

.globl hal_GdbInvalidCache
.ent hal_GdbInvalidCache
.frame $29,0,$31
hal_GdbInvalidCache:
    .set noreorder
    .align 4
    cache 0,0
    nop
    nop
    nop
    jr $31
    nop
    .set reorder
.end hal_GdbInvalidCache

.globl hal_GdbInvalidICache
.ent hal_GdbInvalidICache
hal_GdbInvalidICache:
    .set noreorder
    .align 4
    cache 1,0
    nop
    nop
    nop
    jr $31
    nop
    .set reorder
.end hal_GdbInvalidICache

.globl hal_GdbInvalidCacheData
.ent hal_GdbInvalidCacheData
.frame $29,0,$31
hal_GdbInvalidCacheData:
    .set noreorder
    .align 4
    cache 2,0
    nop
    nop
    nop
    jr $31
    nop
    .set reorder
.end hal_GdbInvalidCacheData

.globl hal_GdbDisableDebugIrq
.ent hal_GdbDisableDebugIrq
.frame $29,0,$31
hal_GdbDisableDebugIrq:
    .align 4
    mfc0 $8, $12
    li $9, ~((0x400) << (4))
    move $2, $8
    and $8, $8, $9
    mtc0 $8, $12
    jr $31
.end hal_GdbDisableDebugIrq
