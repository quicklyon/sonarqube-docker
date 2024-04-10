#!/bin/bash
# Copyright VMware, Inc.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load SonarQube environment
. /opt/bitnami/scripts/sonarqube-env.sh

# Load PostgreSQL Client environment for 'postgresql_remote_execute' (after 'sonarqube-env.sh' so that MODULE is not set to a wrong value)
if [[ -f /opt/bitnami/scripts/postgresql-client-env.sh ]]; then
    . /opt/bitnami/scripts/postgresql-client-env.sh
elif [[ -f /opt/bitnami/scripts/postgresql-env.sh ]]; then
    . /opt/bitnami/scripts/postgresql-env.sh
fi

# Load libraries
. /opt/bitnami/scripts/libsonarqube.sh

# Ensure SonarQube environment variables are valid
sonarqube_validate

# load plugins
if [ ! -f "/bitnami/sonarqube/extensions/plugins/init.txt" ]; then
  info "load plugins"
  cp -ar /plugins/*.jar /opt/bitnami/sonarqube/extensions/plugins/ && (
    echo "ok" > /opt/bitnami/sonarqube/extensions/plugins/init.txt
  )
else
  info "upgrade plugins"
  for pn in /plugins/*.jar
  do
    fullname=$(echo "$pn" | awk -F'plugins/' '{print $2}')
    version=$(echo "$pn" | awk -F'plugins/' '{print $2}' | awk -F- '{print $NF}')
    name=$(echo "$fullname" | awk -F"-$version" '{print $1}')
    rm -rf "/bitnami/sonarqube/extensions/plugins/$name*"
  done
  cp -ar /plugins/* /bitnami/sonarqube/extensions/plugins/
fi

# Ensure SonarQube is initialized
sonarqube_initialize
