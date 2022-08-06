#!/bin/sh

set -e

echo "======================================"
echo "Starting airsonic initialization."

if [ ! -d /data/transcode ]
then
  echo "INFO - Directory /data/transcode doesn't exist; creating..."
  mkdir /data/transcode
  cd /data/transcode

  # make sure symlinks exist for binaries
  for BIN in ffmpeg lame
  do
    if [ ! -L "/usr/bin/${BIN}" ]
    then
      echo "INFO - Symlink for ${BIN} doesn't exist; creating..."
      ln -s "/usr/bin/${BIN}" .
    fi
  done
else
  echo "INFO - found directory /data/transcode"
fi

echo "airsonic initialization complete!"
echo "======================================";echo

exec "${@}"
