    processor 6502

    ; Stella Chip Addresses
VSYNC  = $00
VBLANK = $01
WSYNC  = $02
COLUBK = $09

TOTAL_LINE_COUNT    = 262
VBLANK_LINE_COUNT   =  37
PICTURE_LINE_COUNT  = 210
OVERSCAN_LINE_COUNT =  12
VSYNC_LINE_COUNT    =   3
ACTUAL_LINE_COUNT   = VBLANK_LINE_COUNT + PICTURE_LINE_COUNT + OVERSCAN_LINE_COUNT + VSYNC_LINE_COUNT

    echo "TOTAL_LINE_COUNT    =", [TOTAL_LINE_COUNT]d
    echo "VBLANK_LINE_COUNT   =", [VBLANK_LINE_COUNT]d
    echo "PICTURE_LINE_COUNT  =", [PICTURE_LINE_COUNT]d
    echo "OVERSCAN_LINE_COUNT =", [OVERSCAN_LINE_COUNT]d
    echo "VSYNC_LINE_COUNT    =", [VSYNC_LINE_COUNT]d
    echo "ACTUAL_LINE_COUNT   =", [ACTUAL_LINE_COUNT]d

    if TOTAL_LINE_COUNT != ACTUAL_LINE_COUNT
        echo "Error: ACTUAL_LINE_COUNT !=", TOTAL_LINE_COUNT
        err
    endif

BACKGROUND_COLOR = $0a

    org $f800

Start:
    ; Set Background Color
    lda #BACKGROUND_COLOR
    sta COLUBK
DrawFrame:
    ; Enable VBLANK
    lda #$02
    sta VBLANK

    ; X register will count VBlank lines
    ldx #VBLANK_LINE_COUNT
VBlankLoop:
    sta WSYNC
    dex
    bne VBlankLoop

    ; Turn off VBLANK
    lda #$00
    sta VBLANK

    ; Draw Visible Picture, storing the current color in Y
    ldx #PICTURE_LINE_COUNT
    ldy #$fe
PictureLoop:
    sty COLUBK
    sty WSYNC
    dey
    dey
    dex
    bne PictureLoop

    ; Set Background Color
    lda #BACKGROUND_COLOR
    sta COLUBK

    ; Enable VBLANK
    lda #$02
    sta VBLANK

    ; X register will count Overscan lines
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

    ; Unroll Scanlines of VSYNC
    repeat VSYNC_LINE_COUNT
        sta WSYNC
    repend

    ; Turn off VSYNC
    lda #$00
    sta VSYNC

    ; Start over for the next Frame
    jmp DrawFrame

    org $fffc
    ; Reset Vector
    word Start
    ; IRQ Vector
    word Start
