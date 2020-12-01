#!/bin/bash

# Made by SebbaIndustries
# This script builds and copies plugin jar to the plugins folder.
# Place it in main server directory!

# Project credentials
DEVELOPER="sebbaindustries"
PLUGIN="DynamicShop"
BRANCH="dev"

if [ -d "plugins" ]; then
  # shellcheck disable=SC2164
  cd plugins
else
  echo "Directory plugins not found, terminating!"
  exit
fi

# Remove old plugin .jar
if [ -f "${PLUGIN}.jar" ]; then
  echo "${PLUGIN}.jar exists, removing it!"
  rm ${PLUGIN}.jar
fi

# Script creates temporary build directory
TEMP_DIR="temp-${PLUGIN}-build-dir"

# Another script may be running in the same directory, this check is not necessary you can remove it.
if [ -d "$TEMP_DIR" ]; then
  echo "${TEMP_DIR} Exists, please delete it manually!"
  exit
fi

mkdir $TEMP_DIR
cd $TEMP_DIR || exit

# Clone the project
git clone https://github.com/${DEVELOPER}/${PLUGIN}/tree/${BRANCH}.git
# Move to the project main directory
cd $PLUGIN || exit

# Build the project, you can add additional flags here if you want
mvn

# Move to the target directory and remove .jar files that you don't want to copy
cd target || exit
rm *-sources.jar
rm original-*.jar

# Copy the plugin back to the plugin directory
cp *.jar ../../../${PLUGIN}.jar

# Move back to the base dir adn cleanup temporary build directory
cd ../../../
rm -rf $TEMP_DIR

echo "Done!"
