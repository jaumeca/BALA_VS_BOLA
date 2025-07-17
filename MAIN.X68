*-----------------------------------------------------------
* Title      : BALA vs BOLA
* Written by : Jaume Cardell Aguaded & Martí Vich Gispert
* Date       : Oct 24 - Jan 25
*-----------------------------------------------------------
    ORG    $1000
    
    INCLUDE "CONST.X68"
    INCLUDE "SYS_VARS.X68" 

    INCLUDE "SYSTEM.X68"
    INCLUDE "GAME.X68"
    INCLUDE "MAP.X68"
    INCLUDE "PLAYER.X68"
    INCLUDE "COINS.X68"
    INCLUDE "TURRET.X68"
    INCLUDE "BULLET.X68"
    INCLUDE "LIVES.X68"      
    INCLUDE "MENU.X68"
    
    
START:
            ORI.W   #$0700,SR               ; DISABLE INTERRUPTIONS
            
            JSR SYSINIT                     ; INIT SYSTEM

; ============================================================================
INTROLOOP:      
            CMP.W #1,(GAME)
            BEQ     PLAY
            CMP.W #1,(HELP)
            BEQ     HELPB
            CMP.W #1,(SETT)
            BEQ     SETTB
.INTRO:
            JSR PLOT_MENU
            TRAP    #MOUUPTN           
SYNC:           
            TRAP    #SCRUPTN
            BRA     INTROLOOP       
; ============================================================================
HELPB:      JSR     HELP_MENU
            TRAP    #MOUUPTN          
            BRA     SYNC
; ============================================================================
SETTB:      JSR     SETT_MENU
            TRAP    #MOUUPTN         
            BRA     SYNC
; ============================================================================
PLAY:
            JSR GAME_INIT
            
            ; GAMELOOP
LOOP        JSR GAME_UPD
            CMP     #0,(GAME)
            BEQ     INTROLOOP
; --- SYNC -------------------------------------------------------------------

.WINT       TST.B   (SCRINTCT)
            BEQ     .WINT
            CLR.B   (SCRINTCT)
            
; --- SYNC FINISH ------------------------------------------------------------
            
            JSR GAME_PLOT
            
            TRAP    #SCRUPTN                ; UPDATE SCREEN (CHANGE DBUFFER)
            
            BRA LOOP



    SIMHALT             ; halt simulator
    
    INCLUDE "MAP_DATA.X68"
    INCLUDE "PLAYER_DATA.X68"
    INCLUDE "COINS_DATA.X68"
    INCLUDE "TURRET_DATA.X68"
    INCLUDE "BULLET_DATA.X68"

    END    START        ; last line of source





































































*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
