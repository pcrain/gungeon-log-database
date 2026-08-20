## TODO: all of this hardcoded stuff should be loadable from an external file

import std/tables

include config_helpers

const APPNAME : string = "gungeon-log-database"

const modToNamespace* = {
  # known mods with known namespaces
  "A Bleaker Item Pack"                    : "BleakMod",
  "Alexandria"                             : "Alexandria",
  "All Floors Safety"                      : "ETG_AllFloorsSafety",
  "Brutal Items"                           : "BrutalItems",
  "Children of Kaliber"                    : "Items",
  "Custom Characters Mod"                  : "CustomCharacters",
  "Custom Rooms"                           : "GungeonAPI", # :|
  "CustomItems"                            : "CustomItems", # Kyle's Custom Items
  "Cut Characters Reborn"                  : "ReturnUnusedCharacters",
  "Equillibrium"                           : "Equillibrium",
  "ExpandTheGungeon"                       : "ExpandTheGungeon",
  "Expanded Bossfights"                    : "ExpandBosses",
  "Free Oub Entrance"                      : "FreeOubEntrance",
  "Frost and Gunfire"                      : "FrostAndGunfireItems",
  "Frost and Gunfire2"                     : "FrostAndGunfireItems2",
  "Gundustrial Revolution"                 : "GunRev",
  "Gunfiguration"                          : "Gunfiguration",
  "GungeonCraft"                           : "CwaffingTheGungy",
  "GungeonGoVroom"                         : "GGV",
  "GungeonUnstuck"                         : "GungeonUnstuck",
  "Hat Loader"                             : "HatLoader",
  "Item Blacklist"                         : "ItemBlacklist",
  "ItemTips"                               : "ItemTipsMod",
  "JuneLib"                                : "JuneLib",
  "Justice"                                : "Justice",
  "Knife to a Gunfight"                    : "Knives",
  "League of legends Items"                : "LOLItems",
  "Little Guy"                             : "LittleGuy",
  "Loop The Gungeon"                       : "LoopTheGungeon",
  "Lord's Complementary Compilation"       : "LccMod",
  "MetaLimits"                             : "MetaLimits",
  "Miniboss Healthbars Reloaded"           : "MinibossHealthbarsReloaded",
  "Mod the Gungeon API"                    : "ModTheGungeonAPI",
  "Mod the Gungeon Classic"                : "ETGMod",
  "Modded Bugfix"                          : "ModdedBugFix",
  "Modded Magnet"                          : "ModdedMagnet",
  "Modular Custom Character"               : "ModularMod",
  "More Map Icons"                         : "MoreMapIcons",
  "Nerfed Mini Dragun"                     : "NerfedBabyDragun",
  "No Brain"                               : "NoBrain",
  "Oddments"                               : "Oddments",
  "Once More Into The Breach"              : "NevernamedsItems",
  "Planetside Of Gunymede Pre-Release"     : "Planetside",
  "Prismatism"                             : "katmod",
  "Punchout Anywhere!"                     : "PunchoutAnywhere",
  "Pushing The Limits"                     : "PushingTheLimits",
  "R3L0ADED CONTENT PACK"                  : "Reload",
  "RPGworld mod"                           : "RPGworldMod",
  "RatSolutions"                           : "RatSolutionsMod",
  "Receiver Expansion"                     : "ReceiverItems",
  "Reloaded HUD"                           : "ReloadedHUD",
  "Remove Base-Specific Breach CC Effects" : "RemoveBreachCharacterEffects",
  "Reskin Switcher"                        : "ReskinSwitcherMod",
  "Room Tool"                              : "RoomTool",
  "Silver Jacket"                          : "SilverJacket",
  "SimpleStatsTweaked"                     : "SimpleStatsTweaked",
  "Spawn Specific Chest Command"           : "SpawnSpecificChestCommand",
  "SpecialAPI's QoL"                       : "QoLMod",
  "The Reference Collection"               : "Dulsamthings",
  "TheGarbageCollector"                    : "TheGarbageCollector",
  "TheRatPack"                             : "TheRatPack",
  "The_Minstrel"                           : "Minstrel",
  "Weapon Wheel Select"                    : "RadialGunSelect",
  "What Mod Is This From (WMITF)"          : "WMITF",
  "[Retrash's] Custom Items Collection"    : "Blunderbeast",
  "[[ AmmonomiconAPI ]]"                   : "AmmonomiconAPI",

  # known mods with conflicting / confusing namespaces
  "Quality Colors"                         : "Mod",
  "Remove_LOJ"                             : "Mod",
  "No Enemy Health Scaling"                : "Mod",
  "Your Reward"                            : "Mod",
  "Optimize IMGUI GC allocations"          : "BepInEx",

  # known mods with unknown namespaces
  # none at the moment :D
}.toTable()

const namespaceToMod* = modToNamespace.reverseTable()
