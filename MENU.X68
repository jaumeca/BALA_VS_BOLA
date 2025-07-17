;_____________________________________________________________________________
;___MENU.X68__________________________________________________________________
;_____________________________________________________________________________

;=============================================================================
PLOT_MENU
; PLOT THE GAME MENU
; INPUT:    NONE
; OUTPUT:   NONE
; MODIFIES: NONE
;=============================================================================
            MOVEM.L D0/A0,-(A7)
            
            ; PLOT THE TITLE:
            MOVE.B #80,D0
            MOVE.L #$00FFFFFF,D1            ; WHITE COLOR
            TRAP #15
            
            MOVE.L  #$00000000,D1           ; BLACK COLOR
            MOVE.B  #81,D0
            TRAP    #15
            
            MOVE.L  #$0000FF00,D1
            MOVE.B  #21,D0
            TRAP    #15
            LEA .TITLE,A0
            MOVE.W #7,D0
            JSR TXT
            
            ; PLOT BUTTONS:
            JSR     START_BUT
            JSR     HELP_BUT
            JSR     SETT_BUT
            JSR     EXIT_BUT
            
            
            MOVEM.L (A7)+,D0/A0
            RTS
            
.TITLE:     DC.W    'BALA vs BOLA',0               
;_____________________________________________________________________________

;=============================================================================
TXT
; PLOT TEXT CENTERED ON THE SCREEN
; INPUT:     A0 POINTER TO ZERO-TERMINATED STRING
;           (D0) SCREEN ROW TO PRINT TEXT
; OUTPUT:   NONE
; MODIFIES: NONE
;=============================================================================
            MOVEM.L D0/D1/A0/A1,-(A7)
            
            CLR.B   D1
            
            MOVE.L  A0,A1
.LOOP       TST.B   (A0)+
            BEQ     .ENDLOOP
            ADDQ.B  #1,D1
            BRA     .LOOP
.ENDLOOP    LSR.B   #1,D1
            SUB.B   #(SCRWIDTH/8)/2,D1
            NEG.B   D1
            ASL.W   #8,D1
            OR.W    D0,D1
            MOVE.B  #11,D0
            TRAP    #15
            MOVE.B  #13,D0
            TRAP    #15
            MOVEM.L (A7)+,D0-D1/A0-A1
            
            RTS
;_____________________________________________________________________________

;=============================================================================
START_BUT
; PLOTTING THE START BUTTON
; INPUT     : NONE
; OUTPUT    : NONE
; MODIFIES  : NONE
;=============================================================================
            MOVEM.L D0-D4/A0,-(A7)
                        
            MOVE.B #80,D0
            MOVE.L #$00FFFFFF,D1            ; WHITE COLOR
            TRAP #15
            
            MOVE.L  #$00000000,D1           ; BLACK COLOR
            MOVE.B  #81,D0
            TRAP    #15
            
            MOVE.L  #$0000FF00,D1
            MOVE.B  #21,D0
            TRAP    #15
                        
            MOVE.W  #(SCRWIDTH+90)/2,D1     
            MOVE.W  #(SCRWIDTH-200)/2,D2
            MOVE.W  #(SCRHEIGH+80)/2,D3
            MOVE.W  #(SCRHEIGH-110)/2,D4
            
            MOVEM.L D1-D4,-(A7)             ; SAVE RECTAGLE POSITION
            
            ; CHECKING THE MOUSE POSITION
            CMP.W   (MOUSE_Y),D2                
            BLT     .OUT                       
            CMP.W   (MOUSE_Y),D4
            BGT     .OUT
            CMP.W   (MOUSE_X),D1
            BLT     .OUT
            CMP.W   (MOUSE_X),D3
            BGT     .OUT
            
            ; INSIDE:
            
            CLR.L   D2     
                     
            MOVE.L  #$0000000000,D1
            MOVE.B  #21,D0
            TRAP    #15
            
            MOVE.L  #$00FFFFFF,D1
            MOVE.B  #81,D0
            TRAP    #15
            
            MOVE.W  (MOUSE_L),D0
            CMP.W   #0,D0
            BEQ     .OUT
            MOVE.W  #1,(GAME)  
            BRA     .OUT              
   .OUT:         
            MOVEM.L (A7)+,D1-D4             ; RESTORE RECTAGLE POSITION
            MOVE.B  #87,D0
            TRAP    #15
                        
            LEA     .START_TXT,A0                 
            MOVE.B  #13,D0
            JSR     TXT
            
            MOVEM.L (A7)+,D0-D4/A0

            RTS
            
.START_TXT    DC.B    'START',0
              DS.W     0
;_____________________________________________________________________________


;=============================================================================
SETT_BUT
; PLOTTING THE SETTINGS BUTTON
; INPUT     : NONE
; OUTPUT    : NONE
; MODIFIES  : NONE
;=============================================================================
            MOVEM.L D0-D4/A0,-(A7)
            
            MOVE.L  #$000099FF33,D1         ; TEXT COLOR
            MOVE.B  #21,D0
            TRAP    #15
                        
            MOVE.B #80,D0
            MOVE.L #$00FFFFFF,D1            ; WHITE COLOR
            TRAP #15
            
            MOVE.L  #$00000000,D1           ; BLACK COLOR
            MOVE.B  #81,D0
            TRAP    #15
                        
            MOVE.W  #(SCRWIDTH+90)/2,D1     
            MOVE.W  #(SCRWIDTH-110)/2,D2 
            MOVE.W  #(SCRHEIGH+80)/2,D3 
            MOVE.W  #(SCRHEIGH-20)/2,D4
            
            MOVEM.L D1-D4,-(A7)             ; SAVE RECTAGLE POSITION
            
            ; CHECKING THE MOUSE POSITION
            CMP.W   (MOUSE_Y),D2                
            BLT     .OUT                       
            CMP.W   (MOUSE_Y),D4
            BGT     .OUT
            CMP.W   (MOUSE_X),D1
            BLT     .OUT
            CMP.W   (MOUSE_X),D3
            BGT     .OUT
            
            ; INSIDE:
            
            CLR.L   D2     
                     
            MOVE.L  #$0000000000,D1
            MOVE.B  #21,D0
            TRAP    #15
            
            MOVE.L  #$00FFFFFF,D1
            MOVE.B  #81,D0
            TRAP    #15
            
            MOVE.W  (MOUSE_L),D0
            CMP.W   #0,D0
            BEQ     .OUT
            MOVE.W  #1,(SETT)
            BRA     .OUT              
   .OUT:         
            MOVEM.L (A7)+,D1-D4             ; RESTORE RECTAGLE POSITION
            MOVE.B  #87,D0
            TRAP    #15
                        
            LEA     .SETT_TXT,A0                 
            MOVE.B  #16,D0
            JSR     TXT
            
            MOVEM.L (A7)+,D0-D4/A0

            RTS
            
.SETT_TXT    DC.B    'SETTINGS',0
              DS.W     0
;_____________________________________________________________________________


;=============================================================================
HELP_BUT
; PLOTTING THE HELP BUTTON
; INPUT     : NONE
; OUTPUT    : NONE
; MODIFIES  : NONE
;=============================================================================
            MOVEM.L D0-D4/A0,-(A7)
            
            MOVE.L  #$0000FF8000,D1         ; TEXT COLOR
            MOVE.B  #21,D0
            TRAP    #15
                        
            MOVE.B #80,D0
            MOVE.L #$00FFFFFF,D1            ; WHITE COLOR
            TRAP #15
            
            MOVE.L  #$00000000,D1           ; BLACK COLOR
            MOVE.B  #81,D0
            TRAP    #15
                        
            MOVE.W  #(SCRWIDTH+90)/2,D1     
            MOVE.W  #(SCRWIDTH-20)/2,D2 
            MOVE.W  #(SCRHEIGH+80)/2,D3 
            MOVE.W  #(SCRHEIGH+70)/2,D4
            
            MOVEM.L D1-D4,-(A7)             ; SAVE RECTAGLE POSITION
            
            ; CHECKING THE MOUSE POSITION
            CMP.W   (MOUSE_Y),D2                
            BLT     .OUT                       
            CMP.W   (MOUSE_Y),D4
            BGT     .OUT
            CMP.W   (MOUSE_X),D1
            BLT     .OUT
            CMP.W   (MOUSE_X),D3
            BGT     .OUT
            
            ; INSIDE:
            
            CLR.L   D2     
                     
            MOVE.L  #$0000000000,D1
            MOVE.B  #21,D0
            TRAP    #15
            
            MOVE.L  #$00FFFFFF,D1
            MOVE.B  #81,D0
            TRAP    #15
            
            MOVE.W  (MOUSE_L),D0
            CMP.W   #0,D0
            BEQ     .OUT
            MOVE.W #1,(HELP)  
            BRA     .OUT              
   .OUT:         
            MOVEM.L (A7)+,D1-D4             ; RESTORE RECTAGLE POSITION
            MOVE.B  #87,D0
            TRAP    #15
                        
            LEA     .HELP_TXT,A0                 
            MOVE.B  #19,D0
            JSR     TXT
            
            MOVEM.L (A7)+,D0-D4/A0

            RTS
            
.HELP_TXT    DC.B    'HELP',0
             DS.W     0
;_____________________________________________________________________________

;=============================================================================
EXIT_BUT
; PLOTTING THE HELP BUTTON
; INPUT     : NONE
; OUTPUT    : NONE
; MODIFIES  : NONE
;=============================================================================
            MOVEM.L D0-D4/A0,-(A7)
            
            MOVE.L  #$0000FFFFFF,D1         ; TEXT COLOR
            MOVE.B  #21,D0
            TRAP    #15
                        
            MOVE.B #80,D0
            MOVE.L #$00FFFFFF,D1            ; WHITE COLOR
            TRAP    #15
            
            MOVE.L  #$00000000,D1           ; BLACK COLOR
            MOVE.B  #81,D0
            TRAP    #15
                        
            MOVE.W  #(SCRWIDTH+90)/2,D1     
            MOVE.W  #(SCRWIDTH+70)/2,D2 
            MOVE.W  #(SCRHEIGH+80)/2,D3 
            MOVE.W  #(SCRHEIGH+160)/2,D4
            
            MOVEM.L D1-D4,-(A7)             ; SAVE RECTAGLE POSITION
            
            ; CHECKING THE MOUSE POSITION
            CMP.W   (MOUSE_Y),D2                
            BLT     .END2                      
            CMP.W   (MOUSE_Y),D4
            BGT     .END2
            CMP.W   (MOUSE_X),D1
            BLT     .END2
            CMP.W   (MOUSE_X),D3
            BGT     .END2
            
            ; INSIDE:
            
            CLR.L   D2     
                     
            MOVE.L  #$0000000000,D1
            MOVE.B  #21,D0
            TRAP    #15
            
            MOVE.L  #$00FFFFFF,D1
            MOVE.B  #81,D0
            TRAP    #15
            
            MOVE.W  (MOUSE_L),D0
            CMP.W   #0,D0
            BEQ     .END2
            SIMHALT                         ; FINISH EXECUTION
            BRA     .END2             
   .END2:         
            MOVEM.L (A7)+,D1-D4             ; RESTORE RECTAGLE POSITION
            MOVE.B  #87,D0
            TRAP    #15
                        
            LEA     .EXIT_TXT,A0                 
            MOVE.B  #22,D0
            JSR     TXT
            
            MOVEM.L (A7)+,D0-D4/A0

            RTS
            
.EXIT_TXT    DC.B    'EXIT',0
             DS.W     0
;_____________________________________________________________________________


