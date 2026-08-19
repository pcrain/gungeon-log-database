# class designating information about an individual mod / version
type
  ModData* = ref object
    name* : string # name of the mod
    version* : string # version of the mod

func createMod*(name : string, version : string) : ModData =
  var m : ModData = ModData()
  m.name = name
  m.version = version
  return m
