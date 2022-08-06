#!/bin/sh

set -e

echo "======================================"
echo "Starting airsonic initialization."

if [ ! -d /data/transcode ]
then
  echo "INFO - Directory /data/transcode doesn't exist; creating..."
  mkdir /data/transcode
  cd /data/transcode
  ln -s /usr/bin/ffmpeg .
else
  echo "INFO - found directory /data/transcode"
fi

echo "airsonic initialization complete!"
echo "======================================";echo

exec "${@}"
