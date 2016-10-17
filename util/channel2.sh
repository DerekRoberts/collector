#!/bin/bash
#
set -e -o nounset


# Kick off queries
#
sudo docker exec composer /app/util/scheduled_jobs.py /config/channel_2basic.json
