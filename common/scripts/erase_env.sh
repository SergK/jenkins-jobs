#!/bin/bash

set -ex

ENV_NAME=$ENV_PREFIX.$BUILD_NUMBER.$BUILD_ID
ENV_NAME=${ENV_NAME:0:68}

dos.py erase $ENV_NAME