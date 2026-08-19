# simple buffered reader over a sequence of strings

type
  LineBuffer* = ref object
    lines : seq[string]
    nextLine : int
    size : int

# create a new LineBuffer from a sequence of strings
func createBuffer*(ss : seq[string]) : LineBuffer =
  var b : LineBuffer = LineBuffer()
  b.lines = ss
  b.size = b.lines.len()
  b.nextLine = 0
  return b

# reset the LineBuffer to the beginning
func reset*(b : LineBuffer) : void =
  b.nextLine = 0

# check if the LineBuffer has any more strings
func done*(b : LineBuffer) : bool =
  return b.nextLine == b.size

# return the current string and advance to the next one
func next*(b : LineBuffer) : string =
  let s : string = b.lines[b.nextLine]
  b.nextLine += 1
  return s

# reset the iterator to the previous string
func back*(b : LineBuffer) : LineBuffer =
  b.nextLine -= 1
  return b
