## TODO: all of this hardcoded stuff should be loadable from an external file

import std/tables

proc reverseTable*[K, V](input: Table[K, V]): Table[V, K] {.compileTime.} =
  result = initTable[V, K]()
  for key, val in input.pairs:
    result[val] = key

const confNamespaceMap* = {
  "RPGworldMod"  : "RPGworld mod",
  "SilverJacket" : "Silver Jacket",
  "TheRatPack"   : "TheRatPack",
  "Reload"       : "R3L0ADED CONTENT PACK",
  "Planetside"   : "Planetside Of Gunymede Pre-Release",
  "Blunderbeast" : "[Retrash's] Custom Items Collection",
  "BleakMod"     : "A Bleaker Item Pack",
  "ModularMod"   : "Modular Custom Character",
  "Items"        : "Children of Kaliber",
}.toTable()

const confNamespaceReverseMap = confNamespaceMap.reverseTable()
