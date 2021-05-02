#!/bin/sh
#
# This hook script checks if a file has MKV extension and is already encoded to H265/x265. If all the conditions match, bypass it
# processing by just moving the file to the handbrake output folder. Not quite the brilliant solution, for it's just checking the
# encoding in the file name which is not the proper way. Still trying to figure it out how to add MediaInfo inside the HandBrake
# container to check it using the right tools.
#
# Author: Bruno Corrêa Frutuozo

CONVERTED_FILE="$1"
SOURCE_FILE="$2"
PRESET="$3"

echo "pre-conversion: Output File = $CONVERTED_FILE"
echo "pre-conversion: Source File = $SOURCE_FILE"
echo "pre-conversion: Preset = $PRESET"

EXTENSION="$(echo "${SOURCE_FILE##*.}" | tr '[:upper:]' '[:lower:]')"

# Using 'case' to prepare script in for multiple extensions workflow
case "$EXTENSION" in
    mkv)
        # Check for MKVs
        echo "MKV file detected. Checking for H265/x265 encoding..."
        EXTENSION="$(echo "${CONVERTED_FILE##*.}" | tr '[:upper:]' '[:lower:]')"
        if [ "$EXTENSION" = "mkv" ]; then
            LOWER_SOURCE_FILE="$(echo "${SOURCE_FILE##*/}" | tr '[:upper:]' '[:lower:]')"
            echo "Lower filename for encoding comparison: $LOWER_SOURCE_FILE"
            ENCODING=0
            RET="$(echo "$LOWER_SOURCE_FILE" | grep "h265")"
            if [ -n "$RET" ]; then
                echo "H265 encoding detected"
                ENCODING=1
                RET=""
            fi
            RET="$(echo "$LOWER_SOURCE_FILE" | grep "x265")"
            if [ -n "$RET" ]; then
                echo "x265 encoding detected"
                ENCODING=1
            fi
            if [ "$ENCODING" == 1 ]; then
                echo "File conversion not required, moving file..."
                mkdir -p "$(dirname "$CONVERTED_FILE")"
                mv "$SOURCE_FILE" "$CONVERTED_FILE"
                echo "File successfully moved to $CONVERTED_FILE"
            else
                echo "File is not H265/x265 encoded so it's added to the queue"
            fi
        fi
        ;;
esac
