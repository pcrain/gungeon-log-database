# regex compatibility

when defined(js):
  import std/jsre
  type CommonRegex* = RegExp
else:
  import std/re
  type CommonRegex* = Regex

func creCompile*(s : string, flags : string = "") : CommonRegex =
  when defined(js):
    return newRegExp(s, flags)
  else:
    return re(s)

func creMatch*(s : string, pattern : CommonRegex, matches : var openArray[string]) : bool =
  when defined(js):
    let jsMatches : seq[cstring] = s.match(pattern)
    for i, val in enumerate(jsMatches):
      if i > 0:
        matches[i - 1] = $val
    return jsMatches.len() > 0
  else:
    return s.match(pattern, matches)

func creFind*(s : string, pattern : CommonRegex) : bool =
  when defined(js):
    return s.contains(pattern)
  else:
    return s.find(pattern) >= 0

# ansi to HTML helper
when defined(js):
  const ansiTable : Table[string, string] = {
    "\x1B[30;1m"           : "<span class=d>",
    "\x1B[31;1m"           : "<span class=r>",
    "\x1B[32;1m"           : "<span class=g>",
    "\x1B[33;1m"           : "<span class=y>",
    "\x1B[34;1m"           : "<span class=b>",
    "\x1B[35;1m"           : "<span class=m>",
    "\x1B[36;1m"           : "<span class=c>",
    "\x1B[41;1m"           : "<span class=x>",
    "\x1B[38;2;255;121;1m" : "<span class=o>",
    "\x1B[42;30;2m"        : "<span class=v>",
    "\x1B[0m"              : "</span>",
  }.toTable()
  func ansiToHTMLReplace(args: varargs[cstring]): cstring =
    let fullMatch : string = args.join("")
    return ansiTable.getOrDefault(fullMatch, fullMatch).cstring()
  func ansiToHTML*(s : string) : string =
    var matches : array[10, string]
    let ansiRegex = creCompile(r"((?:\x9B|\x1B\[)[0-?]*[ -\/]*[@-~])", "g")
    # if not s.creMatch(ansiRegex, matches):
    #   return s
    return $s.replace(ansiRegex, cb = ansiToHTMLReplace)
    # return fmt"""<span style='color:red'>{s}</span>"""
