/* ======================================================================= */
/*                  TARGET CONFIGURATION SECTION                           */
/* ======================================================================= */
/* modem2g_bcpu_master.ld */
/* The following values are defined in ff_target.def and exported by the Makefile */
/*  FLASH_SIZE              */
/*  RAM_SIZE                */
/*  CALIB_BASE              */
/*  FACT_SETTINGS_BASE      */
/*  CODE_BASE               */
/*  USER_DATA_BASE          */
/*  USER_DATA_SIZE          */
/* ======================================================================= */
/*                  END CONFIGURATION SECTION                              */
/* ======================================================================= */
/* The linker script depends on the following defines */
/*  - CONST_IN_RAM : all constants are placed in RAM, this is useful for ram_run */
/*  - CODE_IN_RAM : All code is executed from RAM, this is useful for ram_run or code running from RAM on romulator */
/*  - PRELOADED_INT_SRAM : The internal SRAM are already preloaded, useful for ram_run */
/*  - PRELOADED_RAM : The external RAM is already preloaded, useful for ram_run or simu */
/*  - __NATIVE_JAVA__ :  The Native Java need  reload it's data and bss section every time when app start*/
/* Those are constants of the system */


/* ROM content selection: things to include
 * WARNING: the DISCARD section uses the opposite -->
 * do all inclusion before discard !*/


