    processor 6502

    include "lib/TIA.asm"
    include "lib/RIOT.asm"
    include "lib/RAM.asm"
    include "lib/Console.asm"
    include "lib/Macros.asm"
    include "lib/Scanlines.asm"
    include "lib/VerticalTiming.asm"

; ╔══════════════════════════════════════════════════════════════════════════╗
; ║ FILL_CARTRIDGE                                                           ║
; ╠══════════════════════════════════════════════════════════════════════════╣
; ║ Fills out the remaining cartridge space and includes Vector table        ║
; ╚══════════════════════════════════════════════════════════════════════════╝
    mac FILL_CARTRIDGE
.Start set {1}
        ; Fill remaining cartridge space
        org $fffc
        ; Reset Vector
        .word .Start
        ; IRQ Vector
        .word .Start
    endm
