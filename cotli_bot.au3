; description: Simple bot for the game "Crusaders of the lost idols" (http://armorgames.com/crusaders-of-the-lost-idols-game)
; author: Marcel Petrick (mail@marcelpetrick.it)
; date: 20160718
; version: 0.02
; license:  GNU GENERAL PUBLIC LICENSE Version 2

; ********************************
; HOW TO USE:
; 0. load script in some AutoIt-interpreter (or generate an EXE ..)
; 1. start by pressing F5 in the interpreter
; 2. position the mouse over level-up-button of your main char
; 3. press Shift+v .. enjoy
; ********************************

; assign the hotkeys
HotKeySet("+v", "captureV") ; change to a different hotkey if you need to ..
HotKeySet("{F5}", "quit") ; same like for executing the script

; brief: interupts and exits script
Func quit()
   Exit
EndFunc

; brief: infinite loop of "level up main-DPS-char & ten clicks for the monsters"
Func captureV()
   $MousePos = MouseGetPos() ; save initial positin to fix even accidentally movements

   While (True)
	  ; one click on "level"
	  MouseClick("left")

	  ; .. and ten on the battle-ground for killing
	  ; move: 250 px on my screen!
	  MouseMove($MousePos[0], $MousePos[1] - 250, 2)

	  ; click for kills
	  For $i = 0 To 10 Step 1
		 MouseClick("left")
		 Sleep(1000 / 5) ; use 5 (per second) if as "killing-helper" and 1 for "auto-level"
	  Next

	  ; move back to original position
	  MouseMove($MousePos[0], $MousePos[1], 2)
   WEnd
EndFunc

; body
 While 1
   Sleep(200)
WEnd
