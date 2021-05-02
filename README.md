# UNRAID-Handbrake-MKVH265bypass-Script
Handbrake script which bypass transcoding if a file already has MKV extension and is encoded to H265/x265.

Just add it to appdata/%Your-Handbrake-Container%/hooks/pre_conversion.sh

It's using the filename to check the codec info, which is not the right way. Still working on how to add MediaInfo inside the HandBrake container to handle it properly.
