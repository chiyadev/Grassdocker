#!/bin/sh
# This script is provided as an example to quickly start MongoDB on localhost.
mkdir -p 'local/db'

docker run --rm -it --network host -v "$(pwd)/local/db:/data/db" 'mongo:focal' "$@"
