#!/bin/bash

# Lager et docker volume
# Bruker en midlertidig container "hello-world" for å kunne opprette volumet.
# Legger til alle filer fra hele mappen inn i dockerimaget

docker container create --name temp-container -v testvolume:/shared-volume hello-world
docker cp "." temp-container:/shared-volume
echo "deleting temp docker container"
docker rm temp-container

APPLICATION_NAME=md2cf-cli
IMAGE_NAME="bragalund/md2cf:1.0.0" 
TAG=latest

docker build --tag $IMAGE_NAME -f Dockerfile_with_all .

docker run --rm -i -v=testvolume:/shared-volume busybox find / -iname "README.md"

docker run --rm -v=testvolume:/shared-volume -e no_proxy=your.confluence.com -e ENV_TOKEN='NTU5MTc1NDI0NjgyOrT6jdrwcBFo4NbT0FTS0SMnWvvU' -e ENV_PAGEID=265977942 -e ENV_README_PATH='/shared-volume/README.md' $IMAGE_NAME


docker volume rm testvolume
