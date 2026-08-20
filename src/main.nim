import std/cmdline
import std/strutils
import std/sequtils
import std/os except getDataDir
import std/strformat
import std/times

import utils
import log_database
import processed_log
import config

when defined(js):
  import std/dom
  import jsffi

  type FileReader* = ref object of EventTarget
    result*: cstring
    error*: ref RootObj
    readyState*: int
  proc newFileReader*(): FileReader {.importjs: "new FileReader()".}
  proc readAsText*(reader: FileReader, blob: ref RootObj) {.importjs: "#.readAsText(#)".}
  proc readAsDataURL*(reader: FileReader, blob: ref RootObj) {.importjs: "#.readAsDataURL(#)".}
  proc readAsArrayBuffer*(reader: FileReader, blob: ref RootObj) {.importjs: "#.readAsArrayBuffer(#)".}
  proc `onload=`(fr: FileReader, cb: proc(e: Event)) {.importcpp: "#.onload = #".}
  proc result(fr: FileReader): cstring {.importcpp: "#.result".}

  proc downloadHtml*() =
    # get the HTML content inside the element, after hiding the download button
    document.getElementById("upload-button").style.display = "none"
    document.getElementById("download-button").style.display = "none"
    let htmlContent = document.documentElement.outerHTML
    document.getElementById("download-button").style.display = "block"
    document.getElementById("upload-button").style.display = "block"

    # create a data URI scheme with utf-8 encoding
    let uri = "data:text/html;charset=utf-8," & encodeURIComponent(htmlContent)

    # create a hidden anchor element and trigger download
    let dateString : string = now().format("yyyy-MM-dd HH:mm:ss")
    let a = document.createElement("a")
    a.setAttribute("href", uri)
    a.setAttribute("download", ("gungeon-log-analysis-" & dateString & ".html").cstring())
    a.style.display = "none"

    document.body.appendChild(a)
    a.click()
    document.body.removeChild(a)

  proc handleFile(e: Event) =
    let fileInput = InputElement(document.getElementById("upload-button"))
    if fileInput.files.len == 0:
      return
    let reader = newFileReader()
    reader.onload = proc(ev: Event) =
      let content : string = $reader.result
      var db : LogDatabase = LogDatabase()
      db.processLog(content)
      let summary : seq[string] = db.lastLog().summarize()
      # clear other elements
      document.getElementById("prompt").innerHTML = ""
      document.getElementById("legend").innerHTML = ""
      document.getElementById("download-button").style.display = "block"
      # print the summary
      document.getElementById("log-summary").innerHTML = summary
        .mapIt(it.ansiToHTML())     # replace ANSI escape codes with proper HTML spans
        .join("\n")                 # join everything on newlines
        .replace("<hr/>\n","<hr/>") # replace rule + newlines combos with just the rules
        .cstring()                  # convert to a usable cstring
    reader.readAsText(fileInput.files[0])

  proc main =
    document.getElementById("download-button").addEventListener("click", proc(e: Event) = downloadHtml(), false)
    let fileInput = document.getElementById("upload-button")
    fileInput.addEventListener("change", handleFile, false)
else:
  proc main =
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
    let logLines : string = infile.readFile()

    var db : LogDatabase = LogDatabase()
    db.processLog(logLines)
    let summary : seq[string] = db.lastLog().summarize()
    echo summary.join("\n")

main()
