import std/strutils
import std/sugar
import std/tables

import line_buffer
import utils
import config

## ## enum denoting different game phases were an error may have occurred
type
  ErrorPhase* = enum
    chainload # error occurred before all mods were loaded
    startup   # error occurred while mods were loading
    runtime   # error occurred after all mods were loaded
    shutdown  # error occurred while game was shutting down / resetting for a new run

## class designating a single instance of an error
type
  GungeonError* = ref object
    errorPhase* : ErrorPhase # when the error occurred for the first time within a specific log file
    errorType* : string # type of exception / error that occurred
    errorMod* : string # mod implicated by the error
    contents* : string # the raw contents of the error
    contentHash* : string # the hash of the raw contents of the error
    count* : int # number of times the error has occurred (mostly used by ProcessedLog)

## read in an exception from a line buffer
func readException*(li : LineBuffer) : GungeonError =
  let err : GungeonError = GungeonError()
  var lines : seq[string]
  while not li.done():
    let line : string = li.next().strip()
    if line.len() == 0:
      break
    if lines.len() == 0: # always unconditionally add the first line without further processing
      lines.add(line)
      continue
    if line[0] == '[': # lines beginning with a '[' mark an entirely new issue, so if we encounter it past the first line, that's a new error
      break
    if err.errorMod.len() == 0:
      let namespace : string = line.split(".")[0].strip().dup(removePrefix("at ")).strip()
      if namespace in namespaceToMod:
        err.errorMod = namespaceToMod[namespace]
      # see if we can determine the namespace of the source of the error
    lines.add(line)
  err.contents = lines.join("\n")
  err.contentHash = err.contents.strMd5()
  err.count = 1
  return err
