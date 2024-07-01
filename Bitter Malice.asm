; 
; ------------------------------------------------------------------------------
; Gelius 06/16/2024
; Bitter Malice has a 30% chance of freezing the Target, and deals twice the damage
; if the taget's already statused. It also lowers the target's Attack Stat by 1 stage!
; ------------------------------------------------------------------------------


.relativeinclude on
.nds
.arm


.definelabel MaxSize, 0x2598
.definelabel MoveStartAddress, 0x02330134
.definelabel MoveJumpAddress, 0x023326CC
.definelabel DealDamage, 0x2332B20
.definelabel DungeonRandOutcomeUserTargetInteraction, 0x2324934
.definelabel TryInflictFrozenStatus, 0x2312BF8
.definelabel LowerOffensiveStat, 0x23135FC


; For EU
;.include "lib/stdlib_eu.asm"
;.include "lib/dunlib_eu.asm"
;.definelabel MoveStartAddress, 0x02330B74
;.definelabel MoveJumpAddress, 0x0233310C


; File creation
.create "./code_out.bin", 0x02330134 ; Change to the actual offset as this directive doesn't accept labels
	.org MoveStartAddress
	.area MaxSize ; Define the size of the area
	; Usable Variables: 
	; r6 = Move ID
	; r9 = User Monster Structure Pointer
	; r4 = Target Monster Structure Pointer
	; r8 = Move Data Structure Pointer (8 bytes: flags [4 bytes], move_id [2 bytes], pp_left [1 byte], boosts [1 byte])
	; r7 = ID of the item that called this move (0 if the move effect isn't from an item)
	; Returns: 
	; r10 (bool) = ???
	; Registers r4 to r9, r11 and r13 must remain unchanged after the execution of that code
		
	sub r13,r13,#0x4
	ldr r0,[r4,#+0xb4]
	ldrb r1,[r0,#+0xbd]
	ldrb r2,[r0,#+0xbf]
	cmp r1,#1
	cmpne r1,#3
	cmpne r1,#5
	moveq r3,#0x200
	beq DealDamage
	cmp r2,#0
	movne r3,#0x200
	moveq r3,#0x100
	
	str r7,[sp]
	
	mov r0,r9
	mov r1,r4
	mov r2,r8
	str r7,[sp,#0]
	bl  DealDamage

	movs r10,r0
	beq return_2
	
	mov r0,r9
	mov r1,r4
	mov r2,#30
	bl  DungeonRandOutcomeUserTargetInteraction
	cmp r0,#1
	bne return
	
	mov r0,r9
	mov r1,r4
	mov r2,#1
	mov r3,#0
	bl  TryInflictFrozenStatus
	
	return:
		
		movs r10,r0
		beq return
	
		mov r0, #1
		str r0,[sp,#0]
		mov r0, #1
		str r0,[sp,#1]
		mov r0, r9
		mov r1, r4
		mov r2, #0
		mov r3, #1
		bl LowerOffensiveStat
		
		return_2:
			add r13,r13,#0x4
			b MoveJumpAddress
			.pool
	.endarea
.close