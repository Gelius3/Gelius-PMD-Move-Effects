; 
; ------------------------------------------------------------------------------
; A template to code your own move effects
; By happylappy: Does damage, then a 30% chance to lower special attack by 1 stage!
; Note: happylappy allowed me to post this to my Repo, but full credits go for them!
; ------------------------------------------------------------------------------


.relativeinclude on
.nds
.arm


.definelabel MaxSize, 0x2598
.definelabel MoveStartAddress, 0x02330134
.definelabel MoveJumpAddress, 0x023326CC
.definelabel LowerOffensiveStat, 0x23135FC
.definelabel DealDamage, 0x2332B20
.definelabel DungeonRandOutcomeUserTargetInteraction, 0x2324934

; For EU
;.include "lib/stdlib_eu.asm"
;.include "lib/dunlib_eu.asm"
;.definelabel MoveStartAddress, 0x02330B74
;.definelabel MoveJumpAddress, 0x0233310C


; File creation
.create "./code_out.bin", 0x02330134 ; Change to the actual offset as this directive doesn't accept labels
    .org MoveStartAddress
    .area MaxSize ; Define the size of the area
    sub sp,sp,#0x8
    
    mov r0,r9
    mov r1,r4
    mov r2,r8
    mov r3,#255
    str r7,[sp,#0]
    bl  DealDamage
    ; Check randomly
    mov r0,r9
    mov r1,r4
    mov r2,#30 ; 30% chance to trigger secondary effect
    bl  DungeonRandOutcomeUserTargetInteraction
    cmp r0,#1
    bne return
    
    ; Lower Special Attack
    mov r0, #1 ; set r0 to 1 (Check for stuff like Clear Body or Mist is True)
    str r0,[sp,#0] ; Put 1 into the stack in byte 0.
    mov r0, #1 ; set r0 to 1 (Give a message in the log if it fails is True)
    str r0,[sp,#1] ; Put 1 into the stack in byte 1.
    mov r0, r9; Copy user from r9 to r0
    mov r1, r4; Copy target from r4 to r1
    mov r2, #1; Attack is ID 0, SPA is ID 1
    mov r3, #1; Lower 1 stage of SPA
    bl LowerOffensiveStat
    return:
        add sp,sp,#0x8
        b MoveJumpAddress
        .pool
    .endarea
.close
