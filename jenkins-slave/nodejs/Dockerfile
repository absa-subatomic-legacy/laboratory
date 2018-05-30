# See https://github.com/absa-subatomic/laboratory/issues/19
FROM openshift/jenkins-slave-nodejs-centos7:v3.9

LABEL subatomic-version="2.0" \
        role=jenkins-slave

# Taken as is from https://github.com/openshift/jenkins/blob/openshift-3.9/slave-nodejs/Dockerfile\
# Node version updated
# See: https://github.com/absa-subatomic/laboratory/issues/19
ENV NODEJS_VERSION=8.6.0

USER root
RUN yum remove -y rh-nodejs4 rh-nodejs4-npm rh-nodejs4-nodejs-nodemon && \
    rm -f /usr/bin/nodemon
RUN yum install -y centos-release-scl-rh && \
    INSTALL_PKGS="rh-nodejs8 rh-nodejs8-npm rh-nodejs8-nodejs-nodemon" && \
    ln -s /usr/lib/node_modules/nodemon/bin/nodemon.js /usr/bin/nodemon && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y && rm -rf /var/cache/yum       

RUN scl enable rh-nodejs8 bash

# Add Subatomic trusted Root CA's
USER root
ADD https://raw.githubusercontent.com/absa-subatomic/local-hadron-collider/master/minishift-addons/subatomic/certs/subatomic-ca-chain.pem /etc/pki/ca-trust/source/anchors/subatomic-ca-chain.crt
RUN update-ca-trust

USER 1001

# # Allow adding root CA certificates for custom builds
# ONBUILD USER root
# # Copying the Dockerfile prevents failing on non existent additional certificates (see https://goo.gl/EVBRMg)
# ONBUILD ADD certs/* Dockerfile /etc/pki/ca-trust/source/anchors/
# ONBUILD RUN update-ca-trust
# ONBUILD USER 1001