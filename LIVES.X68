;_____________________________________________________________________________
;___LIVES.X68_________________________________________________________________
;_____________________________________________________________________________

;=============================================================================
LIVES_PLOT
; SUBRUTINE IN CHARGE OF PLOTTING THE NUMBER OF LIVES ON THE TOP OF THE SCREEN
; INPUT:    NONE
; OUTPUT:   NONE
; MODIFIES: NONE
;=============================================================================
            MOVEM.L D0/D1/D2/D3,-(A7)
            
            MOVE.W (LIVES),D0               ; NUM: CURRENT PLAYER LIVES
            
            CMP.W #3,D0
            BEQ .THREE
            
            CMP.W #2,D0
            BEQ .TWO
            
            CMP.W #1,D0
            BEQ .ONE
            BRA .END
            
            
   .THREE:
            JSR .FIRST
            JSR .SECOND
            JSR .THIRD
            BRA .END
            
   .TWO:
            JSR .FIRST
            JSR .SECOND
            BRA .END
   .ONE:    
            JSR .FIRST
            BRA .END
            
   
   .FIRST:  ; FIRST "HEART"
            MOVE.W #(SCRWIDTH/2)-LIVES_DIS,D1
            MOVE.W #16,D2
            JSR HEARTPLT                    ; D3.W CONTAINS AN 0 OR 1
            RTS
            
   .SECOND: ; SECOND "HEART"
            MOVE.W #SCRWIDTH/2,D1
            MOVE.W #16,D2
            JSR HEARTPLT
            RTS
                        
   .THIRD:  ; THIRD "HEART"
            MOVE.W #(SCRWIDTH/2)+LIVES_DIS,D1
            MOVE.W #16,D2           
            JSR HEARTPLT
            RTS
            
   .END:
            
            MOVEM.L (A7)+,D0/D1/D2/D3
            RTS
;_____________________________________________________________________________

;=============================================================================
HEARTPLT
; PLOTTING A HEART.
; INPUT:    D1 = X
;           D2 = Y
; OUTPUT:   NONE
; MODIFIES: NONE
;=============================================================================
            MOVEM.L D0/D4/D5,-(A7)
            
            MOVE.L D1,-(A7)                 ; PARAMETER SAVING

            MOVE.L  #$00000000, D1
            MOVE.L  #80, D0
            TRAP    #15

            MOVE.L  #LIVES_COL, D1
            MOVE.L  #81, D0
            TRAP    #15
            
            MOVE.L (A7)+,D1
            MOVE.W  D1, D3
            MOVE.W  D2, D4
            SUB.W   #LIVES_RAD, D1
            SUB.W   #LIVES_RAD, D2
            ADD.W   #LIVES_RAD, D3
            ADD.W   #LIVES_RAD, D4

            MOVE.L  #88, D0
            TRAP    #15

            MOVEM.L (A7)+,D0/D4/D5
            RTS
;_____________________________________________________________________________



*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
