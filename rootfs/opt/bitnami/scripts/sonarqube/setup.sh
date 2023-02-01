

#!/bin/bash

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

export SONARQUBE_CE_JAVA_ADD_OPTS="-javaagent:./extensions/plugins/sonarqube-community-branch-plugin-1.14.0.jar=ce"

export SONARQUBE_WEB_JAVA_ADD_OPTS="-javaagent:./extensions/plugins/sonarqube-community-branch-plugin-1.14.0.jar=web"

# Ensure SonarQube environment variables are valid
sonarqube_validate

# Ensure SonarQube is initialized
sonarqube_initialize

# load plugins
if [ ! -f "/opt/bitnami/sonarqube/extensions/plugins/init.txt" ]; then
  cp -ar /plugins/* /opt/bitnami/sonarqube/extensions/plugins/
fi
