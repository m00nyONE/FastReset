## 2.3.0
- adding speedy mode

## 2.2.0
- adding additional hodor eject feature for players who do not have fastreset enabled

## 2.1.0
- adding optional except button when getting an exit command from the leader

## 2.0.1
- complete rework of the whole FastReset System to be more reliable & failproof when ESO crashes on people
- introduce map ping sharing via LibDataShare
- death setting now synchronise to other players

## 1.12.0
- fix a bug introduced in 1.11.0
- leading the way to sync stuff ;-)
- code:
    - refactoring
    - function outsorcing

## 1.11.0
- fixed an oversight that when you abort auto exiting the instance it will try to port you into the ultihouse anyway

## 1.10.0
- death detection settings are now not experimental anymore - YOU STILL HAVE TO SET THEM ON EVERY GROUPMEMBER IF YOU PLAN TO USE THEM!!!! - syncing maybe in the future
- new commands added
  /fr set ulti
  /fr set deaths x
- cleanup & some translation fixes

## 1.9.2
- adding extra safety to the functions by resetting FastReset.TrialZoneID to -1 after finishing automation - also on enable & disable - to avoid wrong teleportation

## 1.9.1
- fix l18n stuff

## 1.9.0
- new feature:
  the leader now gets a promt to directly port back to the trial after reset
- adding LibSlashCommander as a required dependency & remove legacy code
- code refactor and partially rewrite
- change ZoneIndex to ZoneID for more stability in the future ( Indexes change very update, IDs do not )

## 1.8.0
- adding experimental feature to allow death cap

## 1.7.1
- display warning for the new dependency LibSlashCommander that will be introduced on 01. March 2022 in the 1.9.0 Update so users don't get suprised that the addon is not working any longer without this library upon this date

## 1.7.0
- adding default ulti-home ( thanks to @No4Sniper2k3 for providing this )

## 1.6.1
- refactoring
- fix a bug where the zone (to teleport back to the leader) is not set when FastReset is triggered manually via hotkey or slashcommand

## 1.6.0
- adding hotkey support

## 1.5.1
- extend the auto reset delay to 250ms from 100ms to avoid some rare cases of not fully resetting the instance
- adding some missing language strings

## 1.5.0
- introducing LibSlashCommander as OPTIONAL dependency - it now autocompletes and describes the commands

## 1.4.2
- clean up code
- fix some wrong comments
- fixed a bug where the a language string was not loaded correctly

## 1.4.1
- fixed that i missed the unregisterforevent after addon is loaded

## 1.4.0
- redesign addon setting menu
- option to enable port to uli house even if the ulti is full ( for players for example wearing Saxhleel & MA )

## 1.3.0
- fastresets now checks the real ultimate values needed instead of checking if its completly full
- fix a bug that asked the player to port to the leader even if they are already in the new instance

## 1.2.0
- adding chat commands to use the functionalities of this addon manually
- /fr = /fastreset
- /fr           : triggers the whole automation process manually
- /fr enable    : enables FastReset
- /fr disable   : disables FastReset
- /fr reset     : reset instance
- /fr ulti      : teleport to the predefined ulti-house
- /fr leader    : ports to your leader
- /fr leave     : exit the current instance
- adding some additional checks

## 1.1.0
- added message with the accountname of the player who died in chat

## 1.0.2
- fix a bug in the english client that crashes the "set house" button

## 1.0.1
- add support for non HodorReflexes users
- adding optional dependency ( HodorReflexes )

## 1.0.0
- Initial release