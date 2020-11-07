    ifnconst TOTAL_LINE_COUNT
TOTAL_LINE_COUNT = 262
    endif

    ifnconst VSYNC_LINE_COUNT
VSYNC_LINE_COUNT = 3
    endif

    ifnconst VBLANK_LINE_COUNT
VBLANK_LINE_COUNT = 37
    endif

    ifnconst PICTURE_LINE_COUNT
PICTURE_LINE_COUNT = 192
    endif

    ifnconst OVERSCAN_LINE_COUNT
OVERSCAN_LINE_COUNT = TOTAL_LINE_COUNT - VSYNC_LINE_COUNT - VBLANK_LINE_COUNT - PICTURE_LINE_COUNT
    endif

ACTUAL_LINE_COUNT = VSYNC_LINE_COUNT + VBLANK_LINE_COUNT + PICTURE_LINE_COUNT + OVERSCAN_LINE_COUNT

    LOG2 "TOTAL_LINE_COUNT    =", [TOTAL_LINE_COUNT]d
    LOG2 "VSYNC_LINE_COUNT    =", [VSYNC_LINE_COUNT]d
    LOG2 "VBLANK_LINE_COUNT   =", [VBLANK_LINE_COUNT]d
    LOG2 "PICTURE_LINE_COUNT  =", [PICTURE_LINE_COUNT]d
    LOG2 "OVERSCAN_LINE_COUNT =", [OVERSCAN_LINE_COUNT]d
    LOG2 "ACTUAL_LINE_COUNT   =", [ACTUAL_LINE_COUNT]d
    LOG_CR

    if TOTAL_LINE_COUNT != ACTUAL_LINE_COUNT
        THROW2 "Error: ACTUAL_LINE_COUNT !=", TOTAL_LINE_COUNT
    endif

VBLANK_64T_COUNT     = (VBLANK_LINE_COUNT   * 76 / 64)
OVERSCAN_64T_COUNT   = (OVERSCAN_LINE_COUNT * 76 / 64)

VBLANK_WSYNC_COUNT   = ((VBLANK_LINE_COUNT   * 76) - (VBLANK_64T_COUNT   * 64) + 76 - 14) / 76
OVERSCAN_WSYNC_COUNT = ((OVERSCAN_LINE_COUNT * 76) - (OVERSCAN_64T_COUNT * 64) + 76 - 14) / 76

    LOG2 "VBLANK_64T_COUNT     =", [VBLANK_64T_COUNT]d
    LOG2 "VBLANK_WSYNC_COUNT   =", [VBLANK_WSYNC_COUNT]d
    LOG2 "OVERSCAN_64T_COUNT   =", [OVERSCAN_64T_COUNT]d
    LOG2 "OVERSCAN_WSYNC_COUNT =", [OVERSCAN_WSYNC_COUNT]d

;╔═══════════════════════════════════════════════════════════╗
;║ START_VBLANK                                              ║
;╠═══════════════════════════════════════════════════════════╣
;║ Enable VBlank and Initialize Timer                        ║
;╚═══════════════════════════════════════════════════════════╝
    mac START_VBLANK
        ; Initialize Timer
        lda #VBLANK_64T_COUNT
        sta TIM64T

        ; Enable VBLANK
        lda #$02
        sta VBLANK
    endm

;╔═══════════════════════════════════════════════════════════╗
;║ FINISH_VBLANK                                             ║
;╠═══════════════════════════════════════════════════════════╣
;║ Wait for VBlank timer to end then turn off                ║
;╚═══════════════════════════════════════════════════════════╝
    mac FINISH_VBLANK
.FinishingVBlank:
        lda INTIM
        bne .FinishingVBlank

        ; Unroll Scanlines of VBlank
        repeat VBLANK_WSYNC_COUNT
            sta WSYNC
        repend

        ; Turn off VBLANK
        lda #$00
        sta VBLANK
    endm

;╔═══════════════════════════════════════════════════════════╗
;║ START_OVERSCAN                                            ║
;╠═══════════════════════════════════════════════════════════╣
;║ Start Overscan timer, then turn on VBlank                 ║
;╚═══════════════════════════════════════════════════════════╝
    mac START_OVERSCAN
        ; Start Overscan Timer
        lda #OVERSCAN_64T_COUNT
        sta TIM64T

        ; Enable VBLANK
        lda #$02
        sta VBLANK
    endm

;╔═══════════════════════════════════════════════════════════╗
;║ FINISH_OVERSCAN                                           ║
;╠═══════════════════════════════════════════════════════════╣
;║ Wait for Overscan timer to end                            ║
;╚═══════════════════════════════════════════════════════════╝
    mac FINISH_OVERSCAN
.FinishingOverscan:
        lda INTIM
        bne .FinishingOverscan

        ; Unroll Scanlines of Overscan
        repeat OVERSCAN_WSYNC_COUNT
            sta WSYNC
        repend
    endm

;╔══════════════════════════════════════════════════════════════════════════╗
;║ VERTICAL_SYNC                                                            ║
;╠══════════════════════════════════════════════════════════════════════════╣
;║ Original author: Manuel Polik                                            ║
;╠══════════════════════════════════════════════════════════════════════════╣
;║ Inserts the code required for a proper 3 scanline                        ║
;║ vertical sync sequence                                                   ║
;╠══════════════════════════════════════════════════════════════════════════╣
;║ OUT: A = 1                                                               ║
;╚══════════════════════════════════════════════════════════════════════════╝
    mac VERTICAL_SYNC
        lda #$02            ; A = VSYNC enable
        sta WSYNC           ; Finish current line
        sta VSYNC           ; Start vertical sync
        sta WSYNC           ; 1st line vertical sync
        sta WSYNC           ; 2nd line vertical sync
        lsr                 ; A = VSYNC disable
        sta WSYNC           ; 3rd line vertical sync
        sta VSYNC           ; Stop vertical sync
    endm
