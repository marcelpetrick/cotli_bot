; description: Simple bot for the game "Crusaders of the lost idols" (http://armorgames.com/crusaders-of-the-lost-idols-game):
;				* will kill by clicking
;				* level up the selected char (needed for progress!) and
;				* try to collect the items as fast as possible
;				* every certain multiple of runs (configureable) level all other crusaders and upgrade their skills
; author: Marcel Petrick (mail@marcelpetrick.it)
; date: 20160724
; version: 0.04
; license:  GNU GENERAL PUBLIC LICENSE Version 2

; ********************************
; HOW TO USE:
; 0. load script in some AutoIt-interpreter (or generate an EXE ..)
; 1. start by pressing F5 in the interpreter
; 2. position the mouse over level-up-button of your main char:
;		* best position is hovering the gold-coin-icon!
;		* main char has to be positioned on the top-right!
; 3. press Shift+v .. enjoy
; ********************************

; some values
Global Const $moveSpeed = 5 ; 0 instant; 10 default, 2 is for real runs
Global Const $yOffset = 300 ; offset based on the starting position
Global Const $collectRectLength = 120 ; determines how far to move for "collecting", used both verticall and horizontal
Global Const $diffUpgrade = [50, 100] ; determines how far to move right from "coin" to the "upgrade all"- and down to the "level all"-buttons
Global Const $updateFrequency = 100 ; 100 recommended, maybe even bigger ..

; assign the hotkeys
HotKeySet("+v", "main") ; change to a different hotkey if you need to
HotKeySet("{F5}", "quit") ; same hotkey like for executing the script

; body: "sleeps" before starting the real functionality
 While 1
   Sleep(200)
WEnd

; brief: interupts and exits script
Func quit()
   Exit
EndFunc

; move the mouse in some counter-clock-wise rectangle-shape
Func collectItems(ByRef Const $mousePosOri)
   MouseMove($mousePosOri[0] - $collectRectLength, $mousePosOri[1] - $yOffset, $moveSpeed) ; to the left
   MouseMove($mousePosOri[0] - $collectRectLength, $mousePosOri[1] - $yOffset + $collectRectLength, $moveSpeed) ; then down
   MouseMove($mousePosOri[0], $mousePosOri[1] - $yOffset + $collectRectLength, $moveSpeed) ; then right
   ; moving upwards was removed, because not necessary
EndFunc

; move towards and click the "level all crusaders"-button
Func levelAll(ByRef Const $mousePosOri)
   MouseMove($mousePosOri[0] + $diffUpgrade[0], $mousePosOri[1] + $diffUpgrade[1], $moveSpeed)
   MouseClick("left")
EndFunc

; move towards and click the "upgrade all crusaders"-button
Func upgradeAll(ByRef Const $mousePosOri)
   MouseMove($mousePosOri[0] + $diffUpgrade[0], $mousePosOri[1], $moveSpeed)
   MouseClick("left")
EndFunc

; brief: infinite loop of "level up main-DPS-char & ten clicks for the monsters"
Func main()
   Local Const $mousePosOri = MouseGetPos() ; save initial position to fix even accidental movements
   Local $counter = 0 ; increased and reset every "2 * UF"

   While (True)
	  ; one click on "level current crusader"
	  MouseClick("left")

	  ; move towards the game-area
	  MouseMove($mousePosOri[0], $mousePosOri[1] - $yOffset, $moveSpeed)

	  ; ten clicks on the battle-ground for killing
	  For $i = 0 To 10 Step 1
		 MouseClick("left")
		 Sleep(1000 / 10) ; 10 (per second) as "killing-helper"; increase if system is fast enough (10 max)
	  Next

	  ; move mouse to collect items
	  collectItems($mousePosOri)

	  ; for every 0th run level all other crusaders (will take some computation time ..)
	  IF($counter = (0 * $updateFrequency)) Then
		 levelAll($mousePosOri)
	  EndIf

	  ; for every 100th run level all other crusaders (will take some computation time ..)
	  IF($counter = (1 * $updateFrequency)) Then
		 upgradeAll($mousePosOri)
	  EndIf

	  ; increase the counter: reset if 200
	  $counter = Mod(($counter + 1), 2 * $updateFrequency) ; increase first, then modulo the double UF

	  ; move back to original position for the next run
	  MouseMove($mousePosOri[0], $mousePosOri[1], $moveSpeed)
   WEnd
EndFunc
