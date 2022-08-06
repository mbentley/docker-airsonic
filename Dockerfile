# rebased/repackaged base image that only updates existing packages
FROM mbentley/alpine:latest
LABEL maintainer="Matt Bentley <mbentley@mbentley.net>"

# install ca-certificates, ffmpeg, and java8
RUN apk --no-cache add ca-certificates ffmpeg ttf-dejavu openjdk8 wget jq

ARG AIRSONIC_VER
ARG AIRSONIC_MAJOR_VER="10"

# create airsonic user
RUN mkdir /data /opt/airsonic &&\
  addgroup -g 504 airsonic &&\
  adduser -h /data -D -u 504 -g airsonic -G airsonic -s /sbin/nologin airsonic &&\
  chown -R airsonic:airsonic /data /opt/airsonic

# TODO: move to https://github.com/airsonic-advanced/airsonic-advanced/
# get latest airsonic version from GitHub, check to make sure it hasn't passed the AIRSONIC_MAJOR_VER and install airsonic.war from https://github.com/airsonic/airsonic
RUN AIRSONIC_VER="$(if [ -z "${AIRSONIC_VER}" ]; then wget -q -O - https://api.github.com/repos/airsonic/airsonic/releases/latest | jq -r .tag_name; else echo "${AIRSONIC_VER}"; fi)" &&\
  if [ "$(echo "${AIRSONIC_VER}" | awk -F '.' '{print $1}')" != "v${AIRSONIC_MAJOR_VER}" ]; then echo "Latest version number is no longer ${AIRSONIC_MAJOR_VER}"; exit 1; fi &&\
  wget -q "https://github.com/airsonic/airsonic/releases/download/${AIRSONIC_VER}/airsonic.war" -O /opt/airsonic/airsonic.war &&\
  chown airsonic:airsonic /opt/airsonic/airsonic.war

# create transcode folder and add ffmpeg
RUN mkdir /data/transcode &&\
  ln -s /usr/bin/ffmpeg /data/transcode/ffmpeg &&\
  chown -R airsonic:airsonic /data/transcode

COPY entrypoint.sh /entrypoint.sh

USER airsonic
WORKDIR /data
EXPOSE 4040
VOLUME ["/data"]

ENTRYPOINT ["/entrypoint.sh"]
CMD ["java","-Dserver.address=0.0.0.0","-Dairsonic.home=/data","-Dserver.port=4040","-Dserver.contextPath=/","-Djava.awt.headless=true","-jar","/opt/airsonic/airsonic.war"]
