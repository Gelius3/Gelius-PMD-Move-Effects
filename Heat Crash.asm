; ------------------------------------------------------------------------------
; Gelius - 29/06/2024
; Heat Crash Deals Damage based on how light the target is.
; Note: Due to there only being 9 weight classes (153, 179, 204, 230, 256, 281,
; 307, 332, 358), the calculations will be inherently flawed.
; Made with (A LOT OF) help from Frostbyte, Happylappy, Adex and Irdkwia
; ------------------------------------------------------------------------------

.relativeinclude on
.nds
.arm

.definelabel MaxSize, 0x2598

.include "lib/stdlib_us.asm"
.include "lib/dunlib_us.asm"
.definelabel MoveStartAddress, 0x02330134
.definelabel MoveJumpAddress, 0x023326CC
.definelabel GetWeightMultiplier, 0x20528FC
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
		
		mov        r0,r9; Get user pointer
		ldr        r0,[r0,#0xb4 ]; Jump to the User Monster Data
		ldrsh      r0,[r0,#0x4 ]; Jump to the User's species (Ditto weighs whatever it transformed into!)
		bl         GetWeightMultiplier
		mov        r10, r0; Store user "weight" in r10
		mov        r0,r4; Get target pointer
		ldr        r0,[r0,#0xb4 ]; Jump to the Target Monster Data
		ldrsh      r0,[r0,#0x4 ]; Jump to the Target species (Ditto weighs whatever it transformed into!)
		bl         GetWeightMultiplier
		mov        r12, r0; Stor target "weight" in r12
		mov        r3, #178; Set multiplier to 178
		add        r3, r10; Add user "weight"
		sub        r3, r12; Subtract target "weight"
		cmp        r3, #153; Compare against 153
		movle      r3, #153; If less than or equal, multiplier is 153
		mov        r0, r9; User
		mov        r1, r4; Target
		mov        r2, r8; Move
		str		   r7,[sp,#0]
		bl         DealDamage

		return:
			add sp,sp,#0x8
			b MoveJumpAddress
		.pool
    .endarea
.close