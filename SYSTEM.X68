;_____________________________________________________________________________
;___SYSTEM.X68________________________________________________________________
;_____________________________________________________________________________

;=============================================================================
SYSINIT 
; INIT SYSTEM 
; INPUT:    NONE
; OUTPUT:   NONE
; MODIFIES: NONE
;=============================================================================
           MOVE.L  #SCRPLOT,($80+SCRUPTN*4)
           MOVE.L  #MOUSE_UPD,($80+MOUUPTN*4)
           MOVE.L  #KBDUPD,($80+KBDUPTN*4)
           MOVE.L  #SCRTIM,($60+INTN*4)
           MOVE.L  #FPSTIM,($60+FPSN*4)
           
           CLR.W    GAME
           CLR.W    ATTR
           CLR.W    HELP
           CLR.W    SETT
           
           JSR SCRINIT
           JSR MOUSE_INIT
           JSR KBDINIT
            
           MOVE.W  SR,-(A7)
           ANDI.W  #$D8FF,(A7)
  
           RTE
;_____________________________________________________________________________           
           
;=============================================================================
SCRINIT
; INIT SCREEN
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
;=============================================================================
            MOVEM.L D0/D1/D2/D3,-(A7)

            ; SET SCREEN RESOLUTION
            MOVE.B  #33,D0
            MOVE.L  #SCRWIDTH<<16|SCRHEIGH,D1
            TRAP    #15
            
            ; SET WINDOWED MODE
            MOVE.L  #1,D1
            TRAP    #15
            
            ; CLEAR SCREEN
            MOVE.B  #11,D0
            MOVE.W  #$FF00,D1
            TRAP    #15
            
            ; ENABLE DOUBLE BUFFER
            MOVE.B  #92,D0
            MOVE.B  #17,D1
            TRAP    #15
            
            ; CLEAR INTERRUPT COUNTER
            CLR.B   (SCRINTCT)
            
            ; ENABLE TIMED INTERRUPT
            MOVE.B  #32,D0
            MOVE.B  #6,D1
            MOVE.B  #$87,D2
            MOVE.L #1000/RATEFPS,D3
            TRAP    #15
            
            ; ENABLE TIMED INTERRUPT
            MOVE.B  #32,D0
            MOVE.B  #6,D1
            MOVE.B  #$86,D2
            MOVE.L #1000,D3
            TRAP    #15
            
            MOVEM.L (A7)+,D0/D1/D2/D3
            
            RTS
;_____________________________________________________________________________   

            
;=============================================================================
SCRPLOT
; UPDATES DOUBLE BUFFER
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
;=============================================================================
            MOVEM.W D0-D1,-(A7)
            ; SWITCH BUFFERS
            MOVE.B  #94,D0
            TRAP    #15
            ADDQ.W  #1,(FRAMES)
            
            ; CLEAR HIDDEN BUFFER
            MOVE.B  #11,D0
            MOVE.W  #$FF00,D1
            TRAP    #15
            MOVEM.W (A7)+,D0-D1
            RTE
;_____________________________________________________________________________   

            
;=============================================================================
SCRTIM
; TIMED INTERRUPT SERVICE ROUTINE
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
;=============================================================================
            ADDQ.B  #1,(SCRINTCT)
            RTE
            
;=============================================================================
FPSTIM
; TIMED INTERRUPT SERVICE ROUTINE
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
;=============================================================================
            MOVE.L  D0,-(A7)
            
            MOVE.W  (FRAMES),D0
            MOVE.W  D0,(REALFRAMES)
            CLR.W   (FRAMES)
            
            MOVE.L  (A7)+,D0
            
            RTE
;_____________________________________________________________________________  

;=============================================================================
KBDINIT
; INIT THE KEYBOARD
; INPUT:    NONE
; OUTPUT:   NONE
; MODIFIES: NONE
;=============================================================================
            CLR.L   (KBDVARS)
            CLR.L   (KBDR)
            RTS
            
;=============================================================================
KBDUPD
; UPDATES THE KEYBOARD
; INPUT:    NONE
; OUTPUT:   NONE
; MODIFIES: NONE
;=============================================================================
            MOVEM.L D0/D1,-(A7)
            
            ; READ KEYBOARD KEY "R"
            MOVE.B  #19,D0
            MOVE.L  #'RRRR',D1              ; PRESSED KEY: FF, OTHERWISE: 00
            TRAP    #15
            MOVE.L  D1,(KBDR)
            
            MOVE.W (KBDOPTN),D0
            CMP.W   #0,D0
            BNE     .ARROWS            
            ; READ KEYBOARD KEYS "S","W","D","A"
            MOVE.B  #19,D0
            MOVE.L  #'SWDA',D1              ; PRESSED KEY: FF, OTHERWISE: 00
            TRAP    #15                     ; Exemple: W y D PRESSED:
            MOVE.L  D1,(KBDVARS)
            BRA .RET
   .ARROWS: ; READ KEYBOARD ARROWS
            MOVE.B  #19,D0
            MOVE.L  #$28262725,D1              ; PRESSED KEY: FF, OTHERWISE: 00
            TRAP    #15                     ; Exemple: W y D PRESSED:
            MOVE.L  D1,(KBDVARS)
            BRA .RET        
            
   .RET:    MOVEM.L (A7)+,D0/D1
            RTE

