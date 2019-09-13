    processor 6502

    ; Stella Chip Addresses
VSYNC  = $00
VBLANK = $01
WSYNC  = $02
COLUBK = $09

AUDC0  = $15
AUDC1  = $16
AUDF0  = $17
AUDF1  = $18
AUDV0  = $19
AUDV1  = $1a

    ; Scanline count constants
VBLANK_LINE_COUNT   =  37
PICTURE_LINE_COUNT  = 192
OVERSCAN_LINE_COUNT =  30
VSYNC_LINE_COUNT    =   3
TOTAL_LINE_COUNT    = 262
ACTUAL_LINE_COUNT   = VBLANK_LINE_COUNT + PICTURE_LINE_COUNT + OVERSCAN_LINE_COUNT + VSYNC_LINE_COUNT

    if TOTAL_LINE_COUNT != ACTUAL_LINE_COUNT
        echo "Error: ACTUAL_LINE_COUNT is ", [ACTUAL_LINE_COUNT]d, "; should be ", [TOTAL_LINE_COUNT]d
        err
    endif

    org $f800

Start:
    ; Both voices sing square waves
    lda $04
    sta AUDC0
    sta AUDC1

    ; Loud bass note on sharp side of C-5
    lda #$1f
    sta AUDF0
    lda $08
    sta AUDV0

    ; Quieter note on sharp side of G-5
    lda #$13
    sta AUDF1
    lda $04
    sta AUDV1

StartFrame:
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
    jmp StartFrame

    org $fffc
    ; Reset Vector
    word Start
    ; IRQ Vector
    word Start
