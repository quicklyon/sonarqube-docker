FROM bitnami/sonarqube:9.8.0

COPY plugins /plugins

COPY rootfs /

ENV SONARQUBE_CE_JAVA_ADD_OPTS="-javaagent:/opt/bitnami/sonarqube/extensions/plugins/sonarqube-community-branch-plugin-1.14.0.jar=ce"

ENV SONARQUBE_WEB_JAVA_ADD_OPTS="-javaagent:/opt/bitnami/sonarqube/extensions/plugins/sonarqube-community-branch-plugin-1.14.0.jar=web"
