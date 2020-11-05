# cotli_bot - A bot for 'Crusaders of the Lost idols'

## Quick instructions for the bot usage

### How to use (quick instructions) - verified with Cotli 0.71
	
0. download the repository
1. open the au3-file in AutoIt and execute it (press F5)
2. open Cotli in your favorite browser (Chrome suggested because of needed Flash-performance)
3. position the cursor over the center of the "level up"-coin for your favorite DPS-char (for now it has to be in the top right; check screenshot)
4. press "Shift + y" for start
5. press "Shift + x" if you want to pause it for a while - continue with the same hotkey! Repositioning the cursor not needed.
6. stop with "F5"

Press after start whenever you want "SHIFT+c" to trigger the mission-reward-harvesting :)

### How the game-area should look like before starting:

Don't scale/zoom your screen! - else edit the coordinates in the script.

![](gameArea.png)

### Example output in the output-area of the AutoIt-editor (ScITE):

![](autoIt.png)

## What is supported?

* will monsters kill by clicking
* level up the selected char (needed for progress!) and
* try to collect the items as fast as possible
* every certain multiple of runs (configureable) level all other crusaders and upgrade their skills
* trigger every once in a while the abilities: order is Magnify, Stormrider, Savage Strikes, Gold-o-rama, Fire Storm, Click-o-Rama, Alchemy (no Royal command since it blocks progress)
* pausing the script inbetween for adjustments now possible
* will switch automatically to your favorite (third!) formation
* will make Sarah the main DPS - even if you started the script with some other crusader below the cursor (just has to be top-right!)
* will harvest via SHIFT+c the currently finished mission-rewards
* works with ArmorGames Version 1.19 in Chrome