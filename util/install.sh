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
  echo "This will stop and rebuild the Collector Stack."
  echo
  echo "prod       = production deployment."
  echo "dev        = development deployment."
  echo "prodHybrid = +local builds and containers from dev/dev.yml."
  echo "devHybrid  = +local builds and containers from dev/dev.yml."
  echo
  echo "Please enter a build type, as above, or anything else to cancel."
  read TYPE
  echo
fi


# Set build details
#
if [ "${TYPE}" = "prod" ]
then
  TAG=latest
  MODE=prod
elif [ "${TYPE}" = "dev" ]
then
  TAG=dev
  MODE=prod
elif [ "${TYPE}" = "prodHybrid" ]
then
  TAG=latest
  MODE=dev
elif [ "${TYPE}" = "devHybrid" ]
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
