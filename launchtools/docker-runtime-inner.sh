#!/usr/bin/env bash
# Entrypoint for RuntimeDockerfile.docker. Unlike docker-standard-inner.sh this never builds:
# the image carries no SDK, and the app and extensions were compiled at image build time.
#
# exec makes SwarmUI PID 1, so `docker stop` reaches it as a graceful shutdown rather than
# stopping at a bash parent that ignores SIGTERM until Docker gives up and SIGKILLs.
# A restart requested from the UI exits 42; the compose restart policy brings it back.

cd /SwarmUI

# Docker defaults HOME to '/'. Not dlbackend/linuxhome as docker-standard-inner.sh uses: that
# lives on the dlbackend volume, which only the (disabled) self-start ComfyUI backend needs, and
# nothing in HOME has to outlive the container -- the old caches there were SDK/pip/torch ones.
export HOME=/home/swarmui

exec dotnet src/bin/live_release/SwarmUI.dll "$@" --launch_mode none --host 0.0.0.0
