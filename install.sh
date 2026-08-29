#!/bin/bash
set -e

sudo systemctl stop checker
MIX_ENV=prod mix release
sudo cp -a ./_build/prod/rel/checker/. /opt/checker/
sudo systemctl start checker