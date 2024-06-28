; 
; ------------------------------------------------------------------------------
; Psyshield Bash
; By Gelius: Does damage, then the user's defense stat is raised by 1 stage!
; Based on Happylappy's Moonblast
; ------------------------------------------------------------------------------


.relativeinclude on
.nds
.arm


.definelabel MaxSize, 0x2598
.definelabel MoveStartAddress, 0x02330134
.definelabel MoveJumpAddress, 0x023326CC
.definelabel BoostDefensiveStat, 0x2313B08
.definelabel DealDamage, 0x2332B20

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
    
    mov r0, #1
    str r0,[sp,#1]
    mov r0, r9
    mov r1, r9
    mov r2, #0
    mov r3, #1
    bl BoostDefensiveStat
    return:
        add sp,sp,#0x8
        b MoveJumpAddress
        .pool
    .endarea
.close
