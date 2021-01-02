; ╔══════════════════════════════════════════════════════════════════════════╗
; ║ VERTICAL_SYNC                                                            ║
; ╠══════════════════════════════════════════════════════════════════════════╣
; ║ Inserts the code required for a proper 3 scanline vertical sync sequence ║
; ╠══════════════════════════════════════════════════════════════════════════╣
; ║ OUT: A = 1                                                               ║
; ╚══════════════════════════════════════════════════════════════════════════╝
    mac VERTICAL_SYNC
        ; Enable Vertical Sync
        lda #$02
        sta VSYNC

        sta WSYNC
        sta WSYNC

        ; Disable Vertical Sync
        lsr
        sta VSYNC

        sta WSYNC
    endm
