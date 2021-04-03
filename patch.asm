; OVERRIDES: --------------------------------------------------------------------------------------
	org $29E
	jsr BOOT_DETOUR

	org $72D26
	jsr MUSIC_DETOUR

	org $7338A
	jmp PAUSE_RESUME_DETOUR

; DETOURS: --------------------------------------------------------------------------------------
	org $7FF10

MUSIC_DETOUR
        cmpi.b  #$91,d0
        bls	PLAY_MD_PLUS
        cmpi.b  #$E1,d0
        beq	STOP_MD_PLUS
        move.b  d0,d2
        subi.w  #$81,d0
        rts

PLAY_MD_PLUS
	ori.w   #$1200,d0			;or play command into d0
	subi.w  #$80,d0				;subtract $80 to make sure d0 starts at 1
	move.w  #$CD54,($0003F7FA)   		;open interface
    	move.w  d0,($0003F7FE)      		;send play command to interface
    	move.w  #$0000,($0003F7FA)   		;close interface
    	move.w  #$0080,d2
    	move.w  d2,d0
    	subi.w  #$81,d0
        rts

STOP_MD_PLUS
	move.w  #$CD54,($0003F7FA)   		;open interface
    	move.w  #$1300,($0003F7FE)      	;send pause command to interface
    	move.w  #$0000,($0003F7FA)   		;close interface
    	move.w  d2,d0
    	subi.w  #$81,d0
    	rts

PAUSE_RESUME_DETOUR
	beq PAUSE
	move.w  #$1400,d7
	move.b  #$80,($FFFFF007)		;original code is necessary to keep
	bra WRITE_STOP_OR_RESUME
PAUSE
	move.w  #$1300,d7
	move.b  #$1,($FFFFF007)			;original code is necessary to keep
WRITE_STOP_OR_RESUME
	move.w  #$CD54,($0003F7FA)   		;open interface
    	move.w  d7,($0003F7FE)      		;send pause/resume command to interface
    	move.w  #$0000,($0003F7FA)   		;close interface
    	rts

BOOT_DETOUR
 	jsr STOP_MD_PLUS
 	move #$2700,SR
 	jmp $308
