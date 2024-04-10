FROM bitnami/sonarqube:10.4.1

COPY rootfs /

ENV SONARQUBE_CE_JAVA_ADD_OPTS="-javaagent:/opt/bitnami/sonarqube/extensions/plugins/sonarqube-community-branch-plugin-1.19.0.jar=ce"

ENV SONARQUBE_WEB_JAVA_ADD_OPTS="-javaagent:/opt/bitnami/sonarqube/extensions/plugins/sonarqube-community-branch-plugin-1.19.0.jar=web"

USER root

COPY plugins /plugins

RUN chown 1001:1001 /plugins -R

USER 1001
