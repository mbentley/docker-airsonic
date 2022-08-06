#!/bin/sh

set -e

echo "======================================"
echo "Starting airsonic initialization."

if [ ! -d /data/transcode ]
then
  echo "INFO - directory /data/transcode doesn't exist; creating..."
  mkdir /data/transcode
  cd /data/transcode
else
  echo "INFO - found directory /data/transcode"
fi

# make sure symlinks exist for binaries
for BIN in ffmpeg lame
do
  if [ ! -L "/data/transcode/${BIN}" ]
  then
    echo "INFO - symlink for ${BIN} doesn't exist; creating..."
    ln -s "/usr/bin/${BIN}" "/data/transcode/${BIN}"
  else
    echo "INFO - found symlink for ${BIN}"
  fi
done

echo "airsonic initialization complete!"
echo "======================================";echo

exec "${@}"
