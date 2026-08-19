## text colorization helpers
func inBlack*(s : string) : string = "\e[30;1m" & s & "\e[0m"
func inRed*(s : string) : string = "\e[31;1m" & s & "\e[0m"
func inGreen*(s : string) : string = "\e[32;1m" & s & "\e[0m"
func inYellow*(s : string) : string = "\e[33;1m" & s & "\e[0m"
func inBlue*(s : string) : string = "\e[34;1m" & s & "\e[0m"
func inMagenta*(s : string) : string = "\e[35;1m" & s & "\e[0m"
func inCyan*(s : string) : string = "\e[36;1m" & s & "\e[0m"
func goodIfFound*(found : bool) : string = (if found: "Found".inGreen() else: "Not Found".inRed())
func badIfFound*(found : bool) : string = (if found: "Found".inRed() else: "Not Found".inGreen())
func goodIfMatches*(s : string, m : string) : string = (if s == m: s.inGreen() else: s.inRed())
func badIfMatches*(s : string, m : string) : string = (if s != m: s.inGreen() else: s.inRed())
func badIfTrue*(s : string, b : bool) : string = (if b: s.inRed() else: s)
