;_____________________________________________________________________________
;__MAP.X68____________________________________________________________________
;_____________________________________________________________________________



;=============================================================================
PRINTMAP:
; PLOTS THE CURRENT MAP ON THE SCREEN
; INPUT:    NONE
; OUTPUT:   NONE
; MODIFIES: NONE
;=============================================================================
            MOVEM.L D0-D7/A0/A1/A2,-(A7)
    
            CMP #5,(POINTS)                 ; CHECK THE CURRENT POINTS
            BEQ .DOOR                       
            BRA .ST
    
   .DOOR:
            JSR WRITEDOOR
            BRA .ST

   .ST:    
            MOVE.W #0,(INDX_COLM)
            JSR PAINTBACK
            JSR RT_CURRENT_MAP              ; MOVES CURRENT_MAP POINTER TO A2
            MOVEA.L A2,A0
            MOVE.W #14,D5                   ; SET D5 FOR 14 ROWS
            
   ROW_LOOP:
            MOVE.W (INDX_COLM),D7
            MOVE.W  #19,D6                  ; SET D6 FOR 19 COLUMNS
            MOVE.L #0,D1
            LSL.L #5,D7                     ; D7 * 32
            MOVE.L D7,D2
            MOVE.L #32,D3
            MOVE.L D2,D4
            ADD.L #32,D4
            LSR.L #5,D7
            ADDQ.W #1,D7
            MOVE.W D7,(INDX_COLM)
            
   COLUMN_LOOP:
            MOVE.W  (A0)+,D0                ; LOAD CURRENT MAP WORD ON D0
            CMP #0,D0
            BEQ.S   NEXT_CELL               ; IF D0 = 0 NO DRAW (VOID)
            CMP #6,D0
            BEQ.S NEXT_CELL                 ; IF D0 = 6 NO DRAW (PREV.DOOR)
            CMP #7,D0
            BEQ.S NEXT_CELL                 ; IF D0 = 7 NO DRAW (NEXT DOOR)
            BNE   DRAW                      ; If D0 IS OTHERWISE DRAW SQUARE

   DRAW:
            MOVE.L D1,-(A7)
            MOVE.L D0,-(A7)
    
            MOVE.L  #$00000000,D1           ; SET COLOR TO BLACK
            MOVE.B  #80,D0                  ; DEFINE PEN COLOR
            TRAP    #15
    
            MOVE.L (A7)+,D0
            LEA BLOCK_1,A1
            SUBQ.L #1,D0
            LSL #2,D0
            ADDA.L D0,A1
    
            MOVE.L  (A1),D1                 ; SET COLOR
            MOVE.B  #81,D0                  ; DEFINE FILL COLOR
            TRAP    #15
            
            MOVE.L (A7)+,D1

            MOVE.B  #87,D0                  ; DRAW SQUARE
            TRAP    #15
            BRA   NEXT_CELL

   NEXT_CELL:
            ADD.L #32,D1                   
            ADD.L #32,D3  
            DBRA   D6,COLUMN_LOOP           ; LOOP FOR COLUMNS (D6)
            DBRA   D5,ROW_LOOP              ; LOOP FOR ROWS (D5)
            
            MOVEM.L (A7)+,D0-D7/A0/A1/A2
            RTS
;_____________________________________________________________________________
           
            
;=============================================================================
PAINTBACK
; PLOTS A SCREEN-SIZED RECTANGLE OF THE SPECIFIED BACKGROUND COLOR
; INPUT:    NONE
; OUTPUT:   NONE
; MODIFIES: NONE
;=============================================================================
    
            MOVEM.L D0-D4,-(A7)

            MOVE.B #80,D0
            MOVE.L (BACKCOLOR),D1
            TRAP #15
    
            MOVE.B #81,D0
            TRAP #15

            MOVE.B #87,D0
            CLR.L D1
            CLR.L D2
            MOVE.W #SCRWIDTH,D3
            MOVE.W #SCRHEIGH,D4
            TRAP #15
    
            MOVEM.L (A7)+,D0-D4

            RTS  
;_____________________________________________________________________________
    
