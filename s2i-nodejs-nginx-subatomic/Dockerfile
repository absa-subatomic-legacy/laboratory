FROM centos/nginx-112-centos7

EXPOSE 8080

USER root

ENV NPM_BUILD_COMMAND=build \
    NODEJS_VERSION=8.9.4 \
    NPM_CONFIG_LOGLEVEL=info \
    NPM_CONFIG_PREFIX=$HOME/.npm-global \
    PATH=$HOME/node_modules/.bin/:$HOME/.npm-global/bin/:$PATH \
    BASH_ENV=/usr/local/bin/scl_enable \
    ENV=/usr/local/bin/scl_enable \
    PROMPT_COMMAND=". /usr/local/bin/scl_enable" \
    NPM_VERSION=5.6.0 \
    DEBUG_PORT=5858 \
    NODE_ENV=production \
    DEV_MODE=false \
    NPM_REGISTRY_URL=https://registry.npmjs.org

LABEL io.k8s.description="Platform for building and running static sites with NodeJS and NGINX." \
      io.k8s.display-name="build-nodejs-nginx" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,nodejs,nodejs$NODE_VERSION,nginx" \
      com.redhat.deployments-dir="/opt/app-r  oot/src" \
      io.openshift.s2i.scripts-url="image:///opt/app-root/s2i/bin"

COPY contrib/bin/scl_enable /usr/local/bin/scl_enable      

RUN yum install -y centos-release-scl-rh && \
    INSTALL_PKGS="rh-nodejs8 rh-nodejs8-npm rh-nodejs8-nodejs-nodemon" && \
    ln -s /usr/lib/node_modules/nodemon/bin/nodemon.js /usr/bin/nodemon && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y

# Don't install Cypress - we won't run tests for S2I
ENV CYPRESS_SKIP_BINARY_INSTALL=1

RUN curl -s -L -O https://github.com/sass/node-sass/releases/download/v4.9.0/linux-x64-57_binding.node
ENV SASS_BINARY_PATH=/opt/app-root/src/linux-x64-57_binding.node    

# Add S2I nginx custom files
ADD contrib/nginx.default.conf /etc/opt/rh/rh-nginx112/nginx/nginx.conf

# Copy the S2I scripts from the specific language image to the location pointed to by the io.openshift.s2i.scripts-url label
ADD s2i/bin/assemble /opt/app-root/s2i/bin/
ADD s2i/bin/run /opt/app-root/s2i/bin/
RUN chown -R 1001:0 /opt/app-root && \
  chmod -R ug+rwx /opt/app-root/s2i/bin

# Subatomic
# ===
ADD https://raw.githubusercontent.com/absa-subatomic/local-hadron-collider/master/minishift-addons/subatomic/certs/subatomic-ca-chain.pem /etc/pki/ca-trust/source/anchors/etc/ca.cert.pem
ADD https://raw.githubusercontent.com/absa-subatomic/local-hadron-collider/master/minishift-addons/subatomic/certs/subatomic-ca-chain.pem /subatomic/certs/ca.cert.pem
RUN update-ca-trust
RUN scl enable rh-nodejs8 'npm config set -g cafile /subatomic/certs/ca.cert.pem' && \
  chown -R 1001:0 /subatomic/certs/ca.cert.pem

USER 1001

# Set the default CMD to print the usage of the language image
CMD $STI_SCRIPTS_PATH/usage
