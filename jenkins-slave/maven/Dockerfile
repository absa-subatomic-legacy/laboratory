FROM openshift/jenkins-slave-maven-centos7:v3.9

LABEL subatomic-version="2.0" \
        role=jenkins-slave

# Add Subatomic trusted Root CA's
USER root
ADD https://raw.githubusercontent.com/absa-subatomic/local-hadron-collider/master/minishift-addons/subatomic/certs/subatomic.ca.crt /etc/pki/ca-trust/source/anchors/subatomic-ca-chain.crt
RUN update-ca-trust

ENV GLOBAL_MAVEN_SETTINGS /opt/rh/rh-maven33/root/usr/share/maven/conf
COPY settings.xml ${GLOBAL_MAVEN_SETTINGS}/settings.xml
# Thanks to https://www.lewuathe.com/maven-wrapper-home.html
ENV MAVEN_USER_HOME /tmp

USER 1001

# # Allow adding root CA certificates for custom builds
# ONBUILD USER root
# # Copying the Dockerfile prevents failing on non existent additional certificates (see https://goo.gl/EVBRMg)
# ONBUILD ADD certs/* Dockerfile /etc/pki/ca-trust/source/anchors/
# ONBUILD RUN update-ca-trust
# ONBUILD USER 1001