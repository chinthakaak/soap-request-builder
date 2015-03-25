#!/bin/bash
./bin/configure-proxy.sh
./bin/generate-requests.sh
./bin/generate-scripts.sh
./bin/copy-requests.sh
./bin/generate-xpaths.sh
./bin/copy-script-templates.sh
