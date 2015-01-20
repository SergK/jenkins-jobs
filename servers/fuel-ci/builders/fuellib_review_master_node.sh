#!/bin/bash

set -ex

echo "${GERRIT_CHANGE_COMMIT_MESSAGE}" | base64 -d > gerrit_commit_message.txt 2>/dev/null || true

if grep -q -iE "Fuel-CI:\s+disable" gerrit_commit_message.txt; then
  echo "Fuel CI check disabled"
  exit -1
fi

export FUEL_MAIN_PATH="/home/jenkins/workspace/fuel-main/master_node_test/master"
export SYSTEM_TESTS="${FUEL_MAIN_PATH}/utils/jenkins/system_tests.sh"
export ENV_NAME="fuellib_review_master_node"
export ISO_PATH="/home/jenkins/workspace/iso/fuel_master.iso"
export LOGS_DIR=/home/jenkins/workspace/${JOB_NAME}/logs/${BUILD_NUMBER}
export VENV_PATH=/home/jenkins/venv-nailgun-tests

#test params
export UPLOAD_MANIFESTS=true
export UPLOAD_MANIFESTS_PATH=/home/jenkins/workspace/${JOB_NAME}/deployment/puppet/
export CUSTOM_ENV=true
export BUILD_IMAGES=true
export TEST_GROUP="deploy_simple_flat"

VERSION_STRING=`readlink ${ISO_PATH} | cut -d '-' -f 2-3`
echo "Description string: ${VERSION_STRING}"

sh -x "${SYSTEM_TESTS}" -w "${FUEL_MAIN_PATH}" -V "${VENV_PATH}" -i "${ISO_PATH}" -t test -e "${ENV_NAME}" -o --group=${TEST_GROUP}