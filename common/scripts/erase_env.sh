#!/bin/bash

set -ex

ENV_NAME=$ENV_PREFIX.$BUILD_NUMBER.$BUILD_ID

dos.py erase $ENV_NAME
