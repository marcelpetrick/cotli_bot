; description: Simple bot for the game "Crusaders of the lost idols" (http://armorgames.com/crusaders-of-the-lost-idols-game)
;				- will kill by clicking; level up the selected char (needed for progress!) and try to collect the items as fast as possible
; author: Marcel Petrick (mail@marcelpetrick.it)
; date: 20160720
; version: 0.03
; license:  GNU GENERAL PUBLIC LICENSE Version 2

; ********************************
; HOW TO USE:
; 0. load script in some AutoIt-interpreter (or generate an EXE ..)
; 1. start by pressing F5 in the interpreter
; 2. position the mouse over level-up-button of your main char:
;		- best position is hovering the gold-coin-icon!
;		- main char has to be positioned on the right (top just tested)!
; 3. press Shift+v .. enjoy
; ********************************

; assign the hotkeys
HotKeySet("+v", "captureV") ; change to a different hotkey if you need to ..
HotKeySet("{F5}", "quit") ; same hotkey like for executing the script

; brief: interupts and exits script
Func quit()
   Exit
EndFunc

; brief: infinite loop of "level up main-DPS-char & ten clicks for the monsters"
Func captureV()
   $MousePosOri = MouseGetPos() ; save initial position to fix even accidental movements
   Local $yOffset = 300 ; offset based on the starting position
   Local $moveSpeed = 5 ; 0 instant; 10 default
   Local $rectLength = 120 ; determines how far to move for "collecting", used both vertically and horizontally

   While (True)
	  ; one click on "level"
	  MouseClick("left")

	  ; .. and ten on the battle-ground for killing
	  ; move: 250 px on my screen!
	  MouseMove($MousePosOri[0], $MousePosOri[1] - $yOffset, $moveSpeed)

	  ; click for kills
	  For $i = 0 To 10 Step 1
		 MouseClick("left")
		 ; 1000 for a second as interval, 500 as test
		 Sleep(500 / 5) ; 5 (per second) as "killing-helper"; increase if system is fast enough (10 max)
	  Next

	  ; move mouse to collect items
	  MouseMove($MousePosOri[0] - $rectLength, $MousePosOri[1] - $yOffset, $moveSpeed) ; to the left
	  MouseMove($MousePosOri[0] - $rectLength, $MousePosOri[1] - $yOffset + $rectLength, $moveSpeed) ; down
	  MouseMove($MousePosOri[0], $MousePosOri[1] - $yOffset + $rectLength, $moveSpeed) ; right
	  MouseMove($MousePosOri[0], $MousePosOri[1] - $yOffset, $moveSpeed) ; up

	  ; move back to original position
	  MouseMove($MousePosOri[0], $MousePosOri[1], $moveSpeed)
   WEnd
EndFunc

; body
 While 1
   Sleep(200)
WEnd
