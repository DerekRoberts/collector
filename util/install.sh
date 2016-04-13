#!/bin/bash
#
set -e -o nounset


# Set build type or flag for prompt
#
TYPE=${1:-"PROMPT"}


# Prompt for build type, unless specified
#
if [ "${TYPE}" = "PROMPT" ]
then
  echo
  echo
  echo "This will stop and rebuild the Collector Stack"
  echo
  echo "Please see https://hub.docker.com/u/healthdatacoalition/"
  echo
  echo "prod       = production images"
  echo "latest     = latest (master) images"
  echo "dev        = development images"
  echo
  echo "prodPlus   + config from dev/dev.yml"
  echo "latestPlus "
  echo "devPlus    "
  echo
  echo "Please enter a build type, as above, or anything else to cancel."
  read TYPE
  echo
fi


# Set build details
#
if [ "${TYPE}" = "prod" ]
then
  TAG=prod
  MODE=prod
elif [ "${TYPE}" = "latest" ]
then
  TAG=latest
  MODE=prod
elif [ "${TYPE}" = "dev" ]
then
  TAG=dev
  MODE=prod
elif [ "${TYPE}" = "prodPlus" ]
then
  TAG=prod
  MODE=dev
elif [ "${TYPE}" = "latestPlus" ]
then
  TAG=latest
  MODE=dev
elif [ "${TYPE}" = "devPlus" ]
then
  TAG=dev
  MODE=dev
else
  echo "No build mode specified.  Exiting."
  echo
  exit
fi


# Deploy and inform
#
cd ..
TAG=${TAG} MODE=${MODE} make deploy
echo
echo "Complete.  TYPE=${TYPE}, TAG=${TAG}, MODE=${MODE}."
echo
