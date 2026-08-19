#!/usr/bin/env bash
#Build the current project

# nim c --hints:off --colors:on --assertions:on -r src/tests/healthevent_tests.nim "::"
# # nim c --hints:off --colors:on --assertions:on -r src/tests/healthevent_tests.nim "HealthEvent::"
# [ "$1" == "-t" ] && exit 0 # -t means run tests only, so we're done
# nim c --hints:off --colors:on --assertions:on -r src/gungeon_log_database.nim
nim c --hints:off --colors:on --assertions:on --warning[UnusedImport]:off -o=./gld src/gungeon_log_database.nim
exit 0 # exit with a zero exit code from the build script itself so useless info doesn't spat out

# -d:dumpAllocstats
