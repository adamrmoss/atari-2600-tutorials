    ; Scanline count constants
VBLANK_LINE_COUNT   =   9
PICTURE_LINE_COUNT  = 240
OVERSCAN_LINE_COUNT =  10

    include "lib/2K.asm"

    ; Variables
    seg.u RAM
HorizonDistance: .word
DistanceDelta:   .word
BackgroundColor: .byte

    ; Constants
INITIAL_DISTANCE = 57600
DISTANCE_DELTA_2 =     8

    ; Program
    seg ROM
Start:
    CLEAN_START

StartFrame:
    START_VBLANK

    ; Initialize HorizonDistance and DistanceDelta
    SET_WORD HorizonDistance, #INITIAL_DISTANCE
    SET_WORD DistanceDelta, #0

    ; Initialize BackgroundColor
    SET_BYTE BackgroundColor, #$0f

    FINISH_VBLANK

    ; Draw Top Half of Visible Picture
    ldx #PICTURE_LINE_COUNT / 2 - 1
SkyLoop:
    ; Store pre-computed background color
    lda BackgroundColor
    sta COLUBK

    ; Increment DistanceDelta
    clc
    lda DistanceDelta
    adc #DISTANCE_DELTA_2
    sta DistanceDelta
    bcc .NoCarry
    ; If carry, increment high byte
    inc DistanceDelta + 1
.NoCarry:
    ; Increment HorizonDistance
    clc
    ; Add low bytes
    lda HorizonDistance
    adc DistanceDelta
    sta HorizonDistance
    ; Add high bytes
    lda HorizonDistance + 1
    adc DistanceDelta + 1
    sta HorizonDistance + 1

    ; Transform high byte of distance into low nybble of color
    lsr
    lsr
    lsr
    lsr
    ; Set hue of color
    ora #$f0
    sta BackgroundColor

    ; Finish line and loop
    sty WSYNC
    bne SkyLoop

    ; Draw Bottom Half of Visible Picture
    ldx #PICTURE_LINE_COUNT / 2 - 1
GroundLineLoop:
    ; Store pre-computed background color
    lda BackgroundColor
    sta COLUBK

    ; Decrement DistanceDelta
    sec
    lda DistanceDelta
    sbc #DISTANCE_DELTA_2
    sta DistanceDelta
    bcs .NoBorrow
    ; If overflow, increment high byte
    dec DistanceDelta + 1
.NoBorrow:
    ; Decrement HorizonDistance
    sec
    ; Add low bytes
    lda HorizonDistance
    sbc DistanceDelta
    sta HorizonDistance
    ; Add high bytes
    lda HorizonDistance + 1
    sbc DistanceDelta + 1
    sta HorizonDistance + 1

    ; Transform high byte of distance into low nybble of color
    lsr
    lsr
    lsr
    lsr
    ; Set hue of color
    ora #$f0
    sta BackgroundColor

    ; Finish line and loop
    sty WSYNC
    sty WSYNC

    START_OVERSCAN

    FINISH_OVERSCAN
    stx WSYNC
    
    VERTICAL_SYNC

    ; Start over for the next Frame
    jmp StartFrame

    ; Fill remaining cartridge space
    org $fffc
    ; Reset Vector
    .word Start
    ; IRQ Vector
    .word Start
