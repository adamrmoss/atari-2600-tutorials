    ; Scanline count constants
VBLANK_LINE_COUNT   =  27
PICTURE_LINE_COUNT  = 208
OVERSCAN_LINE_COUNT =  24

    include "lib/2K.asm"

    ; Variables
    seg.u RAM
ColorPhase: byte

    ; Constants
INITIAL_STARTING_COLOR = $0a

    ; Program
    seg ROM
Start:
    CLEAN_START

    lda #INITIAL_STARTING_COLOR
    sta ColorPhase
    sta COLUBK

    ; Enable VBLANK
    lda #$02
    sta VBLANK

StartFrame:
    ; Increment ColorPhase twice
    inc ColorPhase
    inc ColorPhase

    ; Output VBlank
    ldx #VBLANK_LINE_COUNT
VBlankLoop:
    sta WSYNC
    dex
    bne VBlankLoop

    ; Turn off VBLANK
    lda #$00
    sta VBLANK

    ldy ColorPhase

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
