# create a new table from reversed key-value pairs from an existing table
proc reverseTable*[K, V](input: Table[K, V]): Table[V, K] {.compileTime.} =
  result = initTable[V, K]()
  for key, val in input.pairs:
    result[val] = key
