;_____________________________________________________________________________
;___TURRET.X68________________________________________________________________
;_____________________________________________________________________________



;=============================================================================
TURRET_PLOT
; PLOTING THE TURRET
; INPUT:    D5.W: X POSITION
;           D6.W: Y POSITION
;           D7.W: TURRET DIRECTION (0:UP / 1: DOWN / 2: LEFT / 3: RIGHT)
; OUTPUT:   NONE
; MODIFIES: D6
;=============================================================================
            MOVEM.L D0-D4,-(A7)

            MOVE.L  #$00000000,D1
            MOVE.B  #80,D0
            TRAP    #15
            MOVE.L  #TURRET_BASE_COL,D1
            MOVE.B  #81,D0
            TRAP    #15
    
            MOVE.L D5,D1
            MOVE.L D6,D2
            MOVE.L D5,D3
            MOVE.L D6,D4
    
            ; DRAW BASE: (SQUARE)
            SUB.L   #TURRET_SIZE_EXT, D1
            SUB.L   #TURRET_SIZE_EXT, D2
            ADD.L   #TURRET_SIZE_EXT, D3
            ADD.L   #TURRET_SIZE_EXT, D4  
            MOVE.B  #87,D0
            TRAP    #15
    
            MOVE.L  #$00000000,D1
            MOVE.B  #80,D0
            TRAP    #15
            MOVE.L  #TURRET_SUPE_COL,D1
            MOVE.B  #81,D0
            TRAP    #15
    
            MOVE.L D5,D1
            MOVE.L D6,D2
            MOVE.L D5,D3
            MOVE.L D6,D4

            ; DRAW CIRCLE:
            SUB.L   #TURRET_SIZE_INT, D1
            SUB.L   #TURRET_SIZE_INT, D2
            ADD.L   #TURRET_SIZE_INT, D3
            ADD.L   #TURRET_SIZE_INT, D4

            MOVE.B  #88,D0
            TRAP    #15
            ; DEPENDS OF DIRECTION
            CMP.W #0,D7
            BEQ .UP
            CMP.W #1,D7
            BEQ .DOWN
            CMP.W #2,D7
            BEQ .LEFT
            CMP.W #3,D7
            BEQ .RIGHT
    
            ILLEGAL
    
   .UP:
            SUB.W #TURRET_SIZE_INT,D6
            SUB.W #CANON_HEIGH,D6
            MOVE.L  #$00000000,D1   
            MOVE.B  #80,D0
            TRAP    #15
            MOVE.L  #TURRET_BASE_COL,D1
            MOVE.B  #81,D0
            TRAP    #15
            MOVE.L D5,D1
            MOVE.L D6,D2
            MOVE.L D5,D3
            MOVE.L D6,D4
            ADD.L   #CANON_WIDTH, D1
            ADD.L   #CANON_HEIGH, D2
            SUB.L   #CANON_WIDTH, D3
            SUB.L   #CANON_HEIGH, D4  
            MOVE.B  #87,D0
            TRAP    #15
            BRA .RET
            
   .LEFT:
            SUB.W #TURRET_SIZE_INT,D5
            SUB.W #CANON_HEIGH,D5
            MOVE.L  #$00000000,D1   
            MOVE.B  #80,D0
            TRAP    #15
            MOVE.L  #TURRET_BASE_COL,D1
            MOVE.B  #81,D0
            TRAP    #15
            MOVE.L D5,D1
            MOVE.L D6,D2
            MOVE.L D5,D3
            MOVE.L D6,D4
            ADD.L   #CANON_HEIGH, D1
            ADD.L   #CANON_WIDTH, D2
            SUB.L   #CANON_HEIGH, D3
            SUB.L   #CANON_WIDTH, D4  
            MOVE.B  #87,D0
            TRAP    #15
            BRA .RET
   .RIGHT:
            ADD.W #TURRET_SIZE_INT,D5
            ADD.W #CANON_HEIGH,D5
            MOVE.L  #$00000000,D1   
            MOVE.B  #80,D0
            TRAP    #15
            MOVE.L  #TURRET_BASE_COL,D1
            MOVE.B  #81,D0
            TRAP    #15
            MOVE.L D5,D1
            MOVE.L D6,D2
            MOVE.L D5,D3
            MOVE.L D6,D4
            SUB.L   #CANON_HEIGH, D1
            SUB.L   #CANON_WIDTH, D2
            ADD.L   #CANON_HEIGH, D3
            ADD.L   #CANON_WIDTH, D4  
            MOVE.B  #87,D0 ; DRAW SQUARE
            TRAP    #15
            BRA .RET
   .DOWN:
            ADD.W #TURRET_SIZE_INT,D6
            ADD.W #CANON_HEIGH,D6
            MOVE.L  #$00000000,D1   
            MOVE.B  #80,D0
            TRAP    #15
            MOVE.L  #TURRET_BASE_COL,D1
            MOVE.B  #81,D0
            TRAP    #15
            MOVE.L D5,D1
            MOVE.L D6,D2
            MOVE.L D5,D3
            MOVE.L D6,D4
            SUB.L   #CANON_WIDTH, D1
            SUB.L   #CANON_HEIGH, D2
            ADD.L   #CANON_WIDTH, D3
            ADD.L   #CANON_HEIGH, D4  
            MOVE.B  #87,D0 ; DRAW SQUARE
            TRAP    #15
            BRA .RET
   .RET:
            MOVEM.L (A7)+,D0-D4
            RTS
