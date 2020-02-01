# mbentley/airsonic

docker image for [airsonic](https://github.com/airsonic/airsonic)

To pull this image:
`docker pull mbentley/airsonic`

Example usage:

```
docker run -d \
  --restart unless-stopped \
  --name airsonic \
  -p 4040:4040 \
  -v airsonic:/data \
  mbentley/airsonic
````
