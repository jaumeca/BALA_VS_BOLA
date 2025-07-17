;_____________________________________________________________________________
;__COINS.X68__________________________________________________________________
;_____________________________________________________________________________

;=============================================================================
COINS_INIT
; INPUT:    NONE
; OUTPUT:   NONE
; MODIFIES: NONE
;=============================================================================
            MOVEM.L D0/D1/A0,-(A7)
            
            MOVE.W #8,D1
            LEA     COINS_MAP_1,A0
   .LOOP2:         
            MOVE.W  #4,D0
   .LOOP:   MOVE.B  #1,(A0)+
            DBRA    D0,.LOOP
            ADDA.L  #21,A0
            DBRA    D1,.LOOP2
            
            MOVEM.L (A7)+,D0/D1/A0
            RTS
;_____________________________________________________________________________


;=============================================================================
COIN_PLOT
; INPUT:    D5: X POS 
;           D6: Y POS
; OUTPUT:   NONE
; MODIFIES: NONE
;=============================================================================

            MOVEM.L  D0-D4,-(A7)
    
            MOVE.L  #$00000000,D1
            MOVE.B  #80,D0
            TRAP    #15
            MOVE.L  #COLOR_ECOIN,D1
            MOVE.B  #81,D0
            TRAP    #15
            CLR.L D1
    
            MOVE.W D5,D1
            SUB.W #COIN_MAY,D1
            MOVE.W D6,D2
            SUB.W #COIN_MAY,D2
            MOVE.W D5,D3
            ADD.W #COIN_MAY,D3
            MOVE.W D6,D4
            ADD.W #COIN_MAY,D4
            MOVE.B  #88,D0
            TRAP    #15                     ; DRAW BIG CIRCLE
    
            MOVE.L  #$00000000,D1
            MOVE.B  #80,D0
            TRAP    #15
            MOVE.L  #COLOR_ICOIN,D1
            MOVE.B  #81,D0
            TRAP    #15
            CLR.L D1
    
            MOVE.W D5,D1
            SUB.W #COIN_MEN,D1
            MOVE.W D6,D2
            SUB.W #COIN_MEN,D2
            MOVE.W D5,D3
            ADD.W #COIN_MEN,D3
            MOVE.W D6,D4
            ADD.W #COIN_MEN,D4

            MOVE.B  #88,D0
            TRAP    #15                     ; DRAW SMALL CIRCLE
    
            MOVEM.L  (A7)+,D0-D4
            RTS
;_____________________________________________________________________________

;=============================================================================
CURRENT_COINS
; PRINT ALL THE COINS OF THE CURRENT MAP
; INPUT:    NONE
; OUTPUT:   NONE
; MODIFIES: NONE
;=============================================================================
            MOVEM.L D0/D1/D2/D3/D5/D6/A0/A1/A2,-(A7)

            JSR RT_CURRENT_COINS            ; A0 POINTS TO COINS_MAP VECTOR
                                            ; A1 POINTS TO COINS_X VECTOR
                                            ; A2 POINTS TO COINS_Y VECTOR
            MOVE.W #4,D3
            CLR.L D0
   .NEXTUP:         
            MOVE.B (A0)+,D0                 ; D0 = COIN VALUE (0 or 1)
            MOVE.W (A1)+,D5                 ; D5 = COIN X COORDINATE
            MOVE.W (A2)+,D6                 ; D6 = COIN Y COORDINATE
            CMP.B #0,D0                     ; IF D0 = 0, DONT PRINT COIN
            BEQ .NEXT

            ; CHECKING COLLISION WITH THE PLAYER:
            MOVE.W  (PLAYER_X), D0          ; D0 = PLAYER X
            MOVE.W  (PLAYER_Y), D1          ; D1 = PLAYER Y

            SUB.W   D5, D0                  ; D0 = (PLAYER X - COIN X)
            SUB.W   D6, D1                  ; D1 = (PLAYER Y - COIN Y)

            MULS    D0, D0                  ; D0 = (PLAYER X - COIN X)^2
            MULS    D1, D1                  ; D1 = (PLAYER Y - COIN Y)^2

            ADD.L   D1, D0                  ; D0 = (X DIFF)^2 + (Y DIFF)^2

            MOVE.W  #PLAYER_SIZE, D2        ; D2 = R_PLAYER
            ADD.W   #COIN_MAY, D2           ; D2 = R_PLAYER + R_COIN
            MULS    D2, D2                  ; D2 = (R_PLAYER + R_COIN)^2

            CMP.L   D2, D0
            BGT     .SIGUE                  ; If SQR DIST > SQR RAD SUM NO COL

            ; COLLISION DETECTED:
            SUBQ.L  #1,A0
            MOVE.B  #0,(A0)                 ; COIN VALUE SWITCHING TO 0
            ADDQ.L  #1,A0
            ADDQ.W #1,POINTS                ; ANOTHER POINT FOR THE PLAYER
    
   .SIGUE: 
            JSR COIN_PLOT                   ; PLOT THE COIN
   .NEXT:
            DBRA D3,.NEXTUP                 
    
            MOVEM.L (A7)+,D0/D1/D2/D3/D5/D6/A0/A1/A2
            RTS
;_____________________________________________________________________________

;=============================================================================
RT_CURRENT_COINS
; INPUT:    NONE
; OUTPUT:   A0: DIRECTION OF THE CURRENT COINS
;           A1: CMn_POS_X
;           A2: CMn_POS_Y
;            n: DEPENDS OF THE CURRENT MAP
; MODIFIES: A0 / A1 / A2
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
            LEA COINS_MAP_1,A0
            LEA CM1_POS_X,A1
            LEA CM1_POS_Y,A2
            BRA .EXIT
    
   .MAP2:
            LEA COINS_MAP_2,A0
            LEA CM2_POS_X,A1
            LEA CM2_POS_Y,A2
            BRA .EXIT
    
   .MAP3:
            LEA COINS_MAP_3,A0
            LEA CM3_POS_X,A1
            LEA CM3_POS_Y,A2
            BRA .EXIT
            
   .MAP4:
            LEA COINS_MAP_4,A0
            LEA CM4_POS_X,A1
            LEA CM4_POS_Y,A2
            BRA .EXIT
            
   .MAP5:
            LEA COINS_MAP_5,A0
            LEA CM5_POS_X,A1
            LEA CM5_POS_Y,A2
            BRA .EXIT
            
   .MAP6:
            LEA COINS_MAP_6,A0
            LEA CM6_POS_X,A1
            LEA CM6_POS_Y,A2
            BRA .EXIT
 
   .MAP7:
            LEA COINS_MAP_7,A0
            LEA CM7_POS_X,A1
            LEA CM7_POS_Y,A2
            BRA .EXIT
            
   .MAP8:
            LEA COINS_MAP_8,A0
            LEA CM8_POS_X,A1
            LEA CM8_POS_Y,A2
            BRA .EXIT
            
   .MAP9:
            LEA COINS_MAP_9,A0
            LEA CM9_POS_X,A1
            LEA CM9_POS_Y,A2
            BRA .EXIT
    
   .EXIT:
            RTS
;_____________________________________________________________________________
    
    
    
    
    
    
    









*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
