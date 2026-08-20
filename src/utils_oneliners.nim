## text colorization helpers

func inBlack*(s : string) : string = "\e[30;1m" & s & "\e[0m"
func inRed*(s : string) : string = "\e[31;1m" & s & "\e[0m"
func inGreen*(s : string) : string = "\e[32;1m" & s & "\e[0m"
func inYellow*(s : string) : string = "\e[33;1m" & s & "\e[0m"
func inOrange*(s : string) : string = "\e[38;2;255;121;1m" & s & "\e[0m"
func inBlue*(s : string) : string = "\e[34;1m" & s & "\e[0m"
func inMagenta*(s : string) : string = "\e[35;1m" & s & "\e[0m"
func inCyan*(s : string) : string = "\e[36;1m" & s & "\e[0m"
func inCritical*(s : string) : string = "\e[41;1m" & s & "\e[0m"
func inDanger*(s : string) : string = "\e[42;30;2m" & s & "\e[0m"
func goodIfFound*(found : bool) : string = (if found: "Found".inGreen() else: "Not Found".inRed())
func badIfFound*(found : bool) : string = (if found: "Found".inRed() else: "Not Found".inGreen())
func terribleIfFound*(found : bool, warn: string) : string = (if found: ("Found" & warn).inCritical() else: "Not Found".inGreen())
func terribleIfNotFound*(found : bool, warn: string) : string = (if found: "Found".inGreen() else: ("Not Found" & warn).inCritical())
func goodIfMatches*(s : string, m : string) : string = (if s == m: s.inGreen() else: s.inRed())
func terribleIfNotMatches*(s : string, m : string, warn: string) : string = (if s == m: s.inGreen() else: (s & warn).inCritical())
func goodIfMatchesElseNeutral*(s : string, m : string) : string = (if s == m: s.inGreen() else: s.inCyan())
func badIfMatches*(s : string, m : string) : string = (if s != m: s.inGreen() else: s.inRed())
func badIfTrue*(s : string, b : bool) : string = (if b: s.inRed() else: s)
func badIfYes*(b : bool) : string = (if b: "Yes".inRed() else: "No".inGreen())
func terribleIfYes*(b : bool, warn: string) : string = (if b: ("Yes" & warn).inCritical() else: "No".inGreen())
func warnIfEmpty*(s : string, ifEmpty: string) : string = (if s.len() > 0: s else: ifEmpty.inMagenta())
