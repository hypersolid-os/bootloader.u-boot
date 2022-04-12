#!/usr/bin/env bash

set -e

# basedir
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WORKINGDIR="$(pwd)"
CONTAINER_NAME="bootloader-uboot"

# create environment
podman build \
    -t ${CONTAINER_NAME} \
    . \
&& {
    echo "build environment ready"
} || {
    echo "cannot create build environment"
    exit 1
}

# container already exists ?
podman container rm ${CONTAINER_NAME}-env && {
    echo "existing build environment removed"
} || {
    echo "cannot remove build environment"
}

# create image
podman run \
    -it \
    --name ${CONTAINER_NAME}-env \
    --mount type=bind,source=${WORKINGDIR}/target,target=/mnt/target \
    --mount type=bind,source=${WORKINGDIR}/conf,target=/mnt/conf \
    ${CONTAINER_NAME} \
&& {
    echo "image created"
} || {
    echo "ERROR: image creation failed"
    exit 3
}
