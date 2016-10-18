; description: Simple bot for the game "Crusaders of the lost idols" (http://armorgames.com/crusaders-of-the-lost-idols-game):
;				* will monsters kill by clicking
;				* level up the selected char (needed for progress!) and
;				* try to collect the items as fast as possible
;				* every certain multiple of runs (configureable) level all other crusaders and upgrade their skills
;				* trigger every once in a while the abilities: order is Magnify, Stormrider, Savage Strikes,
;					Gold-o-rama, Fire Storm, Click-o-Rama, Alchemy (no Royal command since it blocks progress)
;				* pausing the script inbetween for adjustments now possible
;				* will switch automatically to your favorite (third!) formation
;				* will make Sarah the main DPS - even if you started the script with some other crusader below the cursor (just has to be top-right!)
;				* works with ArmorGames Version 0.81 in Chrome
; author: Marcel Petrick (mail@marcelpetrick.it)
; date: 20161019
; version: 0.8
; license:  GNU GENERAL PUBLIC LICENSE Version 2

; ********************************
; HOW TO USE:
; 0. load script in some AutoIt-interpreter (or generate an EXE ..)
; 1. start by pressing F5 in the interpreter
; 2. position the mouse over level-up-button of your main DPS-dealer:
;		* best position is hovering the gold-coin-icon!
;		* main char has to be positioned on the top-right! Otherwise: fix all coordinates!
; 3. press Shift+y for starting the bot .. enjoy
; 4. pause/unpause the script-run with Shift+x
; 5. quit script with F5 (just like starting)
; ********************************

;includes
#include <Date.au3>

; assign the hotkeys
HotKeySet("+y", "main") ; go go go
HotKeySet("+x", "togglePause") ; freeze!
HotKeySet("{F5}", "quitScript") ; stop, come back home!

; some editable constants: change them based on your experience; most values are chosen for longterm-unwatched-runs (90% performance, but no errors ..)
Global Const $moveSpeed = 2 ; 0 instant; 10 default, 2 is for real runs
Global Const $logFunctionCall = True ;False True; determines if the entry of a function is logged to StdErr
; position-settings
Global Const $yOffsetProgress = 320 ; 320/280 offset based on the starting position: the bigger will trigger the "next area" if needed,  the other: "stay where you are"
Global Const $yOffsetSafe = 320 ;280 ; for testing with .6.1. - just progress in state3 and state4
Global Const $collectRectLength = 120 ; determines how far to move for "collecting", used both vertically and horizontally
Global Const $diffUpgrade = [45, 100] ; determines how far to move right from "coin" to the "upgrade all"- and down to the "level all"-buttons
Global Const $diffLeft = [-928, 52] ; offset from the "start-coin" to the "shuffle crusader-list left
Global Const $diffRight = [41, 52] ; offset from the "start-coin" to the "shuffle crusader-list right
; time-settings
Global Const $sleepingTime = 200;
Global Const $timeTriggerDelay = 7 ; 10 would be "always safe"; 5 fits for fast connections; 7 is safe and sound
Global Const $savageCooldown = 15 * 60; + $timeTriggerDelay ; +10 for security; with current set-up: maybe use this instead of Magnify (11m15s), because else more valueable Savage-activation would "slip"
Global const $referenceTime = "2016/01/01 00:00:00" ; randomly chosen (anything past the current date works)

; helper-variables
Global $lastTriggerTime = 0 ; for the triggerAbilities(); todo check if this can be moved inside the function
Global $stateTriggerAbilities = 0; helper for determining which task shall be done if a certain time has passed: 0 upgradeAll, 1 levelAll, 2 triggerAbilities, 3 triggerAbilities (in case due to area-change the first try missed)

; body: scripts sleeps before triggering the real functionality
 While 1
   Sleep($sleepingTime)
WEnd

; brief: interupts and exits script
Func quitScript()
   logCall("quitScript()")
   Exit
EndFunc

; brief: put the script to sleep if the static var is set
Func togglePause()
   Static Local $isPaused = False ; helper for the pause-functionality: exists only once - "static"
   $isPaused = Not $isPaused ; toggle
   While $isPaused
	  Sleep($sleepingTime)
   WEnd
EndFunc

; brief: write current string to StdErr if globally enabled
Func logCall(ByRef Const $string)
   If ($logFunctionCall) Then
	  ConsoleWrite($string & " " & _NowTime(5) & @CRLF)
	  ;ConsoleWrite($string & " " & _NowTime(5) & "; ")
   EndIf
EndFunc

; brief: move the mouse in some counter-clock-wise hook-shape
Func collectItems(ByRef Const $mousePosOri)
   ;logCall("collectItems()")
   Local Const $yOffset = ($stateTriggerAbilities >= 2) ? $yOffsetProgress : $yOffsetSafe ; regularly 280 - every 15 min for a short period 320 for progressing ...
   MouseMove($mousePosOri[0] - $collectRectLength, $mousePosOri[1] - $yOffset, $moveSpeed) ; to the left
   MouseMove($mousePosOri[0] - $collectRectLength, $mousePosOri[1] - $yOffset + $collectRectLength, $moveSpeed) ; then down
   MouseMove($mousePosOri[0], $mousePosOri[1] - $yOffset + $collectRectLength, $moveSpeed) ; then right
   ; moving upward is not necessary: will be done in the whole cycle
EndFunc

; brief: make Sarah, the main DPS, the current character for levelling. Since no position-/image-recognition exits,
;		do this by: move to the very left by repeatedly clicking "left", then a certain number of steps right,
;		et voila ..
; todo: could be rewritten in a leaner way ... could ...
Func switchToSarah(ByRef Const $mousePosOri)
   logCall("switchToSarah()")

   ; 9 to the left; multiple click via setting of MouseClick did not work - delay is needed
   MouseMove($mousePosOri[0] + $diffLeft[0], $mousePosOri[1] + $diffLeft[1], $moveSpeed)
   For $i = 0 To (9-1) Step 1
	  MouseClick("left")
	  Sleep(1000 / 10) ; 10 per second
   Next
   ; 4 to the right
   MouseMove($mousePosOri[0] + $diffRight[0], $mousePosOri[1] + $diffRight[1], $moveSpeed)
   For $i = 0 To (4-1) Step 1
	  MouseClick("left")
	  Sleep(1000 / 10) ; 10 per second
   Next
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
   Local Const $yOffset = 65;
   ; Magnify 540
   MouseMove($mousePosOri[0] - 540, $mousePosOri[1] - $yOffset, $moveSpeed)
   MouseClick("left")
   ; Stormrider 340
   MouseMove($mousePosOri[0] - 340, $mousePosOri[1] - $yOffset, $moveSpeed)
   MouseClick("left")
   ; Savage Strikes 460
   MouseMove($mousePosOri[0] - 460, $mousePosOri[1] - $yOffset, $moveSpeed)
   MouseClick("left")
   ; Gold-o-rama 420
   MouseMove($mousePosOri[0] - 420, $mousePosOri[1] - $yOffset, $moveSpeed)
   MouseClick("left")
   ; Fire Storm 500
   MouseMove($mousePosOri[0] - 500, $mousePosOri[1] - $yOffset, $moveSpeed)
   MouseClick("left")
   ; Click-o-Rama 580
   MouseMove($mousePosOri[0] - 580, $mousePosOri[1] - $yOffset, $moveSpeed)
   MouseClick("left")
   ; Alchemy 300
   MouseMove($mousePosOri[0] - 300, $mousePosOri[1] - $yOffset, $moveSpeed)
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
		 MouseMove($mousePosOri[0], $mousePosOri[1] - (($stateTriggerAbilities >= 2) ? $yOffsetProgress : $yOffsetSafe), $moveSpeed)
		 ;add the click
		 MouseClick("left")
		 Sleep(1000 / 10) ; 10 (per second) as "killing-helper"; increase if system is fast enough (10 max)
	  Next

	  ; move mouse to collect items
	  collectItems($mousePosOri)

	  ; ##### new section for the time-based-triggers #####
	  Local $currentTime = _DateDiff('s', $referenceTime, _NowCalc()) ; determine the current "time"

	  If (($currentTime > ($lastTriggerTime + $savageCooldown)) And ($stateTriggerAbilities = 0)) Then
		 ; ConsoleWrite(@CRLF & "state 0: levelAll($mousePosOri) " & $savageCooldown & "s" & @CRLF)
		 levelAll($mousePosOri)
		 $stateTriggerAbilities += 1;
		 $lastTriggerTime = $currentTime ; reset $lastTriggerTime: next tasks are based on the difference to the first trigger AND the state (needed because else pausing/unpausing creates chaos)
	  EndIf

	  If (($currentTime > ($lastTriggerTime + 1 * $timeTriggerDelay)) And ($stateTriggerAbilities = 1)) Then
		 ; ConsoleWrite(@CRLF & "state 1: upgradeAll($mousePosOri) " & 1 * $timeTriggerDelay & "s" & @CRLF)
		 Send("e") ; switch to third formation
		 upgradeAll($mousePosOri)
		 $stateTriggerAbilities += 1;
	  EndIf

	  If (($currentTime > ($lastTriggerTime + 2 * $timeTriggerDelay)) And ($stateTriggerAbilities = 2)) Then
		 ; ConsoleWrite(@CRLF & "state 2: triggerAbilities($mousePosOri) " & 2 * $timeTriggerDelay & "s" & @CRLF)
		 switchToSarah($mousePosOri) ; make her the main DPS
		 triggerAbilities($mousePosOri)
		 $stateTriggerAbilities += 1;
	  EndIf

	  If (($currentTime > ($lastTriggerTime + 3 * $timeTriggerDelay)) And ($stateTriggerAbilities = 3)) Then
		 ; ConsoleWrite(@CRLF & "state 3: triggerAbilities($mousePosOri) " & 3 * $timeTriggerDelay & "s" & @CRLF)
		 Send("e") ; switch to third formation: second try if the other was blocked by area-change
		 switchToSarah($mousePosOri) ; make her the main DPS - second try!
		 triggerAbilities($mousePosOri)
		 $stateTriggerAbilities = 0 ; reset
		 $lastTriggerTime = $currentTime ; reset $lastTriggerTime
	  EndIf
	  ; ##### end of new section for the time-based-triggers #####

	  ; move back to original position for the next run
	  MouseMove($mousePosOri[0], $mousePosOri[1], $moveSpeed)
   WEnd
EndFunc
