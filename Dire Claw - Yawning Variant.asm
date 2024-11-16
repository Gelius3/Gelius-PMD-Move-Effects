; 
; ------------------------------------------------------------------------------
; Gelius 06/16/2024
; Dire Claw has a 50% chance of Paralyzing, Poisoning or putting the Target to Sleep.
; Had fucktons of help from Lappy and Hecka here.
; ------------------------------------------------------------------------------


.relativeinclude on
.nds
.arm


.definelabel MaxSize, 0x2598
.definelabel MoveStartAddress, 0x02330134
.definelabel MoveJumpAddress, 0x023326CC
.definelabel DealDamage, 0x2332B20
.definelabel DungeonRandOutcomeUserTargetInteraction, 0x2324934
.definelabel TryInflictYawningStatus, 0x2311E70
.definelabel TryInflictParalysisStatus, 0x2314544
.definelabel TryInflictPoisonedStatus, 0x2312664
.definelabel DungeonRandInt, 0x22EAA98

.create "./code_out.bin", 0x02330134
	.org MoveStartAddress
	.area MaxSize 
	
	sub r13,r13,#0x4
	
    mov r0,r9
    mov r1,r4
    mov r2,r8
    mov r3,#0x100
    str r7,[sp,#0]
    bl  DealDamage
	
    mov r0,r9
    mov r1,r4
    mov r2,#50
    bl  DungeonRandOutcomeUserTargetInteraction
    cmp r0,#1
    beq return
    mov r0,#3
    bl DungeonRandInt
    cmp r0, #0
    beq status_1
    cmp r0, #1
    beq status_2
    cmp r0, #2
    beq status_3
	
	status_1:
		mov r0,r9
		mov r1,r4
		mov r2,#5
		bl TryInflictYawningStatus		
		b return
	status_2:
		mov r0,r9
		mov r1,r4
		mov r2,#0
		mov r3,#0
		bl TryInflictParalysisStatus		
		b return
	status_3:
		mov r0,r9
		mov r1,r4
		mov r2,#0
		mov r3,#0
		bl TryInflictPoisonedStatus		
		b return
	return:
		add r13,r13,#0x4
		b MoveJumpAddress
		.pool
	.endarea
.close
