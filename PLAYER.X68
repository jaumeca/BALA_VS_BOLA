;_____________________________________________________________________________
;___PLAYER.X68________________________________________________________________
;_____________________________________________________________________________

;=============================================================================
PLAYER_INIT
; INIT OF THE MAIN CHARACTER
; INPUT:    NONE
; OUTPUT:   NONE
; MODIFIES: NONE
;=============================================================================
            MOVE.W #STARTER_X,(PLAYER_X)
            MOVE.W #STARTER_Y,(PLAYER_Y)
           
            RTS
;_____________________________________________________________________________



;=============================================================================
PLAYER_UPD
; MODIFIES THE CHARACTER POSITION CHEKING THE KEYBOARD KEYS "W" "A" "S" "D"
; INPUT:    NONE
; OUTPUT:   NONE
; MODIFIES: NONE
;=============================================================================
            MOVEM.L D0/D1/D6,-(A7)
            
            MOVE.L  (KBDVARS),D6                   ; D6.L = SS WW DD AA
            JSR PLAYER_MOVE
            JSR PLAYER_COLL
            
            MOVEM.L (A7)+,D0/D1/D6
           
            RTS
;_____________________________________________________________________________


;=============================================================================
PLAYER_PLOT
; MAIN CHARACTER PLOTTING
; INPUT:    NONE
; OUTPUT:   NONE
; MODIFIES: NONE
;=============================================================================
            MOVEM.L D0/D1/D2/D3/D4,-(A7)
            MOVE.L  #$00000000,D1           ; SET COLOR TO BLACK
            MOVE.B  #80,D0                  ; DEFINE PEN COLOR
            TRAP    #15
            MOVE.L  (PLAYER_C),D1           ; SET COLOR
            MOVE.B  #81,D0                  ; DEFINE FILL COLOR
            TRAP    #15
            CLR.L D1
            MOVE.W (PLAYER_X),D1
            SUB.W #PLAYER_SIZE,D1
            MOVE.W (PLAYER_Y),D2
            SUB.W #PLAYER_SIZE,D2
            MOVE.W (PLAYER_X),D3
            ADD.W #PLAYER_SIZE,D3
            MOVE.W (PLAYER_Y),D4
            ADD.W #PLAYER_SIZE,D4
            
            MOVE.B  #88,D0                  ; DRAW CIRCLE
            TRAP    #15
            MOVEM.L (A7)+,D0/D1/D2/D3/D4
            RTS
;_____________________________________________________________________________

;=============================================================================
PLAYER_MOVE
; MODIFIES THE PLAYER POSITION.
; INPUT:    D6.L=$SSWWDDAA.
; OUTPUT:   NONE
; MODIFIES: NONE
;=============================================================================
            BTST.L #0,D6
            BNE .MOVELEFT
            BTST.L #8,D6
            BNE .MOVERIGHT
            BTST.L #16,D6
            BNE .MOVEUP
            BTST.L #24,D6
            BNE .MOVEDOWN
            RTS
            
   .MOVEUP:
            SUB.W #SPEED_P,(PLAYER_Y)
            MOVE.W #0,(PLAYER_M)
            RTS
            
   .MOVEDOWN:  
            ADD.W #SPEED_P,(PLAYER_Y)
            MOVE.W #1,(PLAYER_M)
            RTS
            
   .MOVELEFT:
            SUB.W #SPEED_P,(PLAYER_X)
            MOVE.W #2,(PLAYER_M)
            RTS
   .MOVERIGHT:
            ADD.W #SPEED_P,(PLAYER_X)
            MOVE.W #3,(PLAYER_M)
            RTS
;_____________________________________________________________________________
            
;=============================================================================
PLAYER_COLL
; IN CHARGE OF MANAGING THE COLLISIONS WITH THE MAP
; INPUT:    NONE
; OUTPUT:   NONE
; MODIFIES: NONE
;=============================================================================
            MOVEM.L D0/D1/A2,-(A7)
            
            CLR.L D0
            CLR.L CLMPOS
            CLR.L ROWPOS
    
            JSR RT_CURRENT_MAP              ; RETURNS THE CURRENT_MAP ON A2

            MOVE.W (PLAYER_X),D0 
            ASR.W   #5, D0
            MOVE.W D0, (CLMPOS)    

            MOVE.W (PLAYER_Y),D0
            ASR.W   #5,D0
            MOVE.W D0, (ROWPOS)
    
            MULU #40,D0
            CLR.L D1
            ADD.W (CLMPOS),D1
            ASL.W #1,D1
            ADD.W D1,D0
    
            ADDA.W D0,A2
            MOVE.W (A2),D0
    
            CLR.L D1
            MOVE.W (PLAYER_M),D1            ; D1 CONTAINS PLAYERS LAST MOVE
            
            CMP.W #0,D0
            BEQ .NO_MOVE

            CMP.W #0,D1
            BEQ .COLUP
            CMP.W #1,D1
            BEQ .COLDOWN
            CMP.W #2,D1
            BEQ .COLLEFT
            CMP.W #3,D1
            BEQ .COLRIGHT
            BRA .NO_MOVE
    
    
   .COLRIGHT:
            SUB.W #SPEED_P,(PLAYER_X)
            MOVE.W #2,(PLAYER_M)
            BRA .NO_MOVE
   .COLLEFT:
            ADD.W #SPEED_P,(PLAYER_X)
            MOVE.W #3,(PLAYER_M)
            BRA .NO_MOVE
            
   .COLDOWN:
            SUB.W #SPEED_P,(PLAYER_Y)
            MOVE.W #0,(PLAYER_M)
            BRA .NO_MOVE
    
   .COLUP:
            ADD.W #SPEED_P,(PLAYER_Y)
            MOVE.W #0,(PLAYER_M)
            BRA .NO_MOVE
    
   .NO_MOVE:
            CMP.W #7,D0                     ; DOOR TO THE NEXT NAP
            BEQ .NXTMAP
            CMP.W #6,D0                     ; DOOR TO THE PREVIOUS MAP
            BEQ .PRVMAP
            BRA .RET
    
   .PRVMAP: 
            JSR PREVIOUS_MAP
            BRA .RET
    
   .NXTMAP:
            JSR NEXT_MAP
            BRA .RET
.RET
            MOVEM.L (A7)+,D0/D1/A2
            RTS
;_____________________________________________________________________________
    
;=============================================================================
SHOW_PLYPOS:
; SHOWS THE COORDENATES X AND Y OF THE PLAYER.
; USEFULL FOR THE DEVELOPMENT TASKS
; INPUT:    NONE
; OUTPUT:   NONE
; MODIFIES: NONE
;=============================================================================
            MOVEM.L D0/D1,-(A7)
    
            CLR.L D0
            CLR.L D1
    
            MOVE.B  #11, D0
            MOVE.L  #$0000, D1
            TRAP    #15 
    
            MOVE.L  #$00FFFFFF,D1
            MOVE.B  #81,D0
            TRAP    #15
    
            MOVE.B #21,D0
            MOVE.L #$00000000,D1
            TRAP    #15
    
            MOVE.B  #20, D0
            CLR.L   D1
            MOVE.W  (PLAYER_X),D1
            TRAP    #15
    
            MOVE.B #21,D0
            MOVE.L #$000000FF,D1
            TRAP    #15
    
            MOVE.B  #20, D0
            CLR.L   D1
            MOVE.W  (PLAYER_Y),D1
            TRAP    #15
    
            MOVEM.L (A7)+,D0/D1
            RTS
;_____________________________________________________________________________
































*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
