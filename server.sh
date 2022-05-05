#!/bin/sh
# This script is provided as an example to quickly start Grasscutter on localhost.
mkdir -p 'local'
[ ! -f 'local/config.json' ] && echo '{}' > 'local/config.json'

docker run --rm -it --network host -v "$(pwd)/local/config.json:/grasscutter/config.json" "$@"
