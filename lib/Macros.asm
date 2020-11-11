;╔══════════════════════════════════════════════════════════════════════════╗
;║ SLEEP duration (n > 1)                                                   ║
;╠══════════════════════════════════════════════════════════════════════════╣
;║ Original author: Thomas Jentzsch                                         ║
;╠══════════════════════════════════════════════════════════════════════════╣
;║ Inserts code which takes the specified number of cycles to execute.      ║
;║ This is useful for code where precise timing is required.                ║
;║ Uses illegal opcode (DASM 2.20.01 onwards).                              ║
;╚══════════════════════════════════════════════════════════════════════════╝
    mac SLEEP
.RemainingCycles set {1}
        if .RemainingCycles < 2
            THROW "Error: SLEEP Duration must be > 1"
        endif

        if .RemainingCycles & 1
            nop 0
.RemainingCycles set .RemainingCycles - 3
        endif

        repeat .RemainingCycles / 2
            nop
        repend
    endm

;╔══════════════════════════════════════════════════════════════════════════╗
;║ CLEAN_START                                                              ║
;╠══════════════════════════════════════════════════════════════════════════╣
;║ Original author: Andrew Davie                                            ║
;╠══════════════════════════════════════════════════════════════════════════╣
;║ Standardised start-up code, clears stack, all TIA registers and RAM to 0 ║
;║ Sets stack pointer to $ff, and all registers to 0                        ║
;║ Sets decimal mode off, sets interrupt flag (kind of un-necessary)        ║
;║ Use as very first section of code on boot (ie: at reset)                 ║
;║ Code written to minimise total ROM usage - uses weird 6502 knowledge :)  ║
;╚══════════════════════════════════════════════════════════════════════════╝
    mac CLEAN_START
        sei
        cld
        ldx #0
        txa
        tay
.ClearingStack:
        dex
        txs
        pha
        bne .ClearingStack
    endm

;╔══════════════════════════════════════════════════════════════════════════╗
;║ SET_BYTE address, value                                                  ║
;╠══════════════════════════════════════════════════════════════════════════╣
;║ OUT: A = .Address = #<.Value                                             ║
;╚══════════════════════════════════════════════════════════════════════════╝
    mac SET_BYTE
.Address = [{1}]
.Value   = [{2}]
        lda #<.Value
        sta .Address
    endm

;╔══════════════════════════════════════════════════════════════════════════╗
;║ SET_WORD address, value                                                  ║
;╠══════════════════════════════════════════════════════════════════════════╣
;║ OUT: A = .Address + 1 = #>.Value                                         ║
;║          .Address     = #<.Value                                         ║
;╚══════════════════════════════════════════════════════════════════════════╝
    mac SET_WORD
.Address = [{1}]
.Value   = [{2}]
        lda #<.Value
        sta .Address
        lda #>.Value
        sta .Address + 1
    endm
