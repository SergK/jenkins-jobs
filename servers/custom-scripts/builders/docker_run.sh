#!/bin/bash

set -ex

JOB_HOST_PATH="${WORKSPACE}/${JOB_NAME}"
JOB_DOCKER_PATH="/opt/${JOB_NAME}"

COMMAND='true'
if [[ -f "${JOB_HOST_PATH}/requirements-deb.txt" ]] ; then
  COMMAND="${COMMAND} ; apt-get install -y $(xargs < "${JOB_HOST_PATH}/requirements-deb.txt")"
fi

if [[ -f "${JOB_HOST_PATH}/requirements-pip.txt" ]] ; then
  COMMAND="${COMMAND} ; pip install -r ${JOB_DOCKER_PATH}/requirements-pip.txt"
fi

docker run -v "${JOB_HOST_PATH}:${JOB_DOCKER_PATH}" ${VOLUMES} \
           -t "${DOCKER_IMAGE}" /bin/bash -exc "${COMMAND} ; /opt/${SCRIPT_PATH} ${MODE}"
