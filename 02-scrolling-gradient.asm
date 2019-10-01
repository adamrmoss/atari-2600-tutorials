    processor 6502

    include "lib/Macros.asm"
    include "lib/TIA.asm"
    include "lib/RIOT.asm"

    ; Scanline count constants
VBLANK_LINE_COUNT   =  37
PICTURE_LINE_COUNT  = 192
OVERSCAN_LINE_COUNT =  30
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

StartFrame:
    ; Decrement StartingColor
    ldy StartingColor
    dey
    dey
    sty StartingColor

    ; Enable VBLANK
    lda #$02
    sta VBLANK

    ; Output VBlank
    ldx #VBLANK_LINE_COUNT
VBlankLoop:
    sta WSYNC
    dex
    bne VBlankLoop

    ; Turn off VBLANK
    lda #$00
    sta VBLANK

    ; Draw Visible Picture
    ldx #PICTURE_LINE_COUNT
    ldy StartingColor
LineLoop:
    sty COLUBK
    sty WSYNC
    dey
    dey
    dex
    bne LineLoop
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

    ; Turn off VBLANK
    lda #$00
    sta VBLANK

    ; Turn on VSYNC
    lda #$02
    sta VSYNC

    ; VSYNC lines
    repeat VSYNC_LINE_COUNT
        sta WSYNC
    repend

    ; Turn off VSYNC
    lda #$00
    sta VSYNC

    ; Start over for the next Frame
    jmp StartFrame

    ; Fill remaining cartridge space
    org $fffc
    ; Reset Vector
    word Start
    ; IRQ Vector
    word Start
