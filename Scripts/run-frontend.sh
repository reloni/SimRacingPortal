#!/bin/bash
set -e

lsof -i :9000 -sTCP:LISTEN | awk 'NR > 1 {print $2}'| xargs kill -15 && swift run Frontend serve --port 9000 --env development