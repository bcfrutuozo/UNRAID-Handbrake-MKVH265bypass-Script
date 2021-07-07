# UNRAID-Handbrake-MKVH265bypass-Script
Handbrake script which bypass transcoding if a file already has MKV extension and is encoded to H265/x265.

Just add it to appdata/%Your-Handbrake-Container%/hooks/pre_conversion.sh

It's necessary to install the docker image (tested only with jlesage/handbrake) with the following Enviroment Variable:

  AUTOMATED_CONVERSION_INSTALL_PKGS=mediainfo
  
By doing it so, the image will be deployed along with the **mediainfo** Alpine Linux binary, which is necessary because the script will use it to check the video header contents to get the correct encoding format for the workflow.
