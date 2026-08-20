#!/usr/bin/env bash
#Build the current project

build_flags="--hints:off --colors:on --assertions:on --warning[UnusedImport]:off"

if [ $# -eq 0 ]; then # CLI build
  nim c ${build_flags} -o=./gld src/gungeon_log_database.nim
elif [ "$1" == "-j" ]; then # javascript build
  nim js ${build_flags} -d:release -o=./analyzer.js src/gungeon_log_database.nim
  esbuild analyzer.js --bundle --minify --outfile=analyzer.min.js # remove dead code and minify
else
  echo "unknown build flag $1"
fi

exit 0 # exit with a zero exit code from the build script itself so useless info doesn't get spat out

# -d:dumpAllocstats
