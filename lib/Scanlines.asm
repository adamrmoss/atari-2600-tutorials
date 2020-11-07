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
