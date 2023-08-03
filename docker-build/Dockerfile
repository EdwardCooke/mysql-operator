# Copyright (c) 2021, 2022, Oracle and/or its affiliates.
#
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/
#

FROM container-registry.oracle.com/os/oraclelinux:9 AS init

RUN curl -L -o /opt/mysql-shell.rpm "https://dev.mysql.com/get/Downloads/MySQL-Shell/mysql-shell-%%MYSQL_SHELL_VERSION%%-1.el9.$(uname -m).rpm" \
  && dnf install -y /opt/mysql-shell.rpm

#########################

FROM init AS pipinstaller
COPY ./docker-deps/requirements.txt .
RUN dnf install -y python3-pip
RUN pip3 install --target=/tmp/site-packages -r requirements.txt

#########################

FROM init
COPY --from=pipinstaller /tmp/site-packages /usr/lib/mysqlsh/python-packages

RUN groupadd -g27 mysql \
  && useradd -u27 -g27 mysql \
  && mkdir /mysqlsh \
  && chown 2 /mysqlsh

COPY mysqloperator/ /usr/lib/mysqlsh/python-packages/mysqloperator

# Workaround for BC issue with newest Python library for Kubernetes
# See move here: https://github.com/kubernetes-client/python/issues/1718
RUN sed -i "s/available_replicas=None,/available_replicas=0,/" /usr/lib/mysqlsh/python-packages/kubernetes/client/models/v1_stateful_set_status.py


USER 2

ENV HOME=/mysqlsh
