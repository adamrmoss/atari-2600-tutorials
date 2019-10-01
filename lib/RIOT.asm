; ╔═════════════════════════════════════════════════════════════════════════╗
; ║ RIOT MEMORY MAP                                                         ║
; ╚══════════════╦══════════════════════════════════════════════════════════╣
    seg.u RIOT ; ║ Segment for RIOT chip                                    ║
    org $280   ; ╠══════╦═══════════════════════════════════════════════════╣
SWCHA  byte    ; ║ $280 ║ Port A data register for joysticks:               ║
               ; ║      ║ Bits 4-7 for player 1.  Bits 0-3 for player 2.    ║
               ; ╠══════╬═══════════════════════════════════════════════════╣
SWACNT byte    ; ║ $281 ║ Port A data direction register (DDR)              ║
SWCHB  byte    ; ║ $282 ║ Port B data (console switches)                    ║
SWBCNT byte    ; ║ $283 ║ Port B DDR                                        ║
               ; ╠══════╬═══════════════════════════════════════════════════╣
INTIM  byte    ; ║ $284 ║ Timer output                                      ║
TIMINT byte    ; ║ $285 ║ Timer interrupt                                   ║
               ; ╠══════╬═══════════════════════════════════════════════════╣
       byte    ; ║ $286 ║ Unused                                            ║
       byte    ; ║ $287 ║ Unused                                            ║
       byte    ; ║ $288 ║ Unused                                            ║
       byte    ; ║ $289 ║ Unused                                            ║
       byte    ; ║ $28a ║ Unused                                            ║
       byte    ; ║ $28b ║ Unused                                            ║
       byte    ; ║ $28c ║ Unused                                            ║
       byte    ; ║ $28d ║ Unused                                            ║
       byte    ; ║ $28e ║ Unused                                            ║
       byte    ; ║ $28f ║ Unused                                            ║
       byte    ; ║ $290 ║ Unused                                            ║
       byte    ; ║ $291 ║ Unused                                            ║
       byte    ; ║ $292 ║ Unused                                            ║
       byte    ; ║ $293 ║ Unused                                            ║
               ; ╠══════╬═══════════════════════════════════════════════════╣
TIM1T  byte    ; ║ $294 ║ Set 1-clock interval                              ║
TIM8T  byte    ; ║ $295 ║ Set 8-clock interval                              ║
TIM64T byte    ; ║ $296 ║ Set 64-clock interval                             ║
T1024T byte    ; ║ $297 ║ Set 1024-clock interval                           ║
               ; ╚══════╩═══════════════════════════════════════════════════╝
