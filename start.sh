#!/bin/bash

STARTRAM=128
MAXRAM=6144
JARNAME=paper.jar
BUILD_VERSION_HOLDER=version_info.json

PROJECT="paper"
VERSION="1.16.4"

PARMS="
-server
-XX:+IgnoreUnrecognizedVMOptions
-XX:+UnlockExperimentalVMOptions
-XX:+UnlockDiagnosticVMOptions
-XX:+UseGCOverheadLimit
-XX:+ParallelRefProcEnabled
-XX:-OmitStackTraceInFastThrow
-XX:+ShowCodeDetailsInExceptionMessages
-XX:+UseCompressedOops
-XX:+PerfDisableSharedMem
"

ZGCP="
-XX:SoftMaxHeapSize=1G
"

PARMS="$PARMS -XX:+DisableExplicitGC -XX:-UseParallelGC -XX:-UseG1GC -XX:+UseZGC $ZGCP"

function generate_missing_sources() {
  if [ ! -f $BUILD_VERSION_HOLDER ]; then
    echo "-1" > "$BUILD_VERSION_HOLDER"
  fi

  if [ ! -f $JARNAME ]; then
    echo "-1" > "$BUILD_VERSION_HOLDER"
  fi
}

function updater() {
  echo "Checking for updates!"

  latest_build=$(curl --request GET -sL \
    --url "https://papermc.io/api/v2/projects/${PROJECT}/versions/${VERSION}/" | grep -E -o '[0-9]+' | tail -1)
  version_info=$(cat $BUILD_VERSION_HOLDER)

  echo "Latest build: ${latest_build}, current server version: ${version_info}"

  if [ "$version_info" -lt "$latest_build" ]; then
    echo "Updating server jar!"
    jarlink="https://papermc.io/api/v2/projects/${PROJECT}/versions/${VERSION}/builds/${latest_build}/downloads/${PROJECT}-${VERSION}-${latest_build}.jar"
    curl -s "$jarlink" > "$JARNAME"
    echo "$latest_build" > "$BUILD_VERSION_HOLDER"
  fi
}

function start() {
    echo "Starting!"
    # shellcheck disable=SC1001
    # shellcheck disable=SC2086
    java -Xms$STARTRAM\M -Xmx$MAXRAM\M $PARMS -jar $JARNAME --nogui
}

generate_missing_sources
updater
start
