# import std/asynchttpserver
import std/asyncdispatch
# import std/json
# import std/assertions
import std/cmdline
import std/strutils
# import std/appdirs
import std/os except getDataDir
import std/strformat

import utils
import log_database
import processed_log

const VERSION : string = "0.0.1"

proc main {.async.} =
  startLogging()

  let args : seq[string] = commandLineParams()
  if args.len() < 1:
    echo "Not enough arguments"
    return

  let infile : string = args[0]
  if not fileExists(infile):
    echo fmt"File {infile} does not exist"
    return

  echo fmt"processing file {infile}"
  var db : LogDatabase = LogDatabase()
  db.processLogLines(infile.readFile().splitLinesAndNormalize())
  db.lastLog().summarize()

waitFor main()