;=============================================================================
RT_CURRENT_MAP
; RETURN INTO A2 THE DIRECTION OF THE CURRENT MAP
; INPUT:    NONE
; OUTPUT:   A2
; MODIFIES: A2
;=============================================================================
            CMP.B #1,(CURRENT_MAP)
            BEQ .MAP1
            CMP.B #2,(CURRENT_MAP)
            BEQ .MAP2
            CMP.B #3,(CURRENT_MAP)
            BEQ .MAP3
            CMP.B #4,(CURRENT_MAP)
            BEQ .MAP4
            CMP.B #5,(CURRENT_MAP)
            BEQ .MAP5
            CMP.B #6,(CURRENT_MAP)
            BEQ .MAP6
            CMP.B #7,(CURRENT_MAP)
            BEQ .MAP7
            CMP.B #8,(CURRENT_MAP)
            BEQ .MAP8
            CMP.B #9,(CURRENT_MAP)
            BEQ .MAP9
            CMP.B #10,(CURRENT_MAP)
            BEQ .MAP9
    
            ILLEGAL
    
   .MAP1:
            LEA MAPDATA, A2
            BRA .EXIT
    
   .MAP2:
            LEA MAPDATA_2, A2
            BRA .EXIT
    
   .MAP3:
            LEA MAPDATA_3, A2
            BRA .EXIT
   .MAP4:
            LEA MAPDATA_4,A2
            BRA .EXIT
   .MAP5:
            LEA MAPDATA_5,A2
            BRA .EXIT
            
   .MAP6:
            LEA MAPDATA_6,A2
            BRA .EXIT
 
   .MAP7:
            LEA MAPDATA_7,A2
            BRA .EXIT
            
   .MAP8:
            LEA MAPDATA_8,A2
            BRA .EXIT
            
   .MAP9:
            LEA MAPDATA_9,A2
            BRA .EXIT
    
   .EXIT:
            RTS
;_____________________________________________________________________________

;=============================================================================
WRITEDOOR
; PLOTING A DOOR ON THE DOOR COORDINATES FOR THE NEXT MAP
; INPUT:    NONE
; OUTPUT:   NONE
; MODIFIES: NONE
;=============================================================================
            MOVEM.L D0-D4/A2/A3,-(A7)
            JSR RT_CURRENT_MAP              ; A2 POINTING TO MAP FIRST ELEM.
    
            MOVE.L  A2, A3            
            MOVE.W  #POS_SALIDA_1, D0 
            ADD.L   D0, A3                  ; A3 POINTING TO 13x20
            MOVE.W  #7, (A3)

            MOVE.L  A2, A3
            MOVE.W  #POS_SALIDA_2, D0
            ADD.L   D0, A3
            MOVE.W  #7, (A3)                ; A3 POINTING TO 14x20

            MOVEM.L (A7)+,D0-D4/A2/A3

            RTS
;_____________________________________________________________________________
    
;=============================================================================
NEXT_MAP
; INPUT:    NONE
; OUTPUT:   NONE
; MODIFIES: NONE
;=============================================================================
            MOVEM.L D0/D1/A0/A1/A2,-(A7)
    
            ADDQ.B #1,(CURRENT_MAP)
            MOVE.W #0,(POINTS)
            MOVE.W #50,(PLAYER_X)
            JSR RT_CURRENT_COINS            ; A0: CURRENT_COINS VECTOR
                                            ; A1 AND A2 MODIFIED TOO
            MOVE.W #4,D0
   .LOOP:                                   ; COUNTER OF CURRENT POINTS
            MOVE.B (A0)+,D1
            CMP.B #1,D1
            BEQ .NO_SAL
            ADD.W #1,(POINTS)
   .NO_SAL:   
            DBRA D0,.LOOP
    
            MOVEM.L (A7)+,D0/D1/A0/A1/A2
            RTS
;_____________________________________________________________________________

;=============================================================================
PREVIOUS_MAP
; INPUT:    NONE
; OUTPUT:   NONE
; MODIFIES: NONE
;=============================================================================
    SUBQ.B #1,(CURRENT_MAP)
    MOVE.W #600,(PLAYER_X)
    MOVE.W #5,(POINTS)
    RTS
;_____________________________________________________________________________


















*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
