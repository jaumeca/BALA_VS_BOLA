;_____________________________________________________________________________
;___SYS_VARS.X68______________________________________________________________
;_____________________________________________________________________________

;=============================================================================

; SCREEN SETTINGS
RATEFPS     EQU     70                      ; GOAL FPS

REALFRAMES  DS.W    1                       ; NUMBER OF THE LAST SECOND FPS
FRAMES      DS.W    1                       ; FRAMES OF THE CURRENT SECOND

SCRWIDTH    EQU     640                     ; SCREEN WIDTH
SCRHEIGH    EQU     480                     ; SCREEN HEIGHT

; STATUS
GAME        DS.W    1
HELP        DS.W    1
ATTR        DS.W    1
SETT        DS.W    1
ENDG        DS.W    1
LOOSEGAME   DS.W    1


; TRAP AND INT. NUMBERS

SCRUPTN     EQU     0                       ; SCREEN UPDATE TRAP NUMBER
MOUUPTN     EQU     1                       ; MOUSE UPDATE TRAP NUMBER
KBDUPTN     EQU     2                       ; KEYBOARD UPDATE TRAP NUMBER

INTN        EQU     7                       ; SCREEN INTERRUPTION NUMBER
FPSN        EQU     6                       ; REAL FPS INTERRUPTION NUMBER

; MOUSE INFO
MOUSE_Y     DS.W    1
MOUSE_X     DS.W    1
MOUSE_L     DS.W    1
MOUSE_R     DS.W    1

; KEYBOARD DATA
KBDVARS     DS.L    1
KBDOPTN     DC.W    0                       ; DEFAULT OPTION: 'WASD'
KBDR        DS.L    1

; OTHER

SCRINTCT    DC.B    0                       ; SCREEN INTERRUPT COUNTER
            DS.W    0
























*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
