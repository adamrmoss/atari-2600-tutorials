    processor 6502

    include "lib/TIA.asm"
    include "lib/RIOT.asm"
    include "lib/RAM.asm"
    include "lib/Console.asm"
    include "lib/Macros.asm"

    seg ROM
    org $f000