;=============================================================================
HELP_MENU
; PLOTTING THE HELP TEXT AND BUTTON TO RETURN
; INPUT:    NONE
; OUTPUT:   NONE
; MODIFIES: NONE
;=============================================================================
            
            MOVEM.L D0-D4/A0,-(A7)
            
            JSR     SQRMENU
            
           ; HELP TEXT:
            MOVE.L  #$00009898FF,D1
            MOVE.B  #21,D0
            TRAP    #15
            
            LEA     .HELP1_TXT,A0                 
            MOVE.B  #4,D0
            JSR     TXT
            
            MOVE.L  #$00009808FF,D1
            MOVE.B  #21,D0
            TRAP    #15
            
            LEA     .HELP2_TXT,A0                 
            MOVE.B  #12,D0
            JSR     TXT
            
            LEA     .HELP3_TXT,A0                 
            MOVE.B  #14,D0
            JSR     TXT
            
            LEA     .HELP4_TXT,A0                 
            MOVE.B  #16,D0
            JSR     TXT
            
            LEA     .HELP5_TXT,A0                 
            MOVE.B  #18,D0
            JSR     TXT
            
            ;_________END HELP TEXT;
            
            MOVE.L  #$00002828FF,D1         ; TEXT COLOR
            MOVE.B  #21,D0
            TRAP    #15
                        
            MOVE.B #80,D0
            MOVE.L #$00FFFFFF,D1            ; WHITE COLOR
            TRAP #15
            
            MOVE.L  #$00000000,D1           ; BLACK COLOR
            MOVE.B  #81,D0
            TRAP    #15
                        
            MOVE.W  #(SCRWIDTH+90)/2,D1     
            MOVE.W  #(SCRWIDTH+160)/2,D2 
            MOVE.W  #(SCRHEIGH+80)/2,D3 
            MOVE.W  #(SCRHEIGH+250)/2,D4
            
            MOVEM.L D1-D4,-(A7)             ; SAVE RECTAGLE POSITION
            
            ; CHECKING THE MOUSE POSITION
            CMP.W   (MOUSE_Y),D2                
            BLT     .OUT                       
            CMP.W   (MOUSE_Y),D4
            BGT     .OUT
            CMP.W   (MOUSE_X),D1
            BLT     .OUT
            CMP.W   (MOUSE_X),D3
            BGT     .OUT
            
            
            ; INSIDE:
            
            CLR.L   D2     
                     
            MOVE.L  #$0000000000,D1
            MOVE.B  #21,D0
            TRAP    #15
            
            MOVE.L  #$00FFFFFF,D1
            MOVE.B  #81,D0
            TRAP    #15
            
            MOVE.W  (MOUSE_L),D0
            CMP.W   #0,D0
            BEQ     .OUT
            MOVE.W #0,(HELP)  
            BRA     .OUT              
   .OUT:         
            MOVEM.L (A7)+,D1-D4             ; RESTORE RECTAGLE POSITION
            MOVE.B  #87,D0
            TRAP    #15
                        
            LEA     .BACK_TXT,A0                 
            MOVE.B  #25,D0
            JSR     TXT
            
            MOVEM.L (A7)+,D0-D4/A0

            
            RTS
            
.BACK_TXT    DC.B    'BACK',0
.HELP1_TXT   DC.B    'THIS VIDEOGAME WAS CREATED BY JAUME CARDELL & MARTÍ VICH.',0
.HELP2_TXT   DC.B    'THE PURPOSE OF TGE GAME IS COLLECT ALL THE COINS AND DODGE BULLETS.',0
.HELP3_TXT   DC.B    'TO MOVE YOUR PLAYER YOU CAN CHOOSE WASD KEYS OR ARROWS.',0
.HELP4_TXT   DC.B    'YOU CAN LEAVE THE GAME PRESSING "R" AT ANY MOMENT.',0
.HELP5_TXT   DC.B    'HAVE FUN!',0
             DS.W     0            
            
;_____________________________________________________________________________

;=============================================================================
SQRMENU
; PLOTTING THE BORDERS ON THE SCREEN IN THE HELP AND SETTING MENU.
; INPUT:    NONE
; OUTPUT:   NONE
; MODIFIES: NONE
;=============================================================================
            MOVEM.L D0-D4,-(A7)
            
            MOVE.L  #$0000000000,D1
            MOVE.B  #81,D0
            TRAP    #15
            
            MOVE.L  #$00FFFFFF,D1
            MOVE.B  #80,D0
            TRAP    #15
            
            MOVE.W  #30,D1     
            MOVE.W  #30,D2 
            MOVE.W  #(SCRWIDTH-30),D3 
            MOVE.W  #(SCRHEIGH-50),D4
            
            MOVE.B  #87,D0
            TRAP    #15
            
            MOVEM.L (A7)+,D0-D4
            RTS
