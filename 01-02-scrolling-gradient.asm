    include "lib/2K.asm"
    include "lib/scanlines.asm"

    ; Variables
    seg.u RAM
StartingColor: byte


    ; Program
    seg ROM
Start:
INITIAL_STARTING_COLOR = $0a
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

    ; Draw Visible Picture
    ldx #PICTURE_LINE_COUNT
VisibleLineLoop:
    sty COLUBK
    sty WSYNC
    dey
    dey
    dex
    bne VisibleLineLoop
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
