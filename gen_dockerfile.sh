#!/bin/bash
# Copyright (c) 2021, 2023, Oracle and/or its affiliates.
#
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/
#


MYSQL_REPO_URL="http://repo.mysql.com"; [ -n "${1}" ] && MYSQL_REPO_URL="${1}"
MYSQL_SHELL_VERSION=""; [ -n "${2}" ] && MYSQL_SHELL_VERSION="${2}"
MYSQL_CONFIG_PKG="mysql80-community-release"; [ -n "${3}" ] && MYSQL_CONFIG_PKG="${3}"
MYSQL_SHELL_REPO="mysql-tools-community"; [ -n "${4}" ] && MYSQL_SHELL_REPO="${4}"

cp docker-build/Dockerfile tmpfile

sed -i 's#%%MYSQL_SHELL_VERSION%%#'"${MYSQL_SHELL_VERSION}"'#g' tmpfile
sed -i 's#%%MYSQL_REPO_URL%%#'"${MYSQL_REPO_URL}"'#g' tmpfile
sed -i 's#%%MYSQL_CONFIG_PKG%%#'"${MYSQL_CONFIG_PKG}"'#g' tmpfile
sed -i 's#%%MYSQL_SHELL_REPO%%#'"${MYSQL_SHELL_REPO}"'#g' tmpfile

mv tmpfile Dockerfile