;_____________________________________________________________________________

;=============================================================================
SETT_MENU
; PLOTTING THE SETTING AND BUTTON TO RETURN
; INPUT:    NONE
; OUTPUT:   NONE
; MODIFIES: NONE
;=============================================================================
            
            MOVEM.L D0-D4/A0,-(A7)
            
            JSR     SQRMENU
            
            MOVE.L  #$0000FFFFFF,D1         ; TEXT COLOR
            MOVE.B  #21,D0
            TRAP    #15
            
            ; CHANGE PLAYER COLOR:            
            MOVE.L  #$0000000000,D1
            MOVE.B  #81,D0
            TRAP    #15
            
            MOVE.L  #$00FFFFFF,D1
            MOVE.B  #80,D0
            TRAP    #15
            
            MOVE.W  #60,D1     
            MOVE.W  #60,D2 
            MOVE.W  #(SCRWIDTH-60),D3 
            MOVE.W  #(SCRHEIGH-300),D4
            
            MOVE.B  #87,D0
            TRAP    #15
            
            MOVE.W  #80,D1     
            MOVE.W  #80,D2 
            MOVE.W  #(80+80),D3 
            MOVE.W  #(80+80),D4
            
            MOVE.B  #87,D0
            TRAP    #15
            
            LEA     .PLYCOL_TXT,A0                 
            MOVE.B  #3,D0
            JSR     TXT
            
                        
            LEA     .PLYCON_TXT,A0                 
            MOVE.B  #15,D0
            JSR     TXT
            
            LEA     .SPLIT_TXT,A0
            MOVE.B  #13,D0
            JSR     TXT
               
            MOVE.L  #120,D1
            MOVE.L  #120,D2
            MOVE.L  (PLAYER_C),D0
            JSR CENTERED_BALL
            
            ; FIRST OPTION
            MOVE.B  #80,D0
            MOVE.L  #$00FFFFFF,D1           ; WHITE COLOR
            TRAP    #15
            MOVE.L  #$00000000,D1           ; BLACK COLOR
            MOVE.B  #81,D0
            TRAP    #15
            
            MOVE.W  #250,D1     
            MOVE.W  #80,D2 
            MOVE.W  #(250+80),D3 
            MOVE.W  #(80+80),D4
            
            MOVEM.W D1-D4,-(A7)             ; SAVE RECTAGLE POSITION
            ; CHECKING THE MOUSE POSITION
            CMP.W   (MOUSE_Y),D4               
            BLT     .SAL1                      
            CMP.W   (MOUSE_Y),D2
            BGT     .SAL1
            CMP.W   (MOUSE_X),D3
            BLT     .SAL1
            CMP.W   (MOUSE_X),D1
            BGT     .SAL1
            ; INSIDE:
            CLR.L   D2
            MOVE.L  #$00FF0000,D1
            MOVE.B  #80,D0
            TRAP    #15
            MOVE.W  (MOUSE_L),D0
            CMP.W   #0,D0
            BEQ     .SAL1
            MOVE.L  #FIRST_COLOR,(PLAYER_C)  
            BRA     .SAL1
   .SAL1:  
            MOVEM.W (A7)+,D1-D4             ; RESTORE RECTAGLE POSITION
            MOVE.B  #87,D0
            TRAP    #15

            MOVE.L  #290,D1
            MOVE.L  #120,D2
            MOVE.L  #FIRST_COLOR,D0
            JSR CENTERED_BALL
            
            
            ; SECOND OPTION
            MOVE.B  #80,D0
            MOVE.L  #$00FFFFFF,D1           ; WHITE COLOR
            TRAP    #15
            MOVE.L  #$00000000,D1           ; BLACK COLOR
            MOVE.B  #81,D0
            TRAP    #15
            
            MOVE.W  #350,D1     
            MOVE.W  #80,D2 
            MOVE.W  #(350+80),D3 
            MOVE.W  #(80+80),D4
            
            MOVEM.W D1-D4,-(A7)             ; SAVE RECTAGLE POSITION
            ; CHECKING THE MOUSE POSITION
            CMP.W   (MOUSE_Y),D4               
            BLT     .SAL2                      
            CMP.W   (MOUSE_Y),D2
            BGT     .SAL2
            CMP.W   (MOUSE_X),D3
            BLT     .SAL2
            CMP.W   (MOUSE_X),D1
            BGT     .SAL2
            ; INSIDE:
            CLR.L   D2
            MOVE.L  #$00FF0000,D1
            MOVE.B  #80,D0
            TRAP    #15
            MOVE.W  (MOUSE_L),D0
            CMP.W   #0,D0
            BEQ     .SAL2
            MOVE.L  #SECOND_COLOR,(PLAYER_C)  
            BRA     .SAL2
   .SAL2:  
            MOVEM.W (A7)+,D1-D4             ; RESTORE RECTAGLE POSITION
            MOVE.B  #87,D0
            TRAP    #15

            MOVE.L  #390,D1
            MOVE.L  #120,D2
            MOVE.L  #SECOND_COLOR,D0
            JSR CENTERED_BALL

            ; THIRD OPTION
            MOVE.B  #80,D0
            MOVE.L  #$00FFFFFF,D1           ; WHITE COLOR
            TRAP    #15
            MOVE.L  #$00000000,D1           ; BLACK COLOR
            MOVE.B  #81,D0
            TRAP    #15
            
            MOVE.W  #450,D1     
            MOVE.W  #80,D2 
            MOVE.W  #(450+80),D3 
            MOVE.W  #(80+80),D4
            
            MOVEM.W D1-D4,-(A7)             ; SAVE RECTAGLE POSITION
            ; CHECKING THE MOUSE POSITION
            CMP.W   (MOUSE_Y),D4               
            BLT     .SAL3                     
            CMP.W   (MOUSE_Y),D2
            BGT     .SAL3
            CMP.W   (MOUSE_X),D3
            BLT     .SAL3
            CMP.W   (MOUSE_X),D1
            BGT     .SAL3
            ; INSIDE:
            CLR.L   D2
            MOVE.L  #$00FF0000,D1
            MOVE.B  #80,D0
            TRAP    #15
            MOVE.W  (MOUSE_L),D0
            CMP.W   #0,D0
            BEQ     .SAL3
            MOVE.L  #THIRD_COLOR,(PLAYER_C)  
            BRA     .SAL3
   .SAL3:  
            MOVEM.W (A7)+,D1-D4             ; RESTORE RECTAGLE POSITION
            MOVE.B  #87,D0
            TRAP    #15

            MOVE.L  #490,D1
            MOVE.L  #120,D2
            MOVE.L  #THIRD_COLOR,D0
            JSR CENTERED_BALL

            
            
            ; BACK BUTTON:   
            MOVE.B  #80,D0
            MOVE.L  #$00FFFFFF,D1           ; WHITE COLOR
            TRAP    #15
            MOVE.L  #$00000000,D1           ; BLACK COLOR
            MOVE.B  #81,D0
            TRAP    #15
            MOVE.L  #$00002828FF,D1         ; TEXT COLOR
            MOVE.B  #21,D0
            TRAP    #15      
            MOVE.W  #(SCRWIDTH+90)/2,D1     
            MOVE.W  #(SCRWIDTH+160)/2,D2 
            MOVE.W  #(SCRHEIGH+80)/2,D3 
            MOVE.W  #(SCRHEIGH+250)/2,D4   
            MOVEM.L D1-D4,-(A7)             ; SAVE RECTAGLE POSITION
            ; CHECKING THE MOUSE POSITION
            CMP.W   (MOUSE_Y),D2                
            BLT     .OUT                       
            CMP.W   (MOUSE_Y),D4
            BGT     .OUT
            CMP.W   (MOUSE_X),D1
            BLT     .OUT
            CMP.W   (MOUSE_X),D3
            BGT     .OUT
            ; INSIDE:
            CLR.L   D2         
            MOVE.L  #$0000000000,D1         ; TEXT COLOR
            MOVE.B  #21,D0
            TRAP    #15
            MOVE.L  #$00FFFFFF,D1
            MOVE.B  #81,D0
            TRAP    #15
            MOVE.W  (MOUSE_L),D0
            CMP.W   #0,D0
            BEQ     .OUT
            MOVE.W  #0,(SETT)  
            BRA     .OUT              
   .OUT:         
            MOVEM.L (A7)+,D1-D4             ; RESTORE RECTAGLE POSITION
            MOVE.B  #87,D0
            TRAP    #15
    
            LEA     .BACK_TXT,A0   
            CLR.L   D0              
            MOVE.B  #25,D0
            JSR     TXT
            ; BUTTON_______________________________________
            
            MOVE.L  #$0000000000,D1
            MOVE.B  #81,D0
            TRAP    #15
            MOVE.L  #$00FFFFFF,D1
            MOVE.B  #80,D0
            TRAP    #15
            MOVE.W  #60,D1     
            MOVE.W  #(SCRHEIGH-240),D2 
            MOVE.W  #(SCRWIDTH-60),D3 
            MOVE.W  #(SCRHEIGH-130),D4
            MOVE.B  #87,D0
            TRAP    #15
            
            ; WASD BUTTON 
            MOVE.W  (KBDOPTN),D0
            CMP.W   #0,D0
            BNE     .NEG1
            MOVE.B  #81,D0
            MOVE.L  #$00FFFFFF,D1           ; WHITE COLOR
            TRAP    #15
            MOVE.L  #$00000000,D1           ; BLACK COLOR
            MOVE.B  #80,D0
            TRAP    #15 
            BRA     .BLA1
   .NEG1:   MOVE.B  #80,D0
            MOVE.L  #$00FFFFFF,D1           ; WHITE COLOR
            TRAP    #15
            MOVE.L  #$00000000,D1           ; BLACK COLOR
            MOVE.B  #81,D0
            TRAP    #15
   .BLA1:
            MOVE.L  #$00002828FF,D1         ; TEXT COLOR
            MOVE.B  #21,D0
            TRAP    #15      
            MOVE.W  #(320-40),D1     
            MOVE.W  #(250),D2 
            MOVE.W  #(320+40),D3 
            MOVE.W  #(280),D4  
            MOVEM.L D1-D4,-(A7)             ; SAVE RECTAGLE POSITION
            ; CHECKING THE MOUSE POSITION
            CMP.W   (MOUSE_Y),D4               
            BLT     .SAL4                       
            CMP.W   (MOUSE_Y),D2
            BGT     .SAL4
            CMP.W   (MOUSE_X),D3
            BLT     .SAl4
            CMP.W   (MOUSE_X),D1
            BGT     .SAl4
            ; INSIDE:
            CLR.L   D2         
            MOVE.L  #$0000000000,D1         ; TEXT COLOR
            MOVE.B  #21,D0
            TRAP    #15
            MOVE.L  #$00FF0000,D1
            MOVE.B  #80,D0
            TRAP    #15
            MOVE.W  (MOUSE_L),D0
            CMP.W   #0,D0
            BEQ     .SAL4
            MOVE.W  #0,(KBDOPTN)  
            BRA     .SAl4             
   .SAL4:         
            MOVEM.L (A7)+,D1-D4             ; RESTORE RECTAGLE POSITION
            MOVE.B  #87,D0
            TRAP    #15
    
            MOVE.L  #$00002828FF,D1         ; TEXT COLOR
            MOVE.B  #21,D0
            TRAP    #15  
            LEA     .WASD_TXT,A0   
            CLR.L   D0              
            MOVE.B  #17,D0
            JSR     TXT

            ; ARROWS BUTTON 
            MOVE.W  (KBDOPTN),D0
            CMP.W   #0,D0
            BEQ     .NEG2
            MOVE.B  #81,D0
            MOVE.L  #$00FFFFFF,D1           ; WHITE COLOR
            TRAP    #15
            MOVE.L  #$00000000,D1           ; BLACK COLOR
            MOVE.B  #80,D0
            TRAP    #15 
            BRA     .BLA2
   .NEG2:   MOVE.B  #80,D0
            MOVE.L  #$00FFFFFF,D1           ; WHITE COLOR
            TRAP    #15
            MOVE.L  #$00000000,D1           ; BLACK COLOR
            MOVE.B  #81,D0
            TRAP    #15
   .BLA2:
            MOVE.L  #$00002828FF,D1         ; TEXT COLOR
            MOVE.B  #21,D0
            TRAP    #15      
            MOVE.W  #(320-40),D1     
            MOVE.W  #(310),D2 
            MOVE.W  #(320+40),D3 
            MOVE.W  #(340),D4  
            MOVEM.L D1-D4,-(A7)             ; SAVE RECTAGLE POSITION
            ; CHECKING THE MOUSE POSITION
            CMP.W   (MOUSE_Y),D4               
            BLT     .SAL5                       
            CMP.W   (MOUSE_Y),D2
            BGT     .SAL5
            CMP.W   (MOUSE_X),D3
            BLT     .SAL5
            CMP.W   (MOUSE_X),D1
            BGT     .SAl5
            ; INSIDE:
            CLR.L   D2         
            MOVE.L  #$0000000000,D1         ; TEXT COLOR
            MOVE.B  #21,D0
            TRAP    #15
            MOVE.L  #$00FF0000,D1
            MOVE.B  #80,D0
            TRAP    #15
            MOVE.W  (MOUSE_L),D0
            CMP.W   #0,D0
            BEQ     .SAL5
            MOVE.W  #1,(KBDOPTN)  
            BRA     .SAL5             
   .SAL5:         
            MOVEM.L (A7)+,D1-D4             ; RESTORE RECTAGLE POSITION
            MOVE.B  #87,D0
            TRAP    #15
    
            MOVE.L  #$00002828FF,D1         ; TEXT COLOR
            MOVE.B  #21,D0
            TRAP    #15  
            LEA     .ARROWS_TXT,A0   
            CLR.L   D0              
            MOVE.B  #21,D0
            JSR     TXT

            
            MOVEM.L (A7)+,D0-D4/A0
            RTS
            
