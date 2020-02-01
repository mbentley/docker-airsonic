# mbentley/airsonic

docker image for [Airsonic](https://github.com/airsonic/airsonic)

To pull this image:
`docker pull mbentley/airsonic`

Example usage:

```
docker run -d \
  --restart unless-stopped \
  --name airsonic \
  -p 4040:4040 \
  -v airsonic-data:/data \
  mbentley/airsonic
````

See [Migrating from Subsonic to Airsonic](https://airsonic.github.io/docs/migrate/) for instructions on how to migrate from Subsonic or Libresonic to Airsonic
