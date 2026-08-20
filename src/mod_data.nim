import std/tables

import config

# class designating information about an individual mod / version
type
  ModData* = ref object
    name* : string # name of the mod
    version* : string # version of the mod
    known* : bool # whether the mod is known
    tags* : seq[string] # tags for mod

func createMod*(name : string, version : string) : ModData =
  var m : ModData = ModData()
  m.name = name
  m.version = version
  m.known = name in modToNamespace
  m.tags = modTags.getOrDefault(name, @[])
  return m
