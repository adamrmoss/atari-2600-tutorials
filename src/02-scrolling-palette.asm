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
    ; Clear Memory
    lda #0
    ldx #$ff
ClearMemoryLoop:
    sta 0,x
    dex
    bne ClearMemoryLoop
    sta 0

    ; Initialize Color
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

    ; Draw Visible Picture
    ldx #PICTURE_LINE_COUNT
VisibleLineLoop:
    sty COLUBK
    sty WSYNC
    dey
    dey
    dex
    bne VisibleLineLoop

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
    FILL_CARTRIDGE Start
