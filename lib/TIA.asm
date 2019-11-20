; ╔═════════════════════════════════════════════════════════════════════════════════════╗
; ║ TIA_BASE_ADDRESS                                                                    ║
; ╠═════════════════════════════════════════════════════════════════════════════════════╣
; ║ The TIA_BASE_ADDRESS defines the base address of access to TIA registers.           ║
; ║ Normally 0, the base address should (externally, before including this file)        ║
; ╚═════════════════════════════╗ be set to $40 when creating 3F-bankswitched (and      ║
    ifnconst TIA_BASE_ADDRESS ; ║ other?) cartridges.  The reason is that this          ║
TIA_BASE_ADDRESS = 0          ; ║ bankswitching scheme treats any access to             ║
    endif                     ; ║ locations < $40 as a bankswitch.                      ║
; ╔═════════════════════════════╩═══════════════════════════════════════════════════════╣
; ║ Note: The address may be defined on the command-line using the -D switch, eg:       ║
; ║           dasm.exe code.asm -DTIA_BASE_ADDRESS=$40 -f3 -v5 -ocode.bin               ║
; ║       *OR* by declaring the label before including this file, eg:                   ║
; ║           TIA_BASE_ADDRESS = $40                                                    ║
; ║           include "TIA.asm"                                                         ║
; ╠═════════════════════════════════════════════════════════════════════════════════════╣
; ║ Alternate read/write address capability - allows for some disassembly compatibility ║
; ║ to allow reassembly to binary perfect copies).  This is essentially catering for    ║
; ║ the mirrored ROM hardware registers.                                                ║
; ╚═════════════════════════════════════════╦═══════════════════════════════════════════╣
    ifnconst TIA_BASE_READ_ADDRESS        ; ║ Usage: As per above, define the           ║
TIA_BASE_READ_ADDRESS = TIA_BASE_ADDRESS  ; ║        TIA_BASE_READ_ADDRESS and/or       ║
    endif                                 ; ║        TIA_BASE_WRITE_ADDRESS using the   ║
                                          ; ║        -D command-line switch, as         ║
    ifnconst TIA_BASE_WRITE_ADDRESS       ; ║        required.  If the addresses are    ║
TIA_BASE_WRITE_ADDRESS = TIA_BASE_ADDRESS ; ║        not defined, they default to the   ║
    endif                                 ; ║        TIA_BASE_ADDRESS.                  ║
                                          ; ╚═══════════════════════════════════════════╝

; ╔═════════════════════════════════════════════════════════════════════════════════════╗
; ║ TIA MEMORY MAP                                                                      ║
; ╚═══════════════════════════════╦═════════════════════════════════════════════════════╣
    seg.u TIA_REGISTERS_WRITE   ; ║ Segment for TIA Writes, shares address space with   ║
    rorg TIA_BASE_WRITE_ADDRESS ; ║ the segment for TIA Reads.                          ║
                    ; ╔═════╦═════╩═════╦═══════════════════════════════════════════════╣
