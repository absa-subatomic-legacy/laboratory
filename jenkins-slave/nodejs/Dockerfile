# See https://github.com/absa-subatomic/laboratory/issues/19
FROM openshift/jenkins-slave-nodejs-centos7:v3.9

LABEL subatomic-version="2.0" \
        role=jenkins-slave

# Taken as is from https://github.com/openshift/jenkins/blob/openshift-3.9/slave-nodejs/Dockerfile\
# Node version updated
# See: https://github.com/absa-subatomic/laboratory/issues/19
ENV NODEJS_VERSION=8.6.0 \
    BASH_ENV=/usr/local/bin/scl_enable \
    ENV=/usr/local/bin/scl_enable \
    PROMPT_COMMAND=". /usr/local/bin/scl_enable"

COPY contrib/bin/scl_enable /usr/local/bin/scl_enable

USER root

COPY contrib/bin/scl_enable /usr/local/bin/scl_enable

RUN yum remove -y rh-nodejs4 rh-nodejs4-npm rh-nodejs4-nodejs-nodemon && \
    rm -f /usr/bin/nodemon
RUN yum install -y centos-release-scl-rh && \
    INSTALL_PKGS="rh-nodejs8 rh-nodejs8-npm rh-nodejs8-nodejs-nodemon make gcc-c++" && \
    ln -s /usr/lib/node_modules/nodemon/bin/nodemon.js /usr/bin/nodemon && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y && rm -rf /var/cache/yum

# From https://www.itzgeek.com/how-tos/linux/centos-how-tos/install-google-chrome-37-on-centos-7-rhel-7.html
RUN echo -e "[google-chrome]\n\
name=google-chrome\n\
baseurl=http://dl.google.com/linux/chrome/rpm/stable/\$basearch\n\
enabled=1\n\
gpgcheck=1\n\
gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub" > /etc/yum.repos.d/google-chrome.repo && \ 
  yum install -y xorg-x11-server-Xvfb gtk2 GConf2 google-chrome-stable && \
  echo export PATH='$PATH:/opt/google/chrome' >> /etc/bashrc
  
RUN CYPRESS_BINARY_VERSION=https://cdn.cypress.io/desktop/2.1.0/linux64/cypress.zip && \
    wget --quiet https://cdn.cypress.io/desktop/2.1.0/linux64/cypress.zip --directory-prefix=/home/jenkins
ENV CYPRESS_BINARY_VERSION=/home/jenkins/cypress.zip

RUN wget --quiet https://github.com/sass/node-sass/releases/download/v4.9.0/linux-x64-57_binding.node --directory-prefix=/home/jenkins
ENV SASS_BINARY_PATH=/home/jenkins/linux-x64-57_binding.node

RUN chown -R 1001:0 $HOME && \
    chmod -R g+rw $HOME

# Add Subatomic trusted Root CA's
ADD https://raw.githubusercontent.com/absa-subatomic/local-hadron-collider/master/minishift-addons/subatomic/certs/subatomic-ca-chain.pem /etc/pki/ca-trust/source/anchors/subatomic-ca-chain.crt
RUN chown 1001:0 /etc/pki/ca-trust/source/anchors/subatomic-ca-chain.crt && \
    update-ca-trust

USER 1001

# # Allow adding root CA certificates for custom builds
# ONBUILD USER root
# # Copying the Dockerfile prevents failing on non existent additional certificates (see https://goo.gl/EVBRMg)
# ONBUILD ADD certs/* Dockerfile /etc/pki/ca-trust/source/anchors/
# ONBUILD RUN update-ca-trust
# ONBUILD USER 1001