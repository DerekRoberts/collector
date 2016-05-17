#!/bin/bash
#
set -e -o nounset



# Pull and run image, removing when done
#
sudo docker pull healthdatacoalition/queryimporter:latest
sudo docker run --rm --name=queryimporter -h queryimporter --link composerdb:composerdb healthdatacoalition/queryimporter:latest

