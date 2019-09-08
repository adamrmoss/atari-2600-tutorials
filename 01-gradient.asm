    processor 6502

    ; Stella Chip Addresses
VSYNC  = $00
VBLANK = $01
WSYNC  = $02
COLUBK = $09

    ; Scanline count constants
TOTAL_LINE_COUNT    = 262
VBLANK_LINE_COUNT   =  37
PICTURE_LINE_COUNT  = 210
OVERSCAN_LINE_COUNT =  12
VSYNC_LINE_COUNT    =   3

    org $f800

Start:
    ; Enable VBLANK
    lda #$02
    sta VBLANK

    repeat VBLANK_LINE_COUNT
        sta WSYNC
    repend

    ; Turn off VBLANK
    lda #$00
    sta VBLANK

    ; Draw Visible Picture, using compile-time constant
BACKGROUND_COLOR set 0
    repeat PICTURE_LINE_COUNT
BACKGROUND_COLOR set BACKGROUND_COLOR - 2
        lda #BACKGROUND_COLOR
        sta COLUBK
        sta WSYNC
    repend

    ; Enable VBLANK
    lda #$02
    sta VBLANK

    ; Overscan lines
    repeat OVERSCAN_LINE_COUNT
        sta WSYNC
    repend

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
    jmp Start

    org $fffc
    ; Reset Vector
    word Start
    ; IRQ Vector
    word Start
