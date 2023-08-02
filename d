# Copyright (c) 2021, 2022, Oracle and/or its affiliates.
#
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/
#

FROM container-registry.oracle.com/os/oraclelinux:8-slim AS init

RUN rpm -U http://repo.mysql.com/mysql80-community-release-el8.rpm \
  && microdnf update && echo "[main]" > /etc/dnf/dnf.conf \
  && microdnf install --enablerepo=mysql-tools-community -y glibc-langpack-en python39-pip mysql-shell \
  && microdnf remove mysql80-community-release \
  && microdnf clean all

#########################

FROM init AS pipinstaller
COPY ./docker-deps/requirements.txt .
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

