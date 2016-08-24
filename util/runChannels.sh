#!/bin/bash
#
set -e -o nounset


# Kick off queries
#
sudo docker exec composer /app/util/scheduled_job_post.py /config/channel_2basic.json
