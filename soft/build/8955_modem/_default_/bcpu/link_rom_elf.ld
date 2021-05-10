.bcpu_rom_text (0xffffffffa1e80000)  : AT (0xffffffff81e80000) { KEEP(*bcpu_rom_CHIP.elf(.bcpu_rom_text)) }
.bcpu_rom_rodata (0xffffffff81e937b0)  : AT (0xffffffff81e937b0) { KEEP(*bcpu_rom_CHIP.elf(.bcpu_rom_rodata)) }
.bbsram (0xffffffff81980000) (NOLOAD) : AT (0xffffffff81980000) { KEEP(*bcpu_rom_CHIP.elf(.bbsram)) }
.bbsramu (0xffffffffa1981e00) (NOLOAD) : AT (0xffffffffa1981e00) { KEEP(*bcpu_rom_CHIP.elf(.bbsramu)) }
.bbsram_globals (0xffffffff81986640) (NOLOAD) : AT (0xffffffff81986640) { KEEP(*bcpu_rom_CHIP.elf(.bbsram_globals)) }
.mailbox (0xffffffffa1b00580) (NOLOAD) : AT (0xffffffffa1b00580) { KEEP(*bcpu_rom_CHIP.elf(.mailbox)) }
.bcpu_rom_version_number (0xffffffff81e97ff8)  : AT (0xffffffff81e97ff8) { KEEP(*bcpu_rom_CHIP.elf(.bcpu_rom_version_number)) }
.bcpu_rom.crc (0xffffffff81e97ffc)  : AT (0xffffffff81e97ffc) { KEEP(*bcpu_rom_CHIP.elf(.bcpu_rom.crc)) }
