FROM bitnami/sonarqube:9.8.0

COPY plugins /plugins

COPY rootfs /
