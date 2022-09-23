#!/usr/bin/env bash
set -e

use_tag="ghcr.io/librenz/uvicorn-gunicorn-fastapi-container/uvicorn-gunicorn-fastapi:$NAME"

DOCKERFILE="$NAME"

if [ "$NAME" == "latest" ] ; then
    DOCKERFILE="python3.10"
fi

docker build -t "$use_tag" --file "./docker-images/${DOCKERFILE}.dockerfile" "./docker-images/"
