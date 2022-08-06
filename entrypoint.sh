#!/bin/sh

set -e

echo "======================================"
echo "Starting airsonic initialization."

if [ ! -d /data ]
then
  echo "Directory /data doesn't exist; this is not expected!"
  exit 1
else
  echo "INFO - found directory /data"
fi

(cd /data
for DIR in db index18 lucene2 lastfmcache thumbs music Podcast playlists .cache .java
do
  if [ ! -d "${DIR}" ]
  then
    printf "WARN - %s directory missing; creating..." ${DIR}
    mkdir "${DIR}"
    echo "done"
  else
    echo "INFO - found directory ${DIR}"
  fi
done

for FILE in airsonic.properties rollback.sql
do
  if [ ! -f "${FILE}" ]
  then
    printf "WARN - %s file missing; creating..." ${FILE}
    touch "${FILE}"
    echo "done"
  else
    echo "INFO - found file ${FILE}"
  fi
done)

echo "airsonic initialization complete!"
echo "======================================";echo

exec "${@}"