.PLYCOL_TXT  DC.B    'SELECT PLAYER COLOR:',0
             DS.W     0    
             
.PLYCON_TXT  DC.B    'SELECT KEY CONFIGURATION:',0
             DS.W     0    
             
.SPLIT_TXT   DC.B    '---------------------',0
             DS.W     0    
            
.BACK_TXT    DC.B    'BACK',0
             DS.W     0            
            
.WASD_TXT    DC.B    'WASD',0
             DS.W     0     
.ARROWS_TXT  DC.B    'ARROWS',0
             DS.W     0     
;_____________________________________________________________________________

;=============================================================================
CENTERED_BALL
; PLOT A CENTERED BALL 25 SIZE
; INPUT:    D0: COLOR 00BBGGRR
;           D1: X POSITION
;           D2: Y POSITION
; OUTPUT:   NONE
; MODIFIES: NONE
;=============================================================================
            MOVEM.L D0/D1/D2/D3/D4/D5,-(A7)
            
            MOVE.L  D1,D5
            
            MOVE.L  D0,D1                   ; SET COLOR
            MOVE.B  #81,D0                  ; DEFINE FILL COLOR
            TRAP    #15
            
            MOVE.L  D5,D1
            
            MOVE.W  D1,D3
            ADD.W   #25,D3
            MOVE.W  D2,D4
            ADD.W   #25,D4
            SUB.W   #25,D1
            SUB.W   #25,D2
            
            MOVE.B  #88,D0                  ; DRAW CIRCLE
            TRAP    #15
            MOVEM.L (A7)+,D0/D1/D2/D3/D4/D5
            RTS
;_____________________________________________________________________________

















*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
