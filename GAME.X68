;_____________________________________________________________________________     
;___GAME.X68__________________________________________________________________     
;_____________________________________________________________________________     

;=============================================================================
GAME_INIT
; INITIALIZES GAME.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
;=============================================================================
            MOVE.B #INIT_MAP,(CURRENT_MAP)
            MOVE.W #INIT_COINS,(POINTS)  
            MOVE.W #INIT_LIVES,(LIVES)
            CMP.W   #1,(ENDG)
            BEQ     .NOINIT
            MOVE.W  #0,(LOOSEGAME)
   .NOINIT: JSR PLAYER_INIT  
            JSR COINS_INIT

            RTS   
;_____________________________________________________________________________        

;=============================================================================
GAME_UPD
; UPDATES THE GAME
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
;=============================================================================
            JSR GAME_CHECK
            TRAP    #KBDUPTN
            CMP.W   #0,(KBDR)
            BEQ     .NORESTART
            MOVE.W  #0,(ENDG)
            MOVE.W  #0,(GAME)
   .NORESTART:
            JSR     GAME_END
            CMP.W   #1,(ENDG)
            BEQ     .SAL
            JSR PLAYER_UPD        
   .SAL:
            RTS
;_____________________________________________________________________________

;=============================================================================
GAME_PLOT
; PLOTS THE GAME
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
;=============================================================================
            CMP.W   #1,(ENDG)
            BEQ     .RET
            JSR PRINTMAP                    ; PRINT MAP
            JSR CURRENT_BULL
            JSR CURRENT_TURRET
            JSR PLAYER_PLOT
            JSR CURRENT_COINS
            JSR LIVES_PLOT
            
            JSR SHOW_FPS
   .RET:
            RTS
;_____________________________________________________________________________

;=============================================================================
GAME_CHECK
; CHECK THE CURRENT LIVES AND DECIDE STOPPING OR NOT THE GAME
; INPUT:    NONE
; OUTPUT:   NONE
; MODIFIES: NONE
;=============================================================================
            MOVEM.L D0,-(A7)
            
            MOVE.W (LIVES),D0
            CMP.W   #0,D0
            BEQ .LOOSEGAME
            
            CMP.B #10,(CURRENT_MAP)
            BEQ .FINISHGAME
            BRA .END
            
   .LOOSEGAME:
            MOVE.W  #1,(LOOSEGAME)
            
   .FINISHGAME:
            MOVE.W #1,(ENDG)
            MOVE.W #0,(GAME)
            
   .END:
            MOVEM.L (A7)+,D0
            RTS
;_____________________________________________________________________________

;=============================================================================
GAME_END
; PLOT THE FINISH SCREEN WHEN YOU LOOSE OR WIN.
; INPUT:    NONE
; OUTPUT:   NONE
; MODIFIES: NONE
;=============================================================================
            MOVEM.L D0-D1/A0,-(A7)

            MOVE.W (LOOSEGAME),D0
            CMP.W   #1,D0
            BEQ .LOOSE
            BRA     .WIN
   .WIN:
            MOVE.L  #$0000000000,D1
            MOVE.B  #21,D0
            TRAP    #15
            
            MOVE.L  #$00FF0000,D1
            MOVE.B  #81,D0
            TRAP    #15
            
            LEA     .W_TXT,A0
            MOVE.W  #10,D0
            JSR TXT
            BRA     .RETOR
            
   .LOOSE:
            MOVE.L  #$0000000000,D1
            MOVE.B  #21,D0
            TRAP    #15
            
            MOVE.L  #$000000FF,D1
            MOVE.B  #81,D0
            TRAP    #15
            
            LEA     .L_TXT,A0
            MOVE.W  #10,D0
            JSR TXT
            BRA     .RETOR
 
   .RETOR:  
            MOVE.L  #$0000000000,D1
            MOVE.B  #21,D0
            TRAP    #15
            
            MOVE.L  #$000000FF,D1
            MOVE.B  #81,D0
            TRAP    #15
            
            LEA     .BACK_TXT,A0
            MOVE.W  #20,D0
            JSR TXT
            
            TRAP    #KBDUPTN
            
            MOVE.W  (MOUSE_L),D0
            CMP.W   #0,D0
   
            MOVEM.L (A7)+,D0-D1/A0
            RTS
            
            
.L_TXT      DC.B    'GAME OVER',0
.W_TXT      DC.B    'VICTORY ROYALE!',0
.BACK_TXT   DC.B    'PRESS "R" TO RETURN TO THE MENU',0
            DS.W    0
;_____________________________________________________________________________


















*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
