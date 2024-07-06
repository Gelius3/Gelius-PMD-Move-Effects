; 
; ------------------------------------------------------------------------------
; A template to code your own move effects
; By Gelius: Triple Arrows hits three times, and each hit has it's own effect, 
; which can independently happen on their own (First it's a 50% chance to lower
; Defense, then a 30% chance to flinch, and finally a higher crit chance).
; ------------------------------------------------------------------------------


.relativeinclude on
.nds
.arm


.definelabel MaxSize, 0x2598
.definelabel MoveStartAddress, 0x02330134
.definelabel MoveJumpAddress, 0x023326CC
.definelabel LowerDefensiveStat, 0x2313814
.definelabel TryInflictCringeStatus, 0x23143E8
.definelabel TryInflictFocusEnergyStatus, 0x2315D84
.definelabel DealDamage, 0x2332B20
.definelabel DungeonRandOutcomeUserTargetInteraction, 0x2324934
.definelabel EndSureShotClassStatus, 0x2306950

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
    mov r3,#0x100
    str r7,[sp,#0]
    bl  DealDamage
	
	movs r10,r0
	beq hit_2
	
    ; Check randomly
    mov r0,r9
    mov r1,r4
    mov r2,#50 ; 50% chance to trigger secondary effect
    bl  DungeonRandOutcomeUserTargetInteraction
    cmp r0,#1
    bne hit_2
    
    ; Lower Defense
    mov r0, #1 ; set r0 to 1 (Check for stuff like Clear Body or Mist is True)
    str r0,[sp,#0] ; Put 1 into the stack in byte 0.
    mov r0, #1 ; set r0 to 1 (Give a message in the log if it fails is True)
    str r0,[sp,#1] ; Put 1 into the stack in byte 1.
    mov r0, r9; Copy user from r9 to r0
    mov r1, r4; Copy target from r4 to r1
    mov r2, #0; Defense is ID 0, SPD is ID 1
    mov r3, #1; Lower 1 stage of Defense
    bl LowerDefensiveStat
	
	hit_2:
		mov r0,r9
		mov r1,r4
		mov r2,r8
		mov r3,#0x100
		str r7,[sp,#0]
		bl  DealDamage
		
		movs r10,r0
		beq hit_3
		
		; Check randomly
		mov r0,r9
		mov r1,r4
		mov r2,#30 ; 30% chance to trigger secondary effect
		bl  DungeonRandOutcomeUserTargetInteraction
		cmp r0,#1
		bne hit_3
		
		; Flinches
		mov r0,r9
		mov r1,r4
		mov r2,#1
		mov r3,#0
		bl 	TryInflictCringeStatus
		
	hit_3:
		; Focus Energy
		mov r0,r9
		mov r1,r9
		bl TryInflictFocusEnergyStatus
		
		; Deal 3rd Hit
		mov r0,r9
		mov r1,r4
		mov r2,r8
		mov r3,#0x100
		str r7,[sp,#0]
		bl  DealDamage
		
		;Remove the Focus Energy
		mov r0,r9
		mov r1,r9
		bl 	EndSureShotClassStatus
    
	return:
        add sp,sp,#0x8
        b MoveJumpAddress
        .pool
    .endarea
.close
