; description: Simple bot for the game "Crusaders of the lost idols" (http://armorgames.com/crusaders-of-the-lost-idols-game)
; author: Marcel Petrick (mail@marcelpetrick.it)
; date: 20160718
; version: 0.01
; license:  GNU GENERAL PUBLIC LICENSE Version 2

; ********************************
; HOW TO USE:
; 0. load script in some AutoIt-interpreter (or generate an EXE ..)
; 1. start by pressing F5
; 2. position the mouse over the game-area (for killing) or over your main character's level up-button (for autoleveling)
; 3. press Shift+v .. enjoy
; ********************************

; assign the hotkeys
HotKeySet("+v", "captureV")
HotKeySet("{F5}", "quit") ; same like for executing the script

; brief: interupts and exits script
Func quit()
   Exit
EndFunc

; brief: if caps+v is pressed, then emit 360000 LMB-clicks at the current position
Func captureV()
   ; 10 hours of clicking
   For $i = 0 To 360000 Step 1
	  MouseClick("left")
	  Sleep(1000 / 5) ; use 5 (per second) if as "killing-helper" and 1 for "auto-level"
   Next
EndFunc

; body
 While 1
   Sleep(100)
WEnd
