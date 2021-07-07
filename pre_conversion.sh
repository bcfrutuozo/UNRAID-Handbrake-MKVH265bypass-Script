#!/bin/sh
#
# This is an example of a pre-conversion hook.  This script is always invoked
# with /bin/sh (shebang ignored).
#
# The first parameter is the full path where the video will be converted.
#
# The second parameter is the full path to the source file.
#
# The third argument is the name of the HandBrake preset that will be used to
# convert the video.
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
            RET="$(mediainfo "$LOWER_SOURCE_FILE" | grep -oh -m 1 "HEVC")"
            if [ -n "$RET" ]; then
                echo "HEVC encoding detected!"
                echo "File conversion not required, moving file..."
                mkdir -p "$(dirname "$CONVERTED_FILE")"
                mv "$SOURCE_FILE" "$CONVERTED_FILE"
                echo "File successfully moved to $CONVERTED_FILE"
            else
                echo "File is not HEVC encoded. Added it to the processing!"
            fi
        fi
        ;;
esac