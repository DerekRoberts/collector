#!/bin/bash
#
set -e


# Set build type or flag for prompt
#
TARGET=${1}
ACCESS=${2}


# Prompt for build type, unless specified
#
if [ -z "${1}" ]
then
  echo
  echo
  echo "Manage hQuery users and rights.  Register from webapp."
  echo
  echo "Usage: ./accounts.sh USERNAME [user|admin]"
  echo
  echo "Script run without parameters defaults to interactive mode."
  echo
  echo "Please enter a user name."
  read TARGET
  echo
  echo "Please enter rights to grant.  Default=user."
  read ACCESS
  echo
fi


# Set build command
#
if [ "${ACCESS}" = "admin" ]
then
  TOEXEC="bundle exec rake hquery:users:grant_admin USER_ID=${TARGET}"
else
  TOEXEC="bundle exec rake hquery:users:approve USER_ID=${TARGET}"
fi


# Verify TARGET and run docker exec
#
if [ -z "${TARGET}" ]
then
  echo "Input error.  TARGET=${TARGET}, ACCESS=${ACCESS}"
else
  sudo docker exec -ti composer /bin/bash -c "cd /app/; ${TOEXEC}" || true
fi


# Deploy and inform
#
echo
echo "Complete.  TARGET=${TARGET}, ACCESS=${ACCESS}."
echo
