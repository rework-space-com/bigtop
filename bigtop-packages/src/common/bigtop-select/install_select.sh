#!/bin/bash

# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -ex

usage() {
  echo "
usage: $0 <options>
  Required not-so-options:
     --prefix=PREFIX                              path to install into
     --distro-dir=DIR                             path to distro specific files (debian/RPM)
     --build-dir=DIR                              path to build directory
     --parent-dir=DIR                             path to install stack-root/stack-version
     --bin-dir=DIR                                path to bin directory
     --lib-dir=DIR                                path to lib directory
     --bigtop-base-version=BIGTOP_BASE_VERSION    Bigtop Base Version
  "
  exit 1
}
OPTS=$(getopt \
  -n "$0" \
  -o '' \
  -l 'prefix:' \
  -l 'distro-dir:' \
  -l 'build-dir:' \
  -l 'parent-dir:' \
  -l 'bin-dir:' \
  -l 'lib-dir:' \
  -l 'conf-dir:' \
  -l 'bigtop-base-version:' \
  -- "$@")
if [ $? != 0 ] ; then
    usage
fi
eval set -- "$OPTS"
while true ; do
    case "$1" in
        --prefix)
        PREFIX=$2 ; shift 2
        ;;
        --distro-dir)
        DISTRO_DIR=$2 ; shift 2
        ;;
        --build-dir)
        BUILD_DIR=$2 ; shift 2
        ;;
        --parent-dir)
        PARENT_DIR=$2 ; shift 2
        ;;
        --bin-dir)
        BIN_DIR=$2 ; shift 2
        ;;
        --lib-dir)
        LIB_DIR=$2 ; shift 2
        ;;
        --bigtop-base-version)
        BIGTOP_BASE_VERSION=$2 ; shift 2
        ;;
        --)
        shift ; break
        ;;
        *)
        echo "Unknown option: $1"
        usage
        exit 1
        ;;
    esac
done

BIGTOP_BASE_VERSION=${BIGTOP_BASE_VERSION:-"1.0"}
LIB_DIR=${LIB_DIR:-/usr/lib/bigtop-select}
BIN_DIR=${BIN_DIR:-${LIB_DIR}/${BIGTOP_BASE_VERSION}/bin}
DISTRO_DIR=${DISTRO_DIR:-${BUILD_DIR}/debian}

STACK_SELECTOR=distro-select
CONF_SELECTOR=conf-select

# Install packages
install -d -p -m 755 "${PREFIX}""${PARENT_DIR}"/
install -d -p -m 755 "${PREFIX}"/"${BIN_DIR}"/
install -d -p -m 755 "${PREFIX}""${LIB_DIR}"/current/

install -p -m 755 "${DISTRO_DIR}"/${STACK_SELECTOR} "${PREFIX}"/"${BIN_DIR}"/
install -p -m 755 "${DISTRO_DIR}"/${CONF_SELECTOR} "${PREFIX}"/"${BIN_DIR}"/
