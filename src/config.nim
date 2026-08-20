## TODO: all of this hardcoded stuff should be loadable from an external file

import std/tables
import std/strutils

import utils

include config_helpers

const APPNAME : string = "gungeon-log-database"

const modToNamespace* : Table[string, string] = {
  # known mods with known namespaces
  "A Bleaker Item Pack"                          : "BleakMod",
  "Alexandria"                                   : "Alexandria",
  "All Floors Safety"                            : "ETG_AllFloorsSafety",
  "Always Doug"                                  : "AlwaysDoug",
  "Auto-Reload"                                  : "AutoReload",
  "BetterShop"                                   : "BetterShop",
  "BlammCo Catalogue"                            : "TF2Stuff",
  "Brutal Items"                                 : "BrutalItems",
  "Children of Kaliber"                          : "Items",
  "Controller Aimer"                             : "ControllerAimer",
  "Custom Characters Mod"                        : "CustomCharacters",
  "Custom Rooms"                                 : "GungeonAPI", # :|
  "CustomItems"                                  : "CustomItems", # Kyle's Custom Items
  "Cut Characters Reborn"                        : "ReturnUnusedCharacters",
  "Emulate the Gungeon"                          : "EmulateTheGungeon",
  "Equillibrium"                                 : "Equillibrium",
  "ExpandTheGungeon"                             : "ExpandTheGungeon",
  "Expanded Bossfights"                          : "ExpandBosses",
  "Free Gunslinger And Paradox"                  : "RevolutionPricing",
  "Free Oub Entrance"                            : "FreeOubEntrance",
  "Frost and Gunfire"                            : "FrostAndGunfireItems",
  "Frost and Gunfire2"                           : "FrostAndGunfireItems2",
  "Gundustrial Revolution"                       : "GunRev",
  "Gunfiguration"                                : "Gunfiguration",
  "Gungeon Cult of the Lamb"                     : "GungeonCOTL",
  "GungeonCraft"                                 : "CwaffingTheGungy",
  "GungeonGoVroom"                               : "GGV",
  "GungeonLogArchiver"                           : "GungeonLogArchiver",
  "GungeonUnstuck"                               : "GungeonUnstuck",
  "Hat Loader"                                   : "HatLoader",
  "Imposter Items"                               : "ImposterItems", # Crewmate Custom Character
  "Item Blacklist"                               : "ItemBlacklist",
  "ItemTips"                                     : "ItemTipsMod",
  "Jolly Coop"                                   : "JollyCoop",
  "JuneLib"                                      : "JuneLib",
  "Justice"                                      : "Justice",
  "Knife to a Gunfight"                          : "Knives",
  "League of legends Items"                      : "LOLItems",
  "Little Guy"                                   : "LittleGuy",
  "Loop The Gungeon"                             : "LoopTheGungeon",
  "Lord's Complementary Compilation"             : "LccMod",
  "LuckyChest"                                   : "LuckyChest",
  "MetaLimits"                                   : "MetaLimits",
  "Miniboss Healthbars Reloaded"                 : "MinibossHealthbarsReloaded",
  "Mod the Gungeon API"                          : "ModTheGungeonAPI",
  "Mod the Gungeon Classic"                      : "ETGMod",
  "Modded Bugfix"                                : "ModdedBugFix",
  "Modded Magnet"                                : "ModdedMagnet",
  "Modular Custom Character"                     : "ModularMod",
  "More Map Icons"                               : "MoreMapIcons",
  "Nerfed Mini Dragun"                           : "NerfedBabyDragun",
  "No Blasphemy Beam Shader"                     : "GungeonNoBlasphemyBeamShader",
  "No Brain"                                     : "NoBrain",
  "NoMoreRatCostume"                             : "NoMoreRatCostume",
  "Oddments"                                     : "Oddments",
  "Once More Into The Breach"                    : "NevernamedsItems",
  "Planetside Of Gunymede Pre-Release"           : "Planetside",
  "PreventJammedCompanions"                      : "PreventJammedCompanions",
  "Prismatism"                                   : "katmod",
  "Punchout Anywhere!"                           : "PunchoutAnywhere",
  "Pushing The Limits"                           : "PushingTheLimits",
  "R3L0ADED CONTENT PACK"                        : "Reload",
  "RPGworld mod"                                 : "RPGworldMod",
  "Randomised Familiar Shaders"                  : "RandomisedFamiliarShaders",
  "RatSolutions"                                 : "RatSolutionsMod",
  "Receiver Expansion"                           : "ReceiverItems",
  "Reloaded HUD"                                 : "ReloadedHUD",
  "Remove Base-Specific Breach CC Effects"       : "RemoveBreachCharacterEffects",
  "Reskin Switcher"                              : "ReskinSwitcherMod",
  "Revive Mod"                                   : "ReviveMod",
  "Room Tool"                                    : "RoomTool",
  "Silver Jacket"                                : "SilverJacket",
  "SimpleStats"                                  : "simplestats",
  "SimpleStatsTweaked"                           : "SimpleStatsTweaked",
  "Spawn Specific Chest Command"                 : "SpawnSpecificChestCommand",
  "SpecialAPI's QoL"                             : "QoLMod",
  "Static Cam : BepinEx Edition!"                : "StaticCam",
  "Steamroller"                                  : "Steamroller",
  "SynergyGungeon"                               : "SynergyGungeon",
  "The Grin Reaper"                              : "TheGrinReaper",
  "The Hivemind Pack (GCC 1)"                    : "SpecialGunJam2022",
  "The Reference Collection"                     : "Dulsamthings",
  "TheGarbageCollector"                          : "TheGarbageCollector",
  "TheRatPack"                                   : "TheRatPack",
  "The_Minstrel"                                 : "Minstrel",
  "Unfinish the Gun"                             : "UnfinishTheGun",
  "Vammopires"                                   : "Vammopires",
  "Weapon Wheel Select"                          : "RadialGunSelect",
  "What Gun Class Is It From (Bepinex Edition!)" : "WhatGunClassIsItFrom",
  "What Mod Is This From (WMITF)"                : "WMITF",
  "Zoom Camera"                                  : "ZoomCamera", # by LSQ, surprisingly hard to find on Thunderstore
  "[Retrash's] Custom Items Collection"          : "Blunderbeast",
  "[[ AmmonomiconAPI ]]"                         : "AmmonomiconAPI",
  "~~ Miku Miku Mod ~~"                          : "MikuMikuMod",

  # known mods with conflicting / confusing namespaces
  "Dax Mod"                                      : "Mod",
  "Quality Colors"                               : "Mod",
  "Remove_LOJ"                                   : "Mod",
  "No Enemy Health Scaling"                      : "Mod",
  "Your Reward"                                  : "Mod",
  "Optimize IMGUI GC allocations"                : "BepInEx",

  # known mods with unknown namespaces
  # none at the moment :D

  # unknown mods that have shown up in logs
  # none at the moment :D
}.toTable()

