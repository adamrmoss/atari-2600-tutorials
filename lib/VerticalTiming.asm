; ╔══════════════════════════════════════════════════════════════════════════╗
; ║ VERTICAL_SYNC                                                            ║
; ╠══════════════════════════════════════════════════════════════════════════╣
; ║ Inserts the code required for a proper 3 scanline vertical sync sequence ║
; ╚══════════════════════════════════════════════════════════════════════════╝
    mac VERTICAL_SYNC
        ; Enable Vertical Sync
        lda #$02
        sta VSYNC

        sta WSYNC
        sta WSYNC

        ; Disable Vertical Sync
        lda #$00
        sta VSYNC

        sta WSYNC
    endm
