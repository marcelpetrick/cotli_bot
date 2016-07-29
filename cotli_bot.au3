; description: Simple bot for the game "Crusaders of the lost idols" (http://armorgames.com/crusaders-of-the-lost-idols-game):
;				* will kill by clicking
;				* level up the selected char (needed for progress!) and
;				* try to collect the items as fast as possible
;				* every certain multiple of runs (configureable) level all other crusaders and upgrade their skills
;				* trigger every once in a while the abilities: order is Magnify, Stormrider, Savage Strikes,
;					Gold-o-rama, Fire Storm, Click-o-Rama, Alchemy (no Royal command since it blocks just progress)
; author: Marcel Petrick (mail@marcelpetrick.it)
; date: 20160729
; version: 0.05
; license:  GNU GENERAL PUBLIC LICENSE Version 2

; ********************************
; HOW TO USE:
; 0. load script in some AutoIt-interpreter (or generate an EXE ..)
; 1. start by pressing F5 in the interpreter
; 2. position the mouse over level-up-button of your main DPS-dealer:
;		* best position is hovering the gold-coin-icon!
;		* main char has to be positioned on the top-right! Otherwise: fix all coordinates!
; 3. press Shift+v .. enjoy
; ********************************

;includes
#include <Date.au3>

; edit mabye the first values - but not the following ones
;Global Const $magnifyCooldown = 11 * 60 + 15 ; with current set-up
Global Const $savageCooldown = 15 * 60 + 0 + 10 ; +10 for security; with current set-up: maybe use this instead of Magnify (11m15s), because else more valueable Savage-activation would "slip"
Global Const $moveSpeed = 2 ; 0 instant; 10 default, 2 is for real runs
Global Const $updateFrequency = 100 ; 100 recommended, maybe even bigger for "later" run-starts; called UF in comments

Global Const $logFunctionCall = True ;False True; determines if the entry of a function is logged to StdErr
Global Const $yOffset = 300 ; offset based on the starting position
Global Const $collectRectLength = 120 ; determines how far to move for "collecting", used both verticall and horizontal
Global Const $diffUpgrade = [45, 100] ; determines how far to move right from "coin" to the "upgrade all"- and down to the "level all"-buttons

; assign the hotkeys
HotKeySet("+v", "main") ; change to a different hotkey if you need to
HotKeySet("{F5}", "quit") ; same hotkey like for executing the script

; helpers
Global $lastTrigger = 0 ; for the triggerAbilities()

; body: scripts sleeps before triggering the real functionality
 While 1
   Sleep(200)
WEnd

; brief: interupts and exits script
Func quit()
   logCall("quit()")
   Exit
EndFunc

; brief: write current string to StdErr if globally enabled
Func logCall(ByRef Const $string)
   If($logFunctionCall) Then
	  ;ConsoleWrite($string & " " & _NowTime(5) & @CRLF)
	  ConsoleWrite($string & " " & _NowTime(5) & "; ")
   EndIf
EndFunc

; brief: move the mouse in some counter-clock-wise rectangle-shape
Func collectItems(ByRef Const $mousePosOri)
   ;logCall("collectItems()")
   MouseMove($mousePosOri[0] - $collectRectLength, $mousePosOri[1] - $yOffset, $moveSpeed) ; to the left
   MouseMove($mousePosOri[0] - $collectRectLength, $mousePosOri[1] - $yOffset + $collectRectLength, $moveSpeed) ; then down
   MouseMove($mousePosOri[0], $mousePosOri[1] - $yOffset + $collectRectLength, $moveSpeed) ; then right
   ; moving upward is not necessary
EndFunc

; brief: move towards and click the "level all crusaders"-button
Func levelAll(ByRef Const $mousePosOri)
   logCall("levelAll()")
   MouseMove($mousePosOri[0] + $diffUpgrade[0], $mousePosOri[1] + $diffUpgrade[1], $moveSpeed)
   MouseClick("left")
EndFunc

; brief: move towards and click the "upgrade all crusaders"-button
Func upgradeAll(ByRef Const $mousePosOri)
   logCall("upgradeAll()")
   MouseMove($mousePosOri[0] + $diffUpgrade[0], $mousePosOri[1], $moveSpeed)
   MouseClick("left")
EndFunc

; brief: activate all abilities in a certain order to achieve maximum growth and temporary damage-plus
; order is Magnify, Stormrider, Savage Strikes, Gold-o-rama, Fire Storm, Click-o-Rama, Alchemy (no Royal command since it blocks just progress)
Func triggerAbilities(ByRef Const $mousePosOri)
   logCall("triggerAbilities()")

   ; y always 65
   ; Magnify 540
   MouseMove($mousePosOri[0] - 540, $mousePosOri[1] - 65, $moveSpeed)
   MouseClick("left")
   ; Stormrider 340
   MouseMove($mousePosOri[0] - 340, $mousePosOri[1] - 65, $moveSpeed)
   MouseClick("left")
   ; Savage Strikes 460
   MouseMove($mousePosOri[0] - 460, $mousePosOri[1] - 65, $moveSpeed)
   MouseClick("left")
   ; Gold-o-rama 420
   MouseMove($mousePosOri[0] - 420, $mousePosOri[1] - 65, $moveSpeed)
   MouseClick("left")
   ; Fire Storm 500
   MouseMove($mousePosOri[0] - 500, $mousePosOri[1] - 65, $moveSpeed)
   MouseClick("left")
   ; Click-o-Rama 580
   MouseMove($mousePosOri[0] - 580, $mousePosOri[1] - 65, $moveSpeed)
   MouseClick("left")
   ; Alchemy 300
   MouseMove($mousePosOri[0] - 300, $mousePosOri[1] - 65, $moveSpeed)
   MouseClick("left")

EndFunc

; brief: infinite loop of "level up main-DPS-char & ten clicks for the monsters"
Func main()
   logCall("main()")
   Local Const $mousePosOri = MouseGetPos() ; save initial position to fix even accidental movements
   Local $counter = 0 ; increased and reset every UF

   While (True)
	  ; one click on "level current crusader" (for the main DPS-dealer)
	  MouseClick("left")

	  ; ten clicks on the battle-ground for killing
	  For $i = 0 To 10 Step 1
		 ; move towards the game-area: do this everytime to prevent accidental movements and chaos!
		 MouseMove($mousePosOri[0], $mousePosOri[1] - $yOffset, $moveSpeed)
		 ;add the click
		 MouseClick("left")
		 Sleep(1000 / 10) ; 10 (per second) as "killing-helper"; increase if system is fast enough (10 max)
	  Next

	  ; move mouse to collect items
	  collectItems($mousePosOri)

	  ; for every 0th run level all other crusaders (will take some computation time ..)
	  If($counter = (0 * $updateFrequency + 0 + 10)) Then ;trigger at 0; +10 for simple "slow start"
		 levelAll($mousePosOri)
	  EndIf

	  ; for every 100th run level all other crusaders (will take some computation time ..)
	  If($counter = (0 * $updateFrequency + 10 + 10)) Then ; trigger at 10; +10 for simple "slow start"
		 upgradeAll($mousePosOri)
	  EndIf

	  ; increase the counter: reset if UF is hit (currently: 100)
	  $counter = Mod(($counter + 1), 1 * $updateFrequency) ; increase first, then modulo to reset

	  ; trigger the abilities if the time has come: do this after the time-consuming "x-All"-operations to prevent loss of usage-time
	  Local $currentTime = _DateDiff('s', "2016/01/01 00:00:00", _NowCalc()) ; determine the current "time"
	  ;ConsoleWrite("$currentTime: " & $currentTime & @CRLF)
	  ;ConsoleWrite("lastTrigger: " & $lastTrigger & @CRLF)
	  If ($currentTime > $lastTrigger + $savageCooldown) Then
		 ConsoleWrite(@CRLF & "time-diff is bigger than $savageCooldown: " & $savageCooldown & "s" & @CRLF)
		 $lastTrigger = _DateDiff('s', "2016/01/01 00:00:00", _NowCalc()); reset $lastTrigger
		 triggerAbilities($mousePosOri)
	  EndIf

	  ; move back to original position for the next run
	  MouseMove($mousePosOri[0], $mousePosOri[1], $moveSpeed)
   WEnd
EndFunc
