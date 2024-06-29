; ------------------------------------------------------------------------------
; Gelius - 29/06/2024
; Low Kick deals damage depending on how heavy the target is. The heavier the target
; the stronger it is. It also has a 30% chance to Flinch, based on Gen 1 and 2 appearances.
; Made with help from happylappy and Adex
; ------------------------------------------------------------------------------

.relativeinclude on
.nds
.arm

.definelabel MaxSize, 0x2598

.include "lib/stdlib_us.asm"
.include "lib/dunlib_us.asm"
.definelabel MoveStartAddress, 0x02330134
.definelabel MoveJumpAddress, 0x023326CC
.definelabel TryInflictCringeStatus, 0x23143E8
.definelabel DoMoveDamageWeightDependent, 0x23277B8
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
		mov r3,r7
		bl DoMoveDamageWeightDependent
		
		cmp r0,#0
		movne r10,#1
		moveq r10,#0
		beq return
		
		mov r0,r9
		mov r1,r4
		mov r2,#30
		bl DungeonRandOutcomeUserTargetInteraction
		cmp r0,#1
		bne return
		
		mov r0,r9
		mov r1,r4
		mov r2,#1
		mov r3,#0
		bl TryInflictCringeStatus
		
		return:
			add sp,sp,#0x8
			b MoveJumpAddress
		.pool
    .endarea
.close