;APS026BDA63026BDA63026BDA63026BDA63026BDA63026BDA63026BDA63026BDA63026BDA63026BDA63
;--T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T
;-----------------------------------------------------------------------------
;	Project		Apollo V4 development - Shell
;	File		ManagerModule.s
;	Coder		Neil Beresford
;	Build envrn	ASMPro V1.20b
;-----------------------------------------------------------------------------
;	Notes
;   This module handles the game processing and mode transitions 
;-----------------------------------------------------------------------------

MMCTRL_NUMBERMODES     = 0
MMCTRL_ACTIVEMODEINDEX = 1
MMCTRL_RUNNING         = 2
MMCTRL_TRANSITION      = 3
	
MMMODE_ID              = 0
MMMODE_TMP1            = 1
MMMODE_TMP2            = 2
MMMODE_TMP3            = 3
MMMODE_FNINIT          = 4
MMMODE_FNPROCESS       = 8
MMMODE_FNEXIT          = 12
MMMODE_SIZE            = 16

MM_TOTALMODES          = 10


;-----------------------------------------------------------------------------

;----------------------------------------------------------
; ManagerModule_Init
; Initialise the manager module
;----------------------------------------------------------
ManagerModule_Init:

    rts


;----------------------------------------------------------
; ManagerModule_Init
; Process a game loop within the manager module
;----------------------------------------------------------
ManagerModule_Process:

    rts

;----------------------------------------------------------
; ManagerModule_Init
; Terminates the manager module
;----------------------------------------------------------
ManagerModule_Exit:

    rts
	

;----------------------------------------------------------
; ManagerModule_RegisiterMode
; If possible, registers mode with the manager module
; REGS:
;	IN  - a0 - points to MMODE struct
;  OUT - d0 - index for registered mode, or -1 
;----------------------------------------------------------
ManagerModule_RegisterMode:

    movem.l d1/a0-a2,-(SP)

    moveq  #-1,d0

    lea    MMCtrl,a2
    lea    MMModeStore,a1

	; check space to register mode
	
    cmp.b  #MM_TOTALMODES,MMCTRL_NUMBERMODES(a2)
    beq    .end

	; check the data to make sure things have been set

    clr.l  d1

    cmp.l  #0,MMMODE_FNINIT(a0)
    beq.s  .end
    cmp.l  #0,MMMODE_FNPROCESS(a0)
    beq.s  .end
    cmp.l  #0,MMMODE_FNEXIT(a0)
    beq.s  .end

	; calculate the offset to the mode store

    move.b MMCTRL_NUMBERMODES(a2),d1
    mulu   #MMMODE_SIZE,d1
    add.l  d1,a1

	; initialize

    clr.b  d1
    move.b d1,MMMODE_TMP1(a0)
    move.b d1,MMMODE_TMP2(a0)
    move.b d1,MMMODE_TMP3(a0)

	; store the mode data

    moveq  #(MMMODE_SIZE/4)-1,d1

.store:	

    move.l (a0)+,(a1)+
    dbf    d1,.store

	; finalize the registration
	; reporting success

    addq.b #1,MMCTRL_NUMBERMODES(a2)

    clr.l  d0
    move.b MMCTRL_NUMBERMODES(a2),d0

.end:

    movem.l (SP)+,d1/a0-a2
    rts


;-----------------------------------------------------------------------------
; Data
;-----------------------------------------------------------------------------

    SECTION mmDats,DATA_F

; Manager Module Control Struct

MMCtrl:

    dc.b   0                                    ; 00 Number of registered modes
    dc.b   0                                    ; 01 Current active mode
    dc.b   0                                    ; 02 Module running or paused
    dc.b   0                                    ; 03 Module in transistion state
	
; Store of possible registered modes

MMModeStore:

    ds.b   MM_TOTALMODES*MMMODE_SIZE            ; Store for the registered modes



;-----------------------------------------------------------------------------
; End of file: ManagerModule.s
;-----------------------------------------------------------------------------
