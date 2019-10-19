    processor 6502

    include "lib/Macros.asm"
    include "lib/TIA.asm"
    include "lib/RIOT.asm"

    ; Scanline count constants
VBLANK_LINE_COUNT   =  27
PICTURE_LINE_COUNT  = 208
OVERSCAN_LINE_COUNT =  24
VSYNC_LINE_COUNT    =   3
TOTAL_LINE_COUNT    = 262
ACTUAL_LINE_COUNT   = VBLANK_LINE_COUNT + PICTURE_LINE_COUNT + OVERSCAN_LINE_COUNT + VSYNC_LINE_COUNT

    if TOTAL_LINE_COUNT != ACTUAL_LINE_COUNT
        throw "Error: ACTUAL_LINE_COUNT is ", [ACTUAL_LINE_COUNT]d, "; should be ", [TOTAL_LINE_COUNT]d
        err
    endif

    seg.u RAM
    org $80
StartingColor: byte

INITIAL_STARTING_COLOR = $0a

    seg ROM
    org $f800
Start:
    CLEAN_START

    lda #INITIAL_STARTING_COLOR
    sta StartingColor
    sta COLUBK

    ; Enable VBLANK
    lda #$02
    sta VBLANK

StartFrame:
    ; Increment StartingColor
    ldy StartingColor
    iny
    iny
    sty StartingColor

    ; Output VBlank
    ldx #VBLANK_LINE_COUNT
VBlankLoop:
    sta WSYNC
    dex
    bne VBlankLoop

    ; Turn off VBLANK
    lda #$00
    sta VBLANK

    ldy StartingColor

    ; Draw Top Half of Visible Picture
    ldx #PICTURE_LINE_COUNT / 2 - 1
TopLineLoop:
    sty COLUBK
    sty WSYNC
    iny
    iny
    dex
    bne TopLineLoop

    ; Draw Bottom Half of Visible Picture
    ldx #PICTURE_LINE_COUNT / 2 - 1
BottomLineLoop:
    sty COLUBK
    sty WSYNC
    dey
    dey
    dex
    bne BottomLineLoop
    sta WSYNC

    ; Enable VBLANK
    lda #$02
    sta VBLANK

    ; Overscan lines
    ldx #OVERSCAN_LINE_COUNT
OverscanLoop:
    sta WSYNC
    dex
    bne OverscanLoop

    VERTICAL_SYNC

    ; Start over for the next Frame
    jmp StartFrame

    ; Fill remaining cartridge space
    org $fffc
    ; Reset Vector
    word Start
    ; IRQ Vector
    word Start