;_____________________________________________________________________________
    
;=============================================================================
RT_CURRENT_TURR
; INPUT:    NONE
; OUTPUT:   A1: TMn_POS_X
;           A2: TMn_POS_Y
;           A3: TMn_DIR
;           n IS THE CURRENT MAP
; MODIFIES: A1/A2/A3
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
            LEA TM1_POS_X,A1
            LEA TM1_POS_Y,A2
            LEA TM1_DIR,A3
            BRA .EXIT
    
   .MAP2:
            LEA TM2_POS_X,A1
            LEA TM2_POS_Y,A2
            LEA TM2_DIR,A3
            BRA .EXIT
    
   .MAP3:
            LEA TM3_POS_X,A1
            LEA TM3_POS_Y,A2
            LEA TM3_DIR,A3
            BRA .EXIT
   .MAP4:
            LEA TM4_POS_X,A1
            LEA TM4_POS_Y,A2
            LEA TM4_DIR,A3
            BRA .EXIT
            
   .MAP5:
            LEA TM5_POS_X,A1
            LEA TM5_POS_Y,A2
            LEA TM5_DIR,A3
            BRA .EXIT
            
   .MAP6:
            LEA TM6_POS_X,A1
            LEA TM6_POS_Y,A2
            LEA TM6_DIR,A3
            BRA .EXIT
            
   .MAP7:
            LEA TM7_POS_X,A1
            LEA TM7_POS_Y,A2
            LEA TM7_DIR,A3
            BRA .EXIT
            
   .MAP8:
            LEA TM8_POS_X,A1
            LEA TM8_POS_Y,A2
            LEA TM8_DIR,A3
            BRA .EXIT
            
   .MAP9:
            LEA TM9_POS_X,A1
            LEA TM9_POS_Y,A2
            LEA TM9_DIR,A3
            BRA .EXIT
    
   .EXIT:
            RTS
;_____________________________________________________________________________

    
;=============================================================================
CURRENT_TURRET
; PLOTS ALL THE TURRET OF THE MAP
; INPUT:    NONE
; OUTPUT:   NONE
; MODIFIES: NONE
;=============================================================================
            MOVEM.L D1/D5/D6/D7/A1/A2/A3,-(A7)
            
            JSR RT_CURRENT_TURR
            
            MOVE.W #TURRET_NUM-1,D1
                
   .LOOP:   MOVE.W (A1)+,D5
            MOVE.W (A2)+,D6
            MOVE.W (A3)+,D7
            JSR TURRET_PLOT
            DBRA D1,.LOOP
            
            MOVEM.L (A7)+,D1/D5/D6/D7/A1/A2/A3
            RTS
;_____________________________________________________________________________








*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
