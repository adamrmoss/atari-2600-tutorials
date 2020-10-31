    processor 6502

    ; Stella Chip Addresses
VSYNC  = $00
VBLANK = $01
WSYNC  = $02
COLUBK = $09

    ; Scanline count constants
VBLANK_LINE_COUNT   =   9
PICTURE_LINE_COUNT  = 240
OVERSCAN_LINE_COUNT =  10
VSYNC_LINE_COUNT    =   3

    org $f800

Start:
    ; Clear Memory
    lda #$0
RAM_LOCATION set 0
    repeat 255
        sta RAM_LOCATION
RAM_LOCATION set RAM_LOCATION + 1
    repend

StartFrame:
    ; Enable VBLANK
    lda #$02
    sta VBLANK

    repeat VBLANK_LINE_COUNT
        sta WSYNC
    repend

    ; Turn off VBLANK
    ldx #$00
    stx VBLANK

    ; Draw Visible Picture
BACKGROUND_COLOR set 0
    repeat PICTURE_LINE_COUNT
BACKGROUND_COLOR set (BACKGROUND_COLOR - 2) % 256
        ldy #BACKGROUND_COLOR
        sty COLUBK
        sty WSYNC
    repend

    ; Enable VBLANK
    lda #$02
    sta VBLANK

    ; Overscan lines
    repeat OVERSCAN_LINE_COUNT
        sta WSYNC
    repend

    ; Turn off VBLANK
    ldx #$00
    stx VBLANK

    ; Turn on VSYNC
    ldy #$02
    sty VSYNC

    ; VSYNC lines
    repeat VSYNC_LINE_COUNT
        sty WSYNC
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