/* Take into account assert bug in binutils-2.15*/
/*Mandatory to have the BB side irq handler linked */
EXTERN (bcpu_main)
EXTERN (g_spcMapAccess)
EXTERN (g_sppMapAccess)
SECTIONS
{
    /* ========================================== */
    /* in External RAM                            */
    /* ========================================== */
    . = 0xFFFFFFFF82000000;
    /* ------------------------------------------------ */
    /* SPI REG DEBUG - Ext RAM UNCACHED */
    /* ------------------------------------------------ */
    /* Just leave a hole for spi reg debug */
    . += 0x500 + 0x140 + 0x200 + 0x140 + 0x0;
    . = ALIGN(0x100);
    _bcpu_ram_available_base = .;
    /* ============================== */
    /* Main BCPU entry point */
    /* ============================== */
    . = 0xFFFFFFFF88000000+0x1100+0x10000;
    _bcpu_flash_start = .;
    _bcpu_flash_rotext_start = .;
    .bcpu_rotext . : AT (ADDR(.bcpu_rotext))
    {
        *spc_main.o(.bcpu_main_entry)
        *(.text .text.*)
        . = ALIGN(0x10);
    }
    _bcpu_flash_rotext_end = .;
    _bcpu_flash_rodata_start = .;
    .bcpu_rodata . : AT (ADDR(.bcpu_rodata))
    {
        *(.rodata.g_spcMapAccess)
        . = ALIGN(0x10);
    }
    _bcpu_flash_rodata_end = .;
    _bcpu_rom_flash_start_location = .;
    /* ======================================== */
    /* BCPU rom in flash elf */
    /* ======================================== */
.bcpu_rom_text (0xffffffffa1e80000) : AT (0xffffffff81e80000) { KEEP(*bcpu_rom_CHIP.elf(.bcpu_rom_text)) }
.bcpu_rom_rodata (0xffffffff81e937b0) : AT (0xffffffff81e937b0) { KEEP(*bcpu_rom_CHIP.elf(.bcpu_rom_rodata)) }
.bbsram (0xffffffff81980000) (NOLOAD) : AT (0xffffffff81980000) { KEEP(*bcpu_rom_CHIP.elf(.bbsram)) }
.bbsramu (0xffffffffa1981e00) (NOLOAD) : AT (0xffffffffa1981e00) { KEEP(*bcpu_rom_CHIP.elf(.bbsramu)) }
.bbsram_globals (0xffffffff81986640) (NOLOAD) : AT (0xffffffff81986640) { KEEP(*bcpu_rom_CHIP.elf(.bbsram_globals)) }
.mailbox (0xffffffffa1b00580) (NOLOAD) : AT (0xffffffffa1b00580) { KEEP(*bcpu_rom_CHIP.elf(.mailbox)) }
.bcpu_rom_version_number (0xffffffff81e97ff8) : AT (0xffffffff81e97ff8) { KEEP(*bcpu_rom_CHIP.elf(.bcpu_rom_version_number)) }
.bcpu_rom.crc (0xffffffff81e97ffc) : AT (0xffffffff81e97ffc) { KEEP(*bcpu_rom_CHIP.elf(.bcpu_rom.crc)) }
    _bcpu_rom_flash_end_location = _bcpu_rom_flash_start_location;
    /* ================================================= */
    /* in BB SRAM                                        */
    /* ================================================= */
    _bb_sram_flash_start_location = _bcpu_rom_flash_end_location;
    . = 0xFFFFFFFF81980000;
    _bb_sram_start = .;
    _bb_sram_cached_size = 0;
    _bb_sram_uncached_size = 0;
    /* Read the symbol address from BCPU ROM */
    . = _bb_sram_romed_globals_end;
    .bbsram_globals_not_romed . (NOLOAD) : AT (ADDR(.bbsram_globals_not_romed))
    {
        _bb_sram_not_romed_globals_start = .;
        *(BB_SRAM_GLOBALS)
        *(.bbsram_globals)
        _bb_sram_not_romed_globals_end = .;
    }
    ASSERT(ABSOLUTE(0xFFFFFFFF81980000 + 0x8000 - 0x1800) >= ABSOLUTE(_bb_sram_not_romed_globals_end), "BBSRAM not romed globals overflow out of BBSRAM.")
    _bb_sram_var_size = _bb_sram_cached_size + _bb_sram_uncached_size;
    _bb_sram_var_end = _bb_sram_start + _bb_sram_var_size;
    /*----------------------- */
    /* BB SRAM Patch           */
    /*----------------------- */
    _bb_sram_patch_flash_start = _bb_sram_flash_start_location + _bb_sram_var_size;
    . = 0xFFFFFFFF81980000 + 0x8000 - 0x1800;
    _bb_sram_patch_start = .;
    .bbsram_patch_text . :
        AT (_bb_sram_patch_flash_start)
    {
        _bb_sram_patch_text_start = .;
        *(.bbsram_patch_text)
        *(.bbsram_patch_rodata)
        *(.rdata .rodata .rodata.str1.4 .rodata.* .rodata1)
        . = ALIGN(0x10);
        _bb_sram_patch_text_end = .;
    }
    _bb_sram_patch_text_size = _bb_sram_patch_text_end - _bb_sram_patch_text_start;
    .bbsram_patch_data . :
        AT (_bb_sram_patch_flash_start + _bb_sram_patch_text_size)
    {
        _bb_sram_patch_data_start = .;
        *(.bbsram_patch_data)
        . = ALIGN(0x10);
        _bb_sram_patch_data_end = .;
    }
    _bb_sram_patch_data_size = _bb_sram_patch_data_end - _bb_sram_patch_data_start;
    /* Go Uncached */
    . += 0x20000000;
    .bbsram_patch_ucdata . :
        AT (_bb_sram_patch_flash_start + _bb_sram_patch_text_size + _bb_sram_patch_data_size)
    {
        _bb_sram_patch_ucdata_start = .;
        *(.bbsram_patch_ucdata)
        . = ALIGN(0x10);
        _bb_sram_patch_ucdata_end = .;
    }
    _bb_sram_patch_ucdata_size = _bb_sram_patch_ucdata_end - _bb_sram_patch_ucdata_start;
    /* Go Cached */
    . -= 0x20000000;
    _bb_sram_patch_end = .;
    _bb_sram_patch_size = _bb_sram_patch_end - _bb_sram_patch_start;
    _bb_sram_patch_flash_end = _bb_sram_patch_flash_start + _bb_sram_patch_size;
    _bb_sram_flash_end_location = _bb_sram_patch_flash_end;
    /*----------------------- */
    /* BB SRAM Patch BSS           */
    /*----------------------- */
    _bb_sram_patch_bss_start = .;
    /* Go Uncached */
    . += 0x20000000;
    .bbsram_patch_ucbss . (NOLOAD) : AT (ADDR(.bbsram_patch_ucbss))
    {
        *(.bbsram_patch_ucbss)
        . = ALIGN(0x10);
    }
    /* Go Cached */
    . -= 0x20000000;
    .bbsram_patch_bss . (NOLOAD) : AT (ADDR(.bbsram_patch_bss))
    {
        *(.bbsram_patch_bss)
        . = ALIGN(0x10);
    }
    _bb_sram_patch_bss_end = .;
    _bb_sram_patch_bss_size = _bb_sram_patch_bss_end - _bb_sram_patch_bss_start;
    ASSERT(ABSOLUTE(0xFFFFFFFF81980000 + 0x8000) >= ABSOLUTE(_bb_sram_patch_bss_end), "BBSRAM patch code overflow out of BBSRAM.")
    /* ===================================================== */
    /* in BB DUALPORT SRAM                                           */
    /* ===================================================== */
    _bcpu_dualport_sram_flash_start_location = _bb_sram_flash_end_location;
    . = 0xFFFFFFFF81B00000;
    _bcpu_dualport_sram_start = .;
    .bcpu_dualport_sram_text . :
        AT (_bcpu_dualport_sram_flash_start_location)
    {
        _bcpu_dualport_sram_text_start = .;
        *(.dualport_sram_text)
        *(.dualport_sram_rodata)
        . = ALIGN(0x10);
        _bcpu_dualport_sram_text_end = .;
    }
    _bcpu_dualport_sram_text_size = _bcpu_dualport_sram_text_end - _bcpu_dualport_sram_text_start;
    .bcpu_dualport_sram_data . :
        AT (_bcpu_dualport_sram_flash_start_location + _bcpu_dualport_sram_text_size)
    {
        _bcpu_dualport_sram_cached_data_start = .;
        *(.dualport_sram_data)
        . = ALIGN(0x10);
        _bcpu_dualport_sram_cached_data_end = .;
    }
    _bcpu_dualport_sram_cached_data_size = _bcpu_dualport_sram_cached_data_end - _bcpu_dualport_sram_cached_data_start;
    /* Go Uncached */
    . += 0x20000000;
    .bcpu_dualport_sram_ucdata . :
        AT (_bcpu_dualport_sram_flash_start_location + _bcpu_dualport_sram_text_size + _bcpu_dualport_sram_cached_data_size)
    {
        _bcpu_dualport_sram_uncached_data_start = .;
        *(.dualport_sram_ucdata)
        . = ALIGN(0x10);
        _bcpu_dualport_sram_uncached_data_end = .;
    }
    _bcpu_dualport_sram_uncached_data_size = _bcpu_dualport_sram_uncached_data_end - _bcpu_dualport_sram_uncached_data_start;
    /* Go Cached */
    . -= 0x20000000;
    _bcpu_dualport_sram_end = .;
    _bcpu_dualport_sram_size = _bcpu_dualport_sram_end - _bcpu_dualport_sram_start;
    _bcpu_dualport_sram_flash_end_location = _bcpu_dualport_sram_flash_start_location + _bcpu_dualport_sram_size;
    _bcpu_dualport_bss_start = .;
    /* Go Uncached */
    . += 0x20000000;
    .bcpu_dualport_sram_ucbss . (NOLOAD) : AT (ADDR(.bcpu_dualport_sram_ucbss))
    {
        *(.dualport_sram_ucbss)
        . = ALIGN(0x10);
    }
    /* Go Cached */
    . -= 0x20000000;
    .bcpu_dualport_sram_bss . (NOLOAD) : AT (ADDR(.bcpu_dualport_sram_bss))
    {
        *(.dualport_sram_bss)
        . = ALIGN(0x10);
    }
    _bcpu_dualport_bss_end = .;
    _bcpu_dualport_bss_size = _bcpu_dualport_bss_end - _bcpu_dualport_bss_start;
    ASSERT(ABSOLUTE(0xFFFFFFFF81B00000 + 0x800 - 0x280) >= ABSOLUTE(_bcpu_dualport_bss_end), "BCPU DUALPORT SRAM overflow.")
    /* ===================================================== */
    /* in SYS SRAM                                           */
    /* ===================================================== */
    _bcpu_sys_sram_flash_start_location = _bcpu_dualport_sram_flash_end_location;
    . = 0xFFFFFFFF81C00680;
    _bcpu_sys_sram_start = .;
    .bcpu_sramtext . : AT (_bcpu_sys_sram_flash_start_location)
    {
        _bcpu_sys_sram_txt_start = .;
        *(.sramtext .sramrodata)
        . = ALIGN(0x10);
    }
    _bcpu_sys_sram_txt_end = .;
    _bcpu_sys_sram_txt_size = _bcpu_sys_sram_txt_end - _bcpu_sys_sram_start;
    .bcpu_sramdata _bcpu_sys_sram_txt_end : AT (_bcpu_sys_sram_flash_start_location + _bcpu_sys_sram_txt_size )
    {
        _bcpu_sys_sram_cached_start = .;
        *(.sramdata)
        . = ALIGN(0x10);
    }
    _bcpu_sys_sram_cached_end = .;
    _bcpu_sys_sram_cached_size = _bcpu_sys_sram_cached_end - _bcpu_sys_sram_cached_start;
    /*-------------------- */
    /* SYS SRAM UNCACHED   */
    /*-------------------- */
    /* Go Uncached */
    . += 0x20000000;
    .bcpu_sramucdata . : AT (_bcpu_sys_sram_flash_start_location + _bcpu_sys_sram_txt_size + _bcpu_sys_sram_cached_size)
    {
        _bcpu_sys_sram_uncached_start = .;
        *(.sramucdata)
        . = ALIGN(0x10);
    }
    _bcpu_sys_sram_uncached_end = .;
    _bcpu_sys_sram_uncached_size = _bcpu_sys_sram_uncached_end - _bcpu_sys_sram_uncached_start;
    /* Go Cached */
    . -= 0x20000000;
    _bcpu_sys_sram_end = .;
    _bcpu_sys_sram_size = _bcpu_sys_sram_end - _bcpu_sys_sram_start;
    _bcpu_sys_sram_flash_end_location = _bcpu_sys_sram_flash_start_location + _bcpu_sys_sram_size;
    /*----------------------- */
    /* SYS SRAM BSS           */
    /*----------------------- */
    _bcpu_sys_sram_bss_start = .;
    /* Go Uncached */
    . += 0x20000000;
    .bcpu_sramucbss . (NOLOAD) : AT (ADDR(.bcpu_sramucbss))
    {
        *(.sramucbss)
        . = ALIGN(0x10);
    }
    /* Go Cached */
    . -= 0x20000000;
    .bcpu_srambss . (NOLOAD) : AT (ADDR(.bcpu_srambss))
    {
        *(.srambss)
        . = ALIGN(0x10);
    }
    _bcpu_sys_sram_bss_end = .;
    _bcpu_sys_sram_bss_size = _bcpu_sys_sram_bss_end - _bcpu_sys_sram_bss_start;
    _bcpu_sys_sram_end = _bcpu_sys_sram_bss_end;
    /* Check that the INT SRAM is not over stuffed */
    ASSERT(ABSOLUTE(0xFFFFFFFF81C00000 +0x10000 -4 - 0x80 - 0xE00) > ABSOLUTE(_bcpu_sys_sram_bss_end), "BCPU Internal SRAM overflow !")
    /*---------------- */
    /* End of SYS SRAM */
    /*---------------- */
    /* ===================================================== */
    /* in External RAM                                           */
    /* ===================================================== */
         _bcpu_ram_flash_start_location = _bcpu_sys_sram_flash_end_location;
    . = _bcpu_ram_available_base;
    _bcpu_ram_start = .;
    .bcpu_ramtext . : AT (_bcpu_ram_flash_start_location)
    {
        _bcpu_ram_txt_start = .;
        *(.ram)
        . = ALIGN(0x10);
    }
    _bcpu_ram_txt_end = .;
    _bcpu_ram_txt_size = _bcpu_ram_txt_end - _bcpu_ram_start;
    _bcpu_ram_data_load_start = _bcpu_ram_flash_start_location + _bcpu_ram_txt_size;
    _bcpu_ram_data_start = .;
    .bcpu_data . : AT (_bcpu_ram_data_load_start)
    {
        _bcpu_ram_cached_start = .;
        *(.data .data.* .sdata .sdata.* .data1)
        . = ALIGN(0x10);
    }
    _bcpu_ram_cached_end = .;
    _bcpu_ram_cached_size = _bcpu_ram_cached_end - _bcpu_ram_cached_start;
    /*-------------------- */
    /* External RAM UNCACHED   */
    /*-------------------- */
    /* Go Uncached */
    . += 0x20000000;
    .bcpu_ucdata . : AT (_bcpu_ram_data_load_start + _bcpu_ram_cached_size)
    {
        _bcpu_ram_uncached_start = .;
        *(.ucdata)
        . = ALIGN(0x10);
    }
    _bcpu_ram_uncached_end = .;
    _bcpu_ram_uncached_size = _bcpu_ram_uncached_end - _bcpu_ram_uncached_start;
    /* Go Cached */
    . -= 0x20000000;
    _bcpu_ram_data_end = .;
    _bcpu_ram_data_size = _bcpu_ram_data_end - _bcpu_ram_data_start;
    _bcpu_ram_data_load_end = _bcpu_ram_data_load_start + _bcpu_ram_data_size;
    _bcpu_ram_end = .;
    _bcpu_ram_size = _bcpu_ram_end - _bcpu_ram_start;
    _bcpu_ram_flash_end_location = _bcpu_ram_flash_start_location + _bcpu_ram_size;
    /*----------------------- */
    /* External RAM BSS           */
    /*----------------------- */
    _bcpu_ram_bss_start = .;
    /* Go Uncached */
    . += 0x20000000;
    .bcpu_ucbss . (NOLOAD) : AT (ADDR(.bcpu_ucbss))
    {
        *(.ucbss)
        . = ALIGN(0x10);
    }
    /* Go Cached */
    . -= 0x20000000;
    .bcpu_bss . (NOLOAD) : AT (ADDR(.bcpu_bss))
    {
        *(.bss .bss.* .sbss .sbss.*)
        . = ALIGN(0x10);
    }
    _bcpu_ram_bss_end = .;
    _bcpu_ram_bss_size = _bcpu_ram_bss_end - _bcpu_ram_bss_start;
    /* Check that the External RAM is not over stuffed */
    ASSERT(ABSOLUTE(0xFFFFFFFF82000000 + 0x00400000) > ABSOLUTE(_bcpu_ram_bss_end), "BCPU External RAM overflow !")
    /*---------------- */
    /* End of External RAM */
    /*---------------- */
    /*========================================================= */
    /* Back in FLASH                                                 */
    /*========================================================= */
    . = _bcpu_ram_flash_end_location;
    /* WORKAROUND:
     * Keep the following section as the last section to remove the LD warning,
     * "access beyond end of merged section", when linking XCPU image. This warning might
     * be ejected due to introducing some BCPU LD symbols defined above to the XCPU image.
     */
    .bcpu_flash_end . : AT(ADDR(.bcpu_flash_end))
    {
        LONG(0)
        . = ALIGN(0x10);
    }
    _bcpu_flash_end = .;
    /* This is a rough check. XCPU image linking process will check flash/ram usage in detail. */
    ASSERT(ABSOLUTE(0xFFFFFFFF88000000 + 0x400000) > ABSOLUTE(_bcpu_flash_end), "BCPU Flash overflow: there is no more space available in flash memory.")
/* All sections we want to discard from the final linked elf.*/
    /*
     * DWARF debug sections.
     * Symbols in the DWARF debugging sections are relative to
     * the beginning of the section so we begin them at 0.
     */
    /* DWARF 1 */
    .debug (0) : { *(EXCLUDE_FILE(*.elf) .debug ) }
    .line (0) : { *(EXCLUDE_FILE(*.elf) .line ) }
    /* GNU DWARF 1 extensions */
    .debug_srcinfo (0) : { *(EXCLUDE_FILE(*.elf) .debug_srcinfo ) }
    .debug_sfnames (0) : { *(EXCLUDE_FILE(*.elf) .debug_sfnames ) }
    /* DWARF 1.1 and DWARF 2 */
    .debug_aranges (0) : { *(EXCLUDE_FILE(*.elf) .debug_aranges ) }
    .debug_pubnames (0) : { *(EXCLUDE_FILE(*.elf) .debug_pubnames ) }
    /* DWARF 2 */
    .debug_info (0) : { *(EXCLUDE_FILE(*.elf) .debug_info .gnu.linkonce.wi.* ) }
    .debug_abbrev (0) : { *(EXCLUDE_FILE(*.elf) .debug_abbrev ) }
    .debug_line (0) : { *(EXCLUDE_FILE(*.elf) .debug_line ) }
    .debug_frame (0) : { *(EXCLUDE_FILE(*.elf) .debug_frame ) }
    .debug_str (0) : { *(EXCLUDE_FILE(*.elf) .debug_str ) }
    .debug_loc (0) : { *(EXCLUDE_FILE(*.elf) .debug_loc ) }
    .debug_macinfo (0) : { *(EXCLUDE_FILE(*.elf) .debug_macinfo ) }
    /* SGI/MIPS DWARF 2 extensions */
    .debug_weaknames (0) : { *(EXCLUDE_FILE(*.elf) .debug_weaknames ) }
    .debug_funcnames (0) : { *(EXCLUDE_FILE(*.elf) .debug_funcnames ) }
    .debug_typenames (0) : { *(EXCLUDE_FILE(*.elf) .debug_typenames ) }
    .debug_varnames (0) : { *(EXCLUDE_FILE(*.elf) .debug_varnames ) }
    /* Stabs debugging sections.  */
    .stab (0) : { *(EXCLUDE_FILE(*.elf) .stab ) }
    .stabstr (0) : { *(EXCLUDE_FILE(*.elf) .stabstr ) }
    .stab.excl (0) : { *(EXCLUDE_FILE(*.elf) .stab.excl ) }
    .stab.exclstr (0) : { *(EXCLUDE_FILE(*.elf) .stab.exclstr ) }
    .stab.index (0) : { *(EXCLUDE_FILE(*.elf) .stab.index ) }
    .stab.indexstr (0) : { *(EXCLUDE_FILE(*.elf) .stab.indexstr ) }
    .comment (0) : { *(EXCLUDE_FILE(*.elf) .comment ) }
    /* These must appear regardless of  .  */
    .gptab.sdata :
    {
        *(.gptab.data)
        *(.gptab.sdata)
    }
    .gptab.sbss :
    {
        *(.gptab.bss)
        *(.gptab.sbss)
    }
    /DISCARD/ :
    {
        /* Error if a required input section is not listed in any output section */
        /* Useful to check the missing section descriptions */
        *(*)
    }
}
