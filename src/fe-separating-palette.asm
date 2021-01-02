    include "lib/2K.asm"

; ╔══════════════════════════════════════════════════════════════════════════╗
; ║ Variables                                                                ║
; ╚══════════════════════════════════════════════════════════════════════════╝
    seg.u RAM
ColorPhase: .byte

; ╔══════════════════════════════════════════════════════════════════════════╗
; ║ Constants                                                                ║
; ╚══════════════════════════════════════════════════════════════════════════╝
INITIAL_STARTING_COLOR = $0a

; ╔══════════════════════════════════════════════════════════════════════════╗
; ║ Program                                                                  ║
; ╚══════════════════════════════════════════════════════════════════════════╝
    seg ROM
Start:
    CLEAN_START

    lda #INITIAL_STARTING_COLOR
    sta ColorPhase
    sta COLUBK

StartFrame:
    START_VBLANK

    ; Increment ColorPhase twice
    inc ColorPhase
    inc ColorPhase

    FINISH_VBLANK

    ldy ColorPhase

    ; Draw Top Half of Visible Picture
    ldx #PICTURE_LINE_COUNT / 2
TopLineLoop:
    sty COLUBK
    sty WSYNC
    iny
    iny
    dex
    bne TopLineLoop

    ; Draw Bottom Half of Visible Picture
    ldx #PICTURE_LINE_COUNT / 2
BottomLineLoop:
    sty COLUBK
    sty WSYNC
    dey
    dey
    dex
    bne BottomLineLoop
    
    START_OVERSCAN

    FINISH_OVERSCAN

    VERTICAL_SYNC

    ; Start over for the next Frame
    jmp StartFrame

    ; Fill remaining cartridge space
    FILL_CARTRIDGE Start
