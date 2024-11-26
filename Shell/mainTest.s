;APS00000AE700000AE700000AE700000AE700000AE700000AE700000AE700000AE700000AE700000AE7
;--T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T
;-----------------------------------------------------------------------------
;	Project		Apollo V4 development - Shell
;	File		Hardware.s
;	Coder		Neil Beresford
;	Build envrn	ASMPro V1.20b
;-----------------------------------------------------------------------------
;	Notes
;
;-----------------------------------------------------------------------------

;-----------------------------------------------------------------------------

	SECTION	code,CODE_F

;-----------------------------------------------------------------------------

;-----------------------------------------------------------------------------
; Defines
;-----------------------------------------------------------------------------

MAIN_BUILD		= 1			; Used to remove the test code for the modules
TEST_BUILD		= 1			; Allows test to be processed.

;-----------------------------------------------------------------------------
; Code
;-----------------------------------------------------------------------------

;----------------------------------------------------------
; Main
; Entry point, jumps to the start of the main application
; skipping the included source.
;----------------------------------------------------------
Main:

	jmp		Start

;-----------------------------------------------------------------------------
; Includes
;-----------------------------------------------------------------------------

	include "Source/Defines.i"		; Defines for Application
	include "source/macros.i"		; Include - macros
	include "source/Hardware.s"		; Hardware related functionality
	include "source/Screen.s"		; Screen handling functionality
	include "source/FontModule.s"	; Font display module
	include "source/UtilsModule.s"	; General Utils module
	include "source/TestModule.s"	; Test functionality, used in development
	
	EVEN

;----------------------------------------------------------
; Start
; Starting point, initialise and process the main loop
;----------------------------------------------------------
Start:
		

	movem.l	d1-a6,-(SP)

	; System Init

	jsr		Hardware_InitSystem
	FAILTO	.end
	
	jsr		Hardware_SetPalette			; or use Hardware_SetGreyScalePalette 
	jsr		Hardware_FlipScreen

.loop:

	jsr		Hardware_WaitVBL
	lea		TestPic,a1
	bsr		DrawImage

	IF TEST_BUILD=1
	; Testing ----------

	move.l	#10,d0						; X pos
	move.l	#20,d1						; Y pos
	lea		TestString,a0				; String to display
	jsr		FontModule_DisplayString


	move.l	#10,d0						; X pos
	move.l	#2,d1						; Y pos
	move.l	#$abcdef90,d2				; 32 bit value to be displayed as hex
	jsr		FontModule_DisplayHex

	; Testing ends -----
	ENDIF
			
	jsr		Hardware_FlipScreen
	jsr		Hardware_ReadKey
	cmp.b	#$45,d0
	bne		.loop

.end:

	; Restore System

	jsr		Hardware_RestoreSystem

.fail:

	movem.l	(SP)+,d1-a6
	moveq	#0,d0
	rts

;----------------------------------------------------------
; KeyCheckRelease
; Checks for keypress, then awaits its release
; Regs d1 key to check	
;----------------------------------------------------------
KeyCheckRelease:
	

	jsr		Hardware_ReadKey
	cmp.b	d1,d0
	bne.s	.end

.loop:

	jsr		Hardware_ReadKey
	cmp.b	d1,d0
	beq.s	.loop

	move.b	d1,d0

.end:
	rts



;----------------------------------------------------------
; DrawImage
; copys image data to screen
; Regs:
;	a1 - Points to the image to copy
;----------------------------------------------------------
DrawImage:

	movem.l	d0/a0-a1,-(SP)

	move.l	screenPtr,A0
	move.l	#(SCREENSIZE/4)-1,d0

.background:

	move.l	(a1)+,(a0)+
	dbf		d0,.background
			
	movem.l	(SP)+,d0/a0-a1
	rts
	
	
;-----------------------------------------------------------------------------
; Data
;-----------------------------------------------------------------------------

	SECTION data,DATA_F

TestString:

	dc.b	"123456",$99,$02," Neil Beresford",10,"RULES! ?/@!$%^&*()_+-",0

	EVEN
	
TestPic:

	INCBIN "Graphics/NeilImage.png.raw"

TestPic_End:

	EVEN

