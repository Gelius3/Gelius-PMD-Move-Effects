; ------------------------------------------------------------------------------
; Gelius - 29/06/2024
; Growth Raises the user's Attack and Special Attack by 2 stages. It's effects
; double with Sunny Weather.
; Based on Shell Smash from HeckaBad, with help from happylappy
; ------------------------------------------------------------------------------

.relativeinclude on
.nds
.arm

.definelabel MaxSize, 0x2598

.include "lib/stdlib_us.asm"
.include "lib/dunlib_us.asm"
.definelabel MoveStartAddress, 0x02330134
.definelabel MoveJumpAddress, 0x023326CC
.definelabel BoostOffensiveStat, 0x231399C
.definelabel GetApparentWeather, 0x2334D08

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
		
		mov r0, r9
		bl GetApparentWeather;
		cmp r0, #1;
		beq WeatherIsSunny;
		
        mov r0,r9
		mov r1,r9
		mov r2,#0
		mov r3,#1
		bl BoostOffensiveStat

        mov r0,r9
		mov r1,r9
		mov r2,#1
		mov r3,#1
		bl BoostOffensiveStat
		
		mov r10,#1
		
		b return
		
		WeatherIsSunny:
			mov r0,r9
			mov r1,r9
			mov r2,#0
			mov r3,#2
			bl BoostOffensiveStat

			mov r0,r9
			mov r1,r9
			mov r2,#1
			mov r3,#2
			bl BoostOffensiveStat
		
		return:
			add sp,sp,#0x8
			b MoveJumpAddress
		.pool
    .endarea
.close