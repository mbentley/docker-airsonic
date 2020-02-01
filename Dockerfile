FROM alpine:latest
MAINTAINER Matt Bentley <mbentley@mbentley.net>

# install ca-certificates, ffmpeg, and java8
RUN (apk --no-cache add ca-certificates ffmpeg ttf-dejavu openjdk8 wget jq)

# set airsonic major version
ENV AIRSONIC_MAJOR_VER="10"

# create airsonic user
RUN (mkdir /var/airsonic &&\
  addgroup -g 504 airsonic &&\
  adduser -h /var/airsonic -D -u 504 -g airsonic -G airsonic -s /sbin/nologin airsonic &&\
  chown -R airsonic:airsonic /var/airsonic)

# get latest airsonic version from GitHub, check to make sure it hasn't passed the AIRSONIC_MAJOR_VER and install airsonic.war from https://github.com/airsonic/airsonic
RUN (AIRSONIC_VER="$(wget -q -O - https://api.github.com/repos/airsonic/airsonic/releases/latest | jq -r .tag_name)" &&\
  if [ "$(echo $AIRSONIC_VER | awk -F '.' '{print $1}')" != "v${AIRSONIC_MAJOR_VER}" ]; then echo "Latest version number is no longer ${AIRSONIC_MAJOR_VER}"; exit 1; fi &&\
  wget "https://github.com/airsonic/airsonic/releases/download/${AIRSONIC_VER}/airsonic.war" -O /var/airsonic/airsonic.war &&\
  chown airsonic:airsonic /var/airsonic/airsonic.war)

# create transcode folder and add ffmpeg
RUN (mkdir /var/airsonic/transcode &&\
  ln -s /usr/bin/ffmpeg /var/airsonic/transcode/ffmpeg &&\
  chown -R airsonic:airsonic /var/airsonic/transcode)

# create data directories and symlinks to make it easier to use a volume
RUN (mkdir /data &&\
  cd /data &&\
  mkdir db index16 lucene2 lastfmcache thumbs music Podcast playlists .cache .java &&\
  touch airsonic.properties airsonic.log rollback.sql &&\
  cd /var/airsonic &&\
  ln -s /data/db &&\
  ln -s /data/index16 &&\
  ln -s /data/lucene2 &&\
  ln -s /data/lastfmcache &&\
  ln -s /data/thumbs &&\
  ln -s /data/music &&\
  ln -s /data/Podcast &&\
  ln -s /data/playlists &&\
  ln -s /data/.cache &&\
  ln -s /data/.java &&\
  ln -s /data/airsonic.properties &&\
  ln -s /data/airsonic.log &&\
  ln -s /data/rollback.sql &&\
  chown -R airsonic:airsonic /data)

COPY entrypoint.sh /entrypoint.sh

USER airsonic
WORKDIR /var/airsonic
EXPOSE 4040
VOLUME ["/data"]

ENTRYPOINT ["/entrypoint.sh"]
CMD ["java","-Dserver.address=0.0.0.0","-Dserver.port=4040","-Dserver.contextPath=/","-Djava.awt.headless=true","-jar","/var/airsonic/airsonic.war"]
