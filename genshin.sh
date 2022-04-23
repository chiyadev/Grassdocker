#!/bin/sh
docker run --rm -it --network host -v /mnt/Projects/docker-grasscutter/config.json:/grasscutter/config.json registry.chiya.dev/grasscutter:latest
