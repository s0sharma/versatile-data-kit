#!/bin/bash -e

# Copyright 2021-2024 VMware, Inc.
# SPDX-License-Identifier: Apache-2.0

PLUGIN_NAME=$(basename "$(pwd)")
echo "Building plugin $PLUGIN_NAME"

PIP_EXTRA_INDEX_URL=${PIP_EXTRA_INDEX_URL:-'https://pypi.org/simple'}

pip install -U pip setuptools

pip install --upgrade --extra-index-url $PIP_EXTRA_INDEX_URL -r requirements.txt
pip install --upgrade -e . --extra-index-url $PIP_EXTRA_INDEX_URL

if [ -n "${USE_VDKCORE_DEV_VERSION}" ] ; then pip install -e ../../vdk-core; fi

# List exceptions to below check here.
# Those are not technically plugins so they would not have entry point defined.
if [ "$PLUGIN_NAME" != 'quickstart-vdk' ] && \
   [ "$PLUGIN_NAME" != 'vdk-test-utils' ] && \
   [ "$PLUGIN_NAME" != 'vdk-control-api-auth' ] && \
   [ "$PLUGIN_NAME" != 'vdk-lineage-model' ]
then

  echo "Check plugin entry point is configured correctly ..."
  if ! vdk version 2>&1 | grep -q "$PLUGIN_NAME"; then
    echo "Plugin entry point seems to be mis-configured."
    echo "Make sure to set setup.py entry_points for the plugin or update an exception case in above if statement."
    echo "Running vdk version:"
    vdk version
    exit 1
  else
    echo "Check passed."
  fi
fi

pip install pytest-cov


pytest --junitxml=tests.xml --cov vdk --cov-report term-missing --cov-report xml:coverage.xml
