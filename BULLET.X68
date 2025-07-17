;_____________________________________________________________________________
;___BULLET.X68________________________________________________________________
;_____________________________________________________________________________

;=============================================================================
BULL_PLOT
; INPUT:    D5: X POS
;           D6: Y POS
; OUTPUT:   NONE
; MODIFIES: NONE
;=============================================================================

            MOVEM.L  D0-D4,-(A7)
    
            MOVE.L  #$00000000,D1
            MOVE.B  #80,D0
            TRAP    #15
            MOVE.L  #BULL_CLR,D1
            MOVE.B  #81,D0
            TRAP    #15
            CLR.L D1
    
            MOVE.W D5,D1
            SUB.W #BULL_RAD,D1
            MOVE.W D6,D2
            SUB.W #BULL_RAD,D2
            MOVE.W D5,D3
            ADD.W #BULL_RAD,D3
            MOVE.W D6,D4
            ADD.W #BULL_RAD,D4

            MOVE.B  #88,D0
            TRAP    #15
    
            MOVEM.L  (A7)+,D0-D4
            RTS
;_____________________________________________________________________________

;=============================================================================
CURRENT_BULL
;=============================================================================
            MOVEM.L D0-D7/A0-A6,-(A7)

            JSR RT_CURRENT_BULL             ; MODIFIES A1,A2,A3,A4,A5,A6

            MOVE.W #BULL_NUM-1,D7
            CLR.L D0
            CLR.L D1
   .NEXTUP:
            MOVE.W (A3)+,D0
            MOVE.W (A4)+,D1
    
            ADD.W D0,(A1)
            ADD.W D1,(A2)
        
            MOVE.W (A1),D5
            MOVE.W (A2),D6
    
            MOVE.W D5,D3
            MOVE.W D6,D4

            MOVE.W  (PLAYER_X),D0
            MOVE.W  (PLAYER_Y),D1

            SUB.W   D5, D0               ; D0 = X DIFF
            SUB.W   D6, D1               ; D1 = Y DIFF

            MULS    D0, D0               ; D0 = (PL X - COIN X)^2
            MULS    D1, D1               ; D1 = (PL Y - COIN Y)^2

            ADD.L   D1, D0               ; D0 = (X DIFF)^2 + (Y DIFF)^2

            MOVE.W  #PLAYER_SIZE, D2     ; D2 = R_PLAYER
            ADD.W   #BULL_RAD, D2        ; D2 = R_PLAYER + R_COIN
            MULS    D2, D2               ; D2 = (R_PLAYER + R_COIN)^2

            CMP.L   D2, D0
            BGT     .SIGUE               ; NO COLLISION BRANCH

            ; COLLISION BULLET-PLAYER DETECTED:
            SUBQ.W #1,(LIVES)
            MOVE.W #STARTER_X,(PLAYER_X)
            MOVE.W #STARTER_Y,(PLAYER_Y)
            JSR GAME_CHECK
    
   .SIGUE:    
            MOVE.W (A5),D0                  ; INITIAL X
            MOVE.W (A6),D1                  ; INITIAL Y
            JSR BULL_COLL                   ; D3 = X POS and D4 = Y POS
            MOVE.W D3,(A1)                  ; SAVES NEW X POSITION
            MOVE.W D4,(A2)                  ; SAVES NEW Y POSITION
            
            ADDA.L #2,A1                    ; UPDATING VECTORS INDEX
            ADDA.L #2,A2
            ADDA.L #2,A5
            ADDA.L #2,A6

            JSR BULL_PLOT
   .NEXT:
            DBRA D7,.NEXTUP
    
            MOVEM.L (A7)+,D0-D7/A0-A6
            RTS
;_____________________________________________________________________________

;=============================================================================
RT_CURRENT_BULL
; INPUT:    NONE
; OUTPUT:   A1: BMn_POS_X
;           A2: BMn_POS_Y
;           A3: BMn_VEL_X
;           A4: BMn_VEL_Y
;           A5: BMn_INI_X
;           A6: BMn_INI_Y
;           n IS THE CURRENT MAP VALUE
; MODIFIES: A1/A2/A3/A4/A5/A6
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
            LEA BM1_POS_X,A1
            LEA BM1_POS_Y,A2
            LEA BM1_VEL_X,A3
            LEA BM1_VEL_Y,A4
            LEA BM1_INI_X,A5
            LEA BM1_INI_Y,A6
            BRA .EXIT
    
   .MAP2:
            LEA BM2_POS_X,A1
            LEA BM2_POS_Y,A2
            LEA BM2_VEL_X,A3
            LEA BM2_VEL_Y,A4
            LEA BM2_INI_X,A5
            LEA BM2_INI_Y,A6
            BRA .EXIT
    
   .MAP3:
            LEA BM3_POS_X,A1
            LEA BM3_POS_Y,A2
            LEA BM3_VEL_X,A3
            LEA BM3_VEL_Y,A4
            LEA BM3_INI_X,A5
            LEA BM3_INI_Y,A6
            BRA .EXIT
            
   .MAP4:
            LEA BM4_POS_X,A1
            LEA BM4_POS_Y,A2
            LEA BM4_VEL_X,A3
            LEA BM4_VEL_Y,A4
            LEA BM4_INI_X,A5
            LEA BM4_INI_Y,A6
            BRA .EXIT
            
   .MAP5:
            LEA BM5_POS_X,A1
            LEA BM5_POS_Y,A2
            LEA BM5_VEL_X,A3
            LEA BM5_VEL_Y,A4
            LEA BM5_INI_X,A5
            LEA BM5_INI_Y,A6
            BRA .EXIT
            
   .MAP6:
            LEA BM6_POS_X,A1
            LEA BM6_POS_Y,A2
            LEA BM6_VEL_X,A3
            LEA BM6_VEL_Y,A4
            LEA BM6_INI_X,A5
            LEA BM6_INI_Y,A6
            BRA .EXIT
           
   .MAP7:
            LEA BM7_POS_X,A1
            LEA BM7_POS_Y,A2
            LEA BM7_VEL_X,A3
            LEA BM7_VEL_Y,A4
            LEA BM7_INI_X,A5
            LEA BM7_INI_Y,A6
            BRA .EXIT
            
   .MAP8:
            LEA BM8_POS_X,A1
            LEA BM8_POS_Y,A2
            LEA BM8_VEL_X,A3
            LEA BM8_VEL_Y,A4
            LEA BM8_INI_X,A5
            LEA BM8_INI_Y,A6
            BRA .EXIT
            
   .MAP9:
            LEA BM9_POS_X,A1
            LEA BM9_POS_Y,A2
            LEA BM9_VEL_X,A3
            LEA BM9_VEL_Y,A4
            LEA BM9_INI_X,A5
            LEA BM9_INI_Y,A6
            BRA .EXIT
    
   .EXIT:
            RTS
    
;=============================================================================
BULL_COLL
; IN CHARGE OF MANAGING THE COLLISIONS WITH THE MAP
; INPUT:    D3.W: BULL X POSITION
;           D4.W: BULL Y POSITION
;           (A5): BULL INITIAL X POSITION
;           (A6): BULL INITIAL Y POSITION
; OUTPUT:   D3.W: NEW X POSITION
;           D4.W: NEW Y POSITION
; MODIFIES: D3.W
;           D4.W
;=============================================================================
            MOVEM.L D0/D1/A2,-(A7)
            
            CLR.L D0
            CLR.L .CLM
            CLR.L .ROW
        
            JSR RT_CURRENT_MAP              ; A2 POINTING TO THE CURRENT MAP

            MOVE.W D3,D0 
            ASR.W   #5, D0
            MOVE.W D0, (.CLM)    

            MOVE.W D4,D0
            ASR.W   #5,D0
            MOVE.W D0, (.ROW)
    
            MULU #40,D0
            CLR.L D1
            ADD.W (.CLM),D1
            ASL.W #1,D1
            ADD.W D1,D0
 
    
            ADDA.W D0,A2
            MOVE.W (A2),D0
    
            CMP.W #0,D0
            BEQ .RET                        ; IF D0 = 0 -> NO BLOCK, JUMP
            ; D0 != 0 -> BLOCK, BULLET GO TO INITIAL POSITION
            MOVE.W (A5),D3
            MOVE.W (A6),D4
.RET
            MOVEM.L (A7)+,D0/D1/A2
            RTS  
.CLM DS.L 1
.ROW DS.L 1
;_____________________________________________________________________________

    
    
    
    
    
    
    
















*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
