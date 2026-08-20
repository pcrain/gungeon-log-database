import std/re
import std/strutils
import std/tables
import std/sets

import processed_log
import mod_data
import gungeon_error
import line_buffer
import utils

## top level class managing all further processing
type
  LogDatabase* = ref object
    processedLogs : seq[ProcessedLog]

    didLoadLogs : bool = false # whether we've loaded all previous processed logs from disk
    didSetup : bool = false # whether our log database has been setup
    curPhase : ErrorPhase = ErrorPhase.chainload # the current phase the mod is processing

    gungeonVersionRX : Regex # regex for detecting the version of gungeon running
    bepinexVersionRX : Regex # regex for detecting the version of bepinex running
    platformRX : Regex # regex for detecting the OS running
    timestampRX : Regex # regex for detecting when a log was created
    patcherRX : Regex # regex for detecting whether we've found the MTG API patcher
    interfaceRX : Regex # regex for detecting the platform interface in the log
    modRX : Regex # regex for detecting a mod
    exceptionRX : Regex # regex for detecting an exception
    exceptionAltRX : Regex # alternate regex for detecting an exception
    oldMtgRX : Regex # regex for detecting MTG Classic / ETGMOD

func ensureSetup(db : LogDatabase) : void =
  if db.didSetup:
    return

  # set up regular expressions
  db.gungeonVersionRX = re"\[Info\s*:\s*Unity Log\] Version: ([0-9h\.]+)"
  db.bepinexVersionRX = re"\[Message\s*:\s*BepInEx\] BepInEx ([0-9\.]+) - .*"
  db.platformRX       = re"\[Info\s*:\s*BepInEx\] System platform: (.*)\s*"
  db.timestampRX      = re"\[Info\s*:\s*Unity Log\] Now: (.*)\s*"
  db.interfaceRX      = re".*Starting (.*) platform interface.\s*"
  db.patcherRX        = re"MTGAPIPatcher.mm.dll"
  db.modRX            = re"\[Info\s*:\s*BepInEx\] Loading \[(.*) ([0-9]+\.[0-9]+(?:\.[0-9]+)?)\]"
  db.exceptionRX      = re"\[Error\s*:\s*Unity Log\] ([^\s]*Exception)\s*:\s*(.*)"
  db.exceptionAltRX   = re"\[Message\s*:\s*ETG Console\] An error occured when doing ([^\s]+):\s*([^\s]+Exception)\s*: (.*)"
  db.oldMtgRX         = re"ETGMOD INIT"

  # finish up
  db.didSetup = true

func processException(db : LogDatabase, plog : ProcessedLog, li : LineBuffer, name : string, message : string) : void =
  let err : GungeonError = li.readException()
  err.errorType = name
  err.errorPhase = db.curPhase
  let errHash : string = err.contentHash
  if errHash in plog.uniqueErrors:
    plog.uniqueErrors[errHash].count += 1
  else:
    plog.uniqueErrors[errHash] = err
    plog.errorList.add(err)
  var s : HashSet[string]
  if err.errorMod.len() > 0:
    if db.curPhase == ErrorPhase.startup:
      plog.modsWithStartupErrors.incl(err.errorMod)
    elif db.curPhase == ErrorPhase.runtime:
      plog.modsWithRuntimeErrors.incl(err.errorMod)
  plog.totalErrorCount += 1

func processLogLines*(db : LogDatabase, lines : seq[string]) : void =
  db.ensureSetup()

  var plog : ProcessedLog = ProcessedLog()
  var matches : array[10, string]
  let li : LineBuffer = lines.createBuffer()
  while not li.done():
    let line : string = li.next()
    # scan for basic info
    if plog.bepinexVersion.len == 0 and line.match(db.bepinexVersionRX, matches):
      plog.bepinexVersion = matches[0]
      continue
    if plog.gungeonVersion.len == 0 and line.match(db.gungeonVersionRX, matches):
      plog.gungeonVersion = matches[0]
      continue
    if plog.os.len == 0 and line.match(db.platformRX, matches):
      plog.os = matches[0]
      continue
    if plog.timestamp.len == 0 and line.match(db.timestampRX, matches):
      plog.timestamp = matches[0].normalizeDate()
      continue
    if plog.platformInterface.len == 0 and line.match(db.interfaceRX, matches):
      plog.platformInterface = matches[0]
      continue
    if (not plog.foundMTGAPIPatcher) and (line.find(db.patcherRX) >= 0):
      plog.foundMTGAPIPatcher = true
      continue
    if (line.find(db.oldMtgRX) >= 0):
      plog.foundOldMTG = true
      continue
    if line.match(db.modRX, matches):
      plog.modList.add(createMod(name = matches[0], version = matches[1]))
      continue

    # check for signs of a patched dll
    if "MissingFieldException" in line:
      plog.patchedDll = true

    # two error variants: first catches startup error wrapped in try-catch blocks, second catches normal exceptions
    if line.match(db.exceptionAltRX, matches):
      db.processException(plog = plog, li = li.back(), name = matches[1], message = matches[2])
      continue
    if line.match(db.exceptionRX, matches):
      db.processException(plog = plog, li = li.back(), name = matches[0], message = matches[1])
      continue

    # scan for phase changes
    if "Chainloader startup complete" in line: # solidly past the mod loading phase
      db.curPhase = ErrorPhase.startup
    elif "Posting core music event: Play_MUS_Foyer_Theme_01" in line: # loading into the breach, all mods have finished setting up
      db.curPhase = ErrorPhase.runtime
    elif "DELETING CURRENT MID GAME SAVE" in line: # ending a run, a lot of modded items break here when destroying themsleves, but it's mostly harmless
      db.curPhase = ErrorPhase.shutdown
    elif "Succeeded generation iteration on: Foyer Flow" in line: # returning to breach / starting a new run
      if db.curPhase != ErrorPhase.startup: # this happens during mod initialization as well, so don't change phase then
        db.curPhase = ErrorPhase.runtime
    elif "Quick Restarting..." in line: # restarting a run
      db.curPhase = ErrorPhase.runtime

  plog.contentsHash = lines.seqMd5()
  db.processedLogs.add(plog)

func lastLog*(db : LogDatabase) : ProcessedLog =
  return db.processedLogs[^1]
