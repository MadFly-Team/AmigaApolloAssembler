;APS026BCD05026BCD05026BCD05026BCD05026BCD05026BCD05026BCD05026BCD05026BCD05026BCD05
;--T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T
;-----------------------------------------------------------------------------
;	Project		Apollo V4 development - Shell
;	File		Screen.s
;	Coder		Neil Beresford
;	Build envrn	ASMPro V1.20b
;-----------------------------------------------------------------------------
;	Notes
;
;-----------------------------------------------------------------------------

;-----------------------------------------------------------------------------
; Code
;-----------------------------------------------------------------------------

	SECTION screen,CODE_C

;-----------------------------------------------------------------------------

;----------------------------------------------------------
; Screen_Clear
; Clears the screen, currently fixed to a light green
;----------------------------------------------------------
Screen_Clear:

	movem.l	d0-d1/a0,-(SP)

	move.l	#SCREENCLEARCOLOUR,d1
	move.l	#((SCREENWIDTH*SCREENHEIGHT)/4)-1,d0
	move.l	screenPtr,a0

.loop:	

	move.l	d1,(a0)+
	dbra	d0,.loop

	movem.l (SP)+,d0-d1/a0
	rts

;----------------------------------------------------------
; Screen_Gradient
; Vertical gradient fill going light to dark
;----------------------------------------------------------
Screen_Gradient:

	movem.l	d0-d2/a0,-(SP)

	move.l	screenPtr,a0
	moveq	#-1,d2

	move.l	#SCREENHEIGHT-1,d1

.lines:
	
	move.l	#(SCREENWIDTH/4)-1,d0

.loop:	

	move.l	d2,(a0)+
	dbra	d0,.loop

	sub.l	#$01010101,d2
	dbra	d1,.lines

	movem.l (SP)+,d0-d2/a0
	rts



;----------------------------------------------------------
; Screen_Test
; displays the full 256 palette in pixels, looping
;----------------------------------------------------------
Screen_Test:

	movem.l	d0-d1/a0,-(SP)

	move.l	screenPtr,a0
	move.l	#SCREENSIZE,d0
	moveq	#0,d1

.loop:

	move.b	d1,(a0)+
	add.b	#1,d1
	sub.l	#1,d0
	bne.b	.loop	

	movem.l (SP)+,d0-d1/a0
	rts


;-----------------------------------------------------------------------------
; End of file: Screen.s
;-----------------------------------------------------------------------------

