import std/times
import std/paths
import std/os
import std/logging
import std/strutils
import std/sequtils
import std/parseutils
import std/json
import std/tables
import std/options
import std/macros
import std/strformat
import std/enumerate

import checksums/md5 # from nimble

include js_compat # keep js compatibility stuff to a different file
include utils_oneliners # keep one liners in a separate file

## set up logging if it hasn't already been set up
proc startLogging*(): void =
  var setupLogging {.global.}: bool = false
  if setupLogging:
    return

  addHandler(newConsoleLogger(fmtStr="[$datetime] $levelid: "))
  setupLogging = true

## read all lines from a file into a sequence of strings
func splitLinesAndNormalize*(content: string) : seq[string] =
  return content.splitLines().toSeq().mapIt(it.strip())

## get MD5 from a sequence of strings
func seqMd5*(lines : seq[string]) : string =
  {.cast(noSideEffect).}: # HACK: MD5 modifies internal state so the compiler treats it as having side effects when it doesn't
    return lines.join("\n").getMd5()

## get MD5 from a string
func strMd5*(line : string) : string =
  {.cast(noSideEffect).}: # HACK: MD5 modifies internal state so the compiler treats it as having side effects when it doesn't
    return line.getMd5()

## normalize the date output by gungeon's timestamps
func normalizeDate*(s : string) : string =
  var matches : array[5, string]
  if not s.creMatch(creCompile(r"([0-9][0-9]).([0-9][0-9]).([0-9][0-9][0-9][0-9]) ([0-9][0-9]):([0-9][0-9])"), matches):
    return s
  return matches[2] & "-" & matches[0] & "-" & matches[1] & "_" & matches[3] & "-" & matches[4] & "-00"

## format a gungeon error / exception in a readable format
func formatGungeonError*(s : string, indent : int) : string =
  let istring : string = ' '.repeat(indent)
  return s.splitLines().mapIt(istring & it).join("\n")

## compare semantic version strings and verify s is at least m
func goodIfVersionAtLeast*(s : string, m : string) : string =
  let ss : seq[string] = s.split('.')
  let ms : seq[string] = m.split('.')
  let ntokens : int  = min(ss.len, ms.len)
  for i in 0..<ntokens:
    if ss[i] < ms[i]:
      return s.inRed()
    if ss[i] > ms[i]:
      return s.inGreen()
  return s.inGreen()

when not defined(js):
  ## string ansi codes from a string
  func stripAnsi*(str: string): string =
    let ansiRegex = creCompile(r"(\x9B|\x1B\[)[0-?]*[ -\/]*[@-~]")
    return str.replace(ansiRegex, "")

  ## get the length of an ansi-colored string after stripping the colors away
  func lenSansColors(s : string) : int =
    return s.stripAnsi().len()
