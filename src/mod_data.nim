import std/tables

import config

# class designating information about an individual mod / version
type
  ModData* = ref object
    name* : string # name of the mod
    version* : string # version of the mod
    known* : bool # whether the mod is a known mod
    disruptive* : bool # whether the mod is known to be disruptive
    malware* : bool # whether the mod is known to be malware
    tags* : seq[string] # tags for mod

func createMod*(name : string, version : string) : ModData =
  var m : ModData = ModData()
  m.name = name
  m.version = version
  m.known = name in modToNamespace
  m.tags = modTags.getOrDefault(name, @[])
  m.disruptive = (m.tags.len() > 0) and (m.tags[0] == DISRUPTIVE)
  m.malware = (m.tags.len() > 0) and (m.tags[0] == MALWARE)
  return m