VSYNC       byte    ; ║ $00 ║ 0000 00x0 ║ Vertical Sync Set-Clear                       ║
VBLANK      byte    ; ║ $01 ║ xx00 00x0 ║ Vertical Blank Set-Clear                      ║
WSYNC       byte    ; ║ $02 ║ ---- ---- ║ Wait for Horizontal Blank                     ║
RSYNC       byte    ; ║ $03 ║ ---- ---- ║ Reset Horizontal Sync Counter                 ║
NUSIZ0      byte    ; ║ $04 ║ 00xx 0xxx ║ Number-Size player/missle 0                   ║
NUSIZ1      byte    ; ║ $05 ║ 00xx 0xxx ║ Number-Size player/missle 1                   ║
COLUP0      byte    ; ║ $06 ║ xxxx xxx0 ║ Color-Luminance Player 0                      ║
COLUP1      byte    ; ║ $07 ║ xxxx xxx0 ║ Color-Luminance Player 1                      ║
COLUPF      byte    ; ║ $08 ║ xxxx xxx0 ║ Color-Luminance Playfield                     ║
COLUBK      byte    ; ║ $09 ║ xxxx xxx0 ║ Color-Luminance Background                    ║
CTRLPF      byte    ; ║ $0a ║ 00xx 0xxx ║ Control Playfield, Ball, Collisions           ║
REFP0       byte    ; ║ $0b ║ 0000 x000 ║ Reflection Player 0                           ║
REFP1       byte    ; ║ $0c ║ 0000 x000 ║ Reflection Player 1                           ║
PF0         byte    ; ║ $0d ║ xxxx 0000 ║ Playfield Register Byte 0                     ║
PF1         byte    ; ║ $0e ║ xxxx xxxx ║ Playfield Register Byte 1                     ║
PF2         byte    ; ║ $0f ║ xxxx xxxx ║ Playfield Register Byte 2                     ║
RESP0       byte    ; ║ $10 ║ ---- ---- ║ Reset Player 0                                ║
RESP1       byte    ; ║ $11 ║ ---- ---- ║ Reset Player 1                                ║
RESM0       byte    ; ║ $12 ║ ---- ---- ║ Reset Missle 0                                ║
RESM1       byte    ; ║ $13 ║ ---- ---- ║ Reset Missle 1                                ║
RESBL       byte    ; ║ $14 ║ ---- ---- ║ Reset Ball                                    ║
AUDC0       byte    ; ║ $15 ║ 0000 xxxx ║ Audio Control 0                               ║
AUDC1       byte    ; ║ $16 ║ 0000 xxxx ║ Audio Control 1                               ║
AUDF0       byte    ; ║ $17 ║ 000x xxxx ║ Audio Frequency 0                             ║
AUDF1       byte    ; ║ $18 ║ 000x xxxx ║ Audio Frequency 1                             ║
AUDV0       byte    ; ║ $19 ║ 0000 xxxx ║ Audio Volume 0                                ║
AUDV1       byte    ; ║ $1a ║ 0000 xxxx ║ Audio Volume 1                                ║
GRP0        byte    ; ║ $1b ║ xxxx xxxx ║ Graphics Register Player 0                    ║
GRP1        byte    ; ║ $1c ║ xxxx xxxx ║ Graphics Register Player 1                    ║
ENAM0       byte    ; ║ $1d ║ 0000 00x0 ║ Graphics Enable Missle 0                      ║
ENAM1       byte    ; ║ $1e ║ 0000 00x0 ║ Graphics Enable Missle 1                      ║
ENABL       byte    ; ║ $1f ║ 0000 00x0 ║ Graphics Enable Ball                          ║
HMP0        byte    ; ║ $20 ║ xxxx 0000 ║ Horizontal Motion Player 0                    ║
HMP1        byte    ; ║ $21 ║ xxxx 0000 ║ Horizontal Motion Player 1                    ║
HMM0        byte    ; ║ $22 ║ xxxx 0000 ║ Horizontal Motion Missle 0                    ║
HMM1        byte    ; ║ $23 ║ xxxx 0000 ║ Horizontal Motion Missle 1                    ║
HMBL        byte    ; ║ $24 ║ xxxx 0000 ║ Horizontal Motion Ball                        ║
VDELP0      byte    ; ║ $25 ║ 0000 000x ║ Vertical Delay Player 0                       ║
VDELP1      byte    ; ║ $26 ║ 0000 000x ║ Vertical Delay Player 1                       ║
VDELBL      byte    ; ║ $27 ║ 0000 000x ║ Vertical Delay Ball                           ║
RESMP0      byte    ; ║ $28 ║ 0000 00x0 ║ Reset Missle 0 to Player 0                    ║
RESMP1      byte    ; ║ $29 ║ 0000 00x0 ║ Reset Missle 1 to Player 1                    ║
HMOVE       byte    ; ║ $2a ║ ---- ---- ║ Apply Horizontal Motion                       ║
HMCLR       byte    ; ║ $2b ║ ---- ---- ║ Clear Horizontal Move Registers               ║
CXCLR       byte    ; ║ $2c ║ ---- ---- ║ Clear Collision Latches                       ║
                    ; ╚═════╩════╦══════╩═══════════════════════════════════════════════╣
    seg.u TIA_REGISTERS_READ   ; ║ Segment for TIA Writes, shares address space with    ║
    rorg TIA_BASE_READ_ADDRESS ; ║ the segment for TIA Reads. ╔═══════╦═════════════════╣
                               ; ╚════════════════════════════╝       ║  bit 7   bit 6  ║
                    ; ╔═════╦═══════════╦═════════════════════════════╬═════════════════╣
CXM0P       byte    ; ║ $00 ║ xx00 0000 ║ Read Collision              ║  M0-P1   M0-P0  ║
CXM1P       byte    ; ║ $01 ║ xx00 0000 ║ Read Collision              ║  M1-P0   M1-P1  ║
CXP0FB      byte    ; ║ $02 ║ xx00 0000 ║ Read Collision              ║  P0-PF   P0-BL  ║
CXP1FB      byte    ; ║ $03 ║ xx00 0000 ║ Read Collision              ║  P1-PF   P1-BL  ║
CXM0FB      byte    ; ║ $04 ║ xx00 0000 ║ Read Collision              ║  M0-PF   M0-BL  ║
CXM1FB      byte    ; ║ $05 ║ xx00 0000 ║ Read Collision              ║  M1-PF   M1-BL  ║
CXBLPF      byte    ; ║ $06 ║ x000 0000 ║ Read Collision              ║  BL-PF   -----  ║
CXPPMM      byte    ; ║ $07 ║ xx00 0000 ║ Read Collision              ║  P0-P1   M0-M1  ║
INPT0       byte    ; ║ $08 ║ x000 0000 ║ Read Pot Port 0             ╚═════════════════╣
INPT1       byte    ; ║ $09 ║ x000 0000 ║ Read Pot Port 1                               ║
INPT2       byte    ; ║ $0a ║ x000 0000 ║ Read Pot Port 2                               ║
INPT3       byte    ; ║ $0b ║ x000 0000 ║ Read Pot Port 3                               ║
INPT4       byte    ; ║ $0c ║ x000 0000 ║ Read Input (Trigger) 0                        ║
INPT5       byte    ; ║ $0d ║ x000 0000 ║ Read Input (Trigger) 1                        ║
                    ; ╚═════╩═══════════╩═══════════════════════════════════════════════╝