# reverse the table for a reverse lookup
const namespaceToMod* : Table[string, string] = modToNamespace.reverseTable()

# tags for various mods
const RETIRED*     : string = "Retired".inCyan()        # mod author is retired from modding and mod is unlikely to receive updates
const OUTDATED*    : string = "Outdated".inYellow()     # mod has been replaced by a better alternative and is discouraged from use
const DEPRECATED*  : string = "Deprecated".inYellow()   # mod is deprecated on Thunderstore and is discouraged from use
const UNSTABLE*    : string = "Unstable".inMagenta()    # mod has severe problems and is highly discouraged from use
const BROKEN*      : string = "Broken".inRed()          # mod does not do what it advertises and is advised to immediately be uninstalled until fixed
const DISRUPTIVE*  : string = "Disruptive".inCritical() # mod actively disrupts gameplay / othermods and is advised to immediately be uninstalled until fixed

# tag lookup table for mods
const modTags* : Table[string, seq[string]] = {
  "Auto-Reload"                         : @[OUTDATED],          # use Gunfig
  "Children of Kaliber"                 : @[RETIRED],
  "CustomItems"                         : @[RETIRED],
  "Emulate the Gungeon"                 : @[DISRUPTIVE],        # has a startup failure + other issues that prevent other mods from initializing
  "Frost and Gunfire"                   : @[RETIRED],
  "Oddments"                            : @[RETIRED],
  "Prismatism"                          : @[UNSTABLE, RETIRED],
  "Reloaded HUD"                        : @[OUTDATED, RETIRED], # use SimpleStatsTweaked
  "Revive Mod"                          : @[BROKEN],            # does not use MtGAPI, looks poorly llm-generated, chainload failure (IteratorStateMachineAttribute)
  "SimpleStats"                         : @[OUTDATED, RETIRED], # use SimpleStatsTweaked
  "SynergyGungeon"                      : @[DISRUPTIVE],        # does very expensive reflected checks in the background constantly
  "TheGarbageCollector"                 : @[OUTDATED],          # use Gungeon Go Vroom
  "Weapon Wheel Select"                 : @[OUTDATED, RETIRED], # use Weapon Wheel 2
  "[Retrash's] Custom Items Collection" : @[RETIRED],
}.toTable()
