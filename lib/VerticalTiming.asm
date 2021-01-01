;╔═══════════════════════════════════════════════════════════╗
;║ TIMER_SETUP scanlines                                     ║
;╠═══════════════════════════════════════════════════════════╣
;║ Setup TIM64 to wait for a number of scanlines (> 2).      ║
;║ The timer will be set so that it expires before this      ║
;║ number of scanlines. A WSYNC will be done first.          ║
;╚═══════════════════════════════════════════════════════════╝
    mac TIMER_SETUP
.ScanLines set {1}
        lda #(((.ScanLines - 1) * 76 - 14) / 64) + 1
        sta WSYNC
        sta TIM64T
    endm

;╔═══════════════════════════════════════════════════════════╗
;║ TIMER_WAIT                                                ║
;╠═══════════════════════════════════════════════════════════╣
;║ Use with TIMER_SETUP to wait for timer to complete.       ║
;║ You may want to do a WSYNC afterwards, since the timer    ║
;║ is not accurate to the beginning/end of a scanline.       ║
;╚═══════════════════════════════════════════════════════════╝
    mac TIMER_WAIT
.WaitTimer
        lda INTIM
        bne .WaitTimer
        sta WSYNC
    endm

;╔═══════════════════════════════════════════════════════════╗
;║ START_VBLANK                                              ║
;╠═══════════════════════════════════════════════════════════╣
;║ Enable VBlank and Initialize Timer                        ║
;╚═══════════════════════════════════════════════════════════╝
    mac START_VBLANK
        TIMER_SETUP VBLANK_LINE_COUNT

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
        TIMER_WAIT

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
        TIMER_SETUP OVERSCAN_LINE_COUNT

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
        TIMER_WAIT

        ; Turn off VBLANK
        lda #$00
        sta VBLANK
    endm

;╔══════════════════════════════════════════════════════════════════════════╗
;║ VERTICAL_SYNC                                                            ║
;╠══════════════════════════════════════════════════════════════════════════╣
;║ Inserts the code required for a proper 3 scanline                        ║
;║ vertical sync sequence                                                   ║
;╠══════════════════════════════════════════════════════════════════════════╣
;║ OUT: A = 1                                                               ║
;╚══════════════════════════════════════════════════════════════════════════╝
    mac VERTICAL_SYNC
        lda #$02            ; A = VSYNC enable
        sta VSYNC           ; Start vertical sync
        sta WSYNC           ; 1st line vertical sync
        sta WSYNC           ; 2nd line vertical sync
        lsr                 ; A = VSYNC disable
        sta WSYNC           ; 3rd line vertical sync
        sta VSYNC           ; Stop vertical sync
    endm