;=============================================================================
MOUSE_INIT
; INIT THE MOUSE
; INPUT:    NONE
; OUTPUT:   NONE
; MODIFIES: NONE
;=============================================================================
            CLR.W   (MOUSE_X)
            CLR.W   (MOUSE_Y)
            CLR.W   (MOUSE_L)
            CLR.W   (MOUSE_R)
            RTS
;_____________________________________________________________________________

            
;=============================================================================
MOUSE_UPD
; UPTADES MOUSE POSITION INFORMATION
; INPUT:    NONE
; OUTPUT:   NONE
; MODIFIES: NONE
;=============================================================================
            MOVEM.L D0-D1,-(A7)
        
            CLR.L D0
            CLR.L D1
        
            MOVE.B #61,D0
            TRAP #15
            
            BTST    #1,D0                   ; RIGHT BUTTON
            BEQ     .NORIGHT
            MOVE.W  #1,(MOUSE_R)
            BRA     .RPRESSED
            
   .NORIGHT:
            MOVE.W  #0,(MOUSE_R)
   .RPRESSED:
            BTST #0,D0
            BEQ .NOPRESSED
            MOVE.W #1,(MOUSE_L)
            BRA .NEXT
   .NOPRESSED:
            MOVE.W #0,(MOUSE_L)
   .NEXT:
            MOVE.L D1,(MOUSE_Y)            

            MOVEM.L (A7)+,D0-D1   
        
            RTE
;_____________________________________________________________________________  

;=============================================================================
SHOW_MOUVAR:
; SHOWS MOUSE VARIABLES:
; WHITE: X POSITION
; RED  : Y POSITION
; GREEN: 0 IF LEFT BUTTON IS NOT PRESSED OR 1 IF LEFT BUTTON IS PRESSED
; USEFULL FOR THE DEVELOPMENT TASKS
; INPUT:    NONE
; OUTPUT:   NONE
; MODIFIES: NONE
;=============================================================================
            MOVEM.L D0/D1,-(A7)
    
            CLR.L D0
            CLR.L D1
    
            MOVE.L  #$00000000,D1
            MOVE.B  #81,D0
            TRAP    #15
    
            MOVE.B  #11, D0
            MOVE.L  #$0000, D1
            TRAP    #15 

            MOVE.B #21,D0
            MOVE.L #$00FFFFFF,D1
            TRAP    #15
    
            MOVE.B  #20, D0
            CLR.L   D1
            MOVE.W  (MOUSE_X),D1
            TRAP    #15
    
            MOVE.B #21,D0
            MOVE.L #$000000FF,D1
            TRAP    #15
    
            MOVE.B  #20, D0
            CLR.L   D1
            MOVE.W  (MOUSE_Y),D1
            TRAP    #15
            
            MOVE.B #21,D0
            MOVE.L #$00FF0000,D1
            TRAP    #15
    
            MOVE.B  #20, D0
            CLR.L   D1
            MOVE.W  (MOUSE_L),D1
            TRAP    #15
    
            MOVE.B #21,D0
            MOVE.L #$0000FF00,D1
            TRAP    #15
    
            MOVE.B  #20, D0
            CLR.L   D1
            MOVE.W  (MOUSE_R),D1
            TRAP    #15
    
    
            MOVEM.L (A7)+,D0/D1
            RTS
;_____________________________________________________________________________


;=============================================================================
SHOW_FPS:
; SHOWS FPS VARIABLES
; INPUT:    NONE
; OUTPUT:   NONE
; MODIFIES: NONE
;=============================================================================
            MOVEM.L D0/D1/A1,-(A7)
    
            CLR.L D0
            CLR.L D1
    
            MOVE.L  #$00000000,D1
            MOVE.B  #81,D0
            TRAP    #15
    
            MOVE.B  #11, D0
            MOVE.L  #$0000, D1
            TRAP    #15 

            MOVE.B #21,D0
            MOVE.L #$00FFFFFF,D1
            TRAP    #15
            
            ; PRINT THE STRING
            MOVE.B  #14,D0
            LEA     FPSTXT,A1
            TRAP    #15
            
            MOVE.B  #3,D0
            MOVE.W  (REALFRAMES),D1
            AND.L   #$000000FF,D1
            TRAP    #15
            
            MOVE.B  #14,D0
            LEA     FPSUNIT,A1
            TRAP    #15
            
            MOVE.B  #11, D0
            MOVE.L  #$0001, D1
            TRAP    #15 
            
            ; PRINT THE STRING
            MOVE.B  #14,D0
            LEA     GOALTXT,A1
            TRAP    #15
            
            MOVE.B  #3,D0
            MOVE.W  #RATEFPS,D1
            AND.L   #$000000FF,D1
            TRAP    #15
            
            MOVE.B  #14,D0
            LEA     FPSUNIT,A1
            TRAP    #15
            
            

            MOVEM.L (A7)+,D0/D1/A1
            
            RTS
            
FPSTXT      DC.B    'ACTUAL:',0
GOALTXT      DC.B    'GOAL:',0
FPSUNIT     DC.B    'FPS',0
;_____________________________________________________________________________

 

























*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
