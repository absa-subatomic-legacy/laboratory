FROM centos:7
# This image provides a .NET Core 2.2 environment you can use to run your .NET
# applications.

EXPOSE 8080

ENV HOME=/opt/app-root \
    PATH=/opt/app-root/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    DOTNET_APP_PATH=/opt/app-root/app \
    DOTNET_DATA_PATH=/opt/app-root/data \
    DOTNET_DEFAULT_CMD=default-cmd.sh \
    DOTNET_CORE_VERSION=2.2 \
    DOTNET_FRAMEWORK=netcoreapp2.2 \
# Microsoft's images set this to enable detecting when an app is running in a container.
    DOTNET_RUNNING_IN_CONTAINER=true \
    DOTNET_SSL_CERT_DIR=/opt/app-root/ssl_dir

LABEL io.k8s.description="Platform for running .NET Core 2.2 applications" \
      io.k8s.display-name=".NET Core 2.2" \
      io.openshift.tags="runtime,.net,dotnet,dotnetcore,rh-dotnet22-runtime" \
      io.openshift.expose-services="8080:http" \
      io.openshift.s2i.scripts-url=image:///usr/libexec/s2i \
      io.s2i.scripts-url=image:///usr/libexec/s2i

# Labels consumed by Red Hat build service
LABEL name="dotnet/dotnet-22-runtime-centos7" \
      com.redhat.component="rh-dotnet22-runtime-container" \
      version="2.2" \
      release="1" \
      architecture="x86_64"

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH.
COPY ./s2i/bin/ /usr/libexec/s2i

# Don't download/extract docs for nuget packages
ENV NUGET_XMLDOC_MODE=skip

# Don't do initially populate of package cache
ENV DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1

## By default, ASP.NET Core runs on port 5000. We configure it to match
## the container port.
ENV ASPNETCORE_URLS=http://*:8080

# Each language image can have 'contrib' a directory with extra files needed to
# run and build the applications.
COPY ./contrib/ /opt/app-root

COPY ./root/usr/bin /usr/bin

RUN yum install -y centos-release-dotnet && \
    INSTALL_PKGS="rh-dotnet22-dotnet-runtime-2.2 nss_wrapper tar unzip" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y && \
# yum cache files may still exist (and quite large in size)
    rm -rf /var/cache/yum/*

# Get prefix path and path to scripts rather than hard-code them in scripts
ENV CONTAINER_SCRIPTS_PATH=/opt/app-root \
    ENABLED_COLLECTIONS="rh-dotnet22"

# When bash is started non-interactively, to run a shell script, for example it
# looks for this variable and source the content of this file. This will enable
# the SCL for all scripts without need to do 'scl enable'.
ENV BASH_ENV=${CONTAINER_SCRIPTS_PATH}/etc/scl_enable \
    ENV=${CONTAINER_SCRIPTS_PATH}/etc/scl_enable \
    PROMPT_COMMAND=". ${CONTAINER_SCRIPTS_PATH}/etc/scl_enable"

# Add default user
RUN mkdir -p ${DOTNET_APP_PATH} ${DOTNET_DATA_PATH} && \
    useradd -u 1001 -r -g 0 -d ${HOME} -s /sbin/nologin \
      -c "Default Application User" default

WORKDIR ${DOTNET_APP_PATH}
COPY default-cmd.sh ${DOTNET_DEFAULT_CMD}

# In order to drop the root user, we have to make some directories world
# writable as OpenShift default security model is to run the container under
# random UID.
RUN chown -R 1001:0 /opt/app-root && fix-permissions /opt/app-root

ENTRYPOINT [ "container-entrypoint" ]


# Runtime above
# Build Below


ENV PATH=/opt/app-root/src/.local/bin:/opt/app-root/src/bin:/opt/app-root/node_modules/.bin:${PATH} \
    STI_SCRIPTS_PATH=/usr/libexec/s2i

LABEL io.k8s.description="Platform for building and running .NET Core 2.2 applications" \
      io.openshift.tags="builder,.net,dotnet,dotnetcore,rh-dotnet22"

# Labels consumed by Red Hat build service
LABEL name="dotnet/dotnet-22-centos7" \
      com.redhat.component="rh-dotnet22-container" \
      version="2.2" \
      release="1" \
      architecture="x86_64"

# Labels consumed by Eclipse JBoss OpenShift plugin
LABEL com.redhat.dev-mode="DEV_MODE:false" \
      com.redhat.deployments-dir="/opt/app-root/src"


# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH.
COPY ./s2i/bin/ /usr/libexec/s2i

RUN yum install -y centos-release-dotnet centos-release-scl-rh && \
    INSTALL_PKGS="rh-nodejs8-npm rh-nodejs8-nodejs-nodemon rh-dotnet22-dotnet-sdk-2.2 rsync" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y && \
# yum cache files may still exist (and quite large in size)
    rm -rf /var/cache/yum/*

# Directory with the sources is set as the working directory.
RUN mkdir /opt/app-root/src
WORKDIR /opt/app-root/src

# Since $HOME is set to /opt/app-root, the yum install may have created config
# directories (such as ~/.pki/nssdb) there. These will be owned by root and can
# cause actions that work on all of /opt/app-root to fail. So we need to fix
# the permissions on those too.
RUN chown -R 1001:0 /opt/app-root && fix-permissions /opt/app-root

ENV ENABLED_COLLECTIONS="$ENABLED_COLLECTIONS rh-nodejs8" \
# Needed for the `dotnet watch` to detect changes in a container.
    DOTNET_USE_POLLING_FILE_WATCHER=true \
# Make all sdks aware of the latest ASP.NET Core version
    LatestPatchVersionForAspNetCoreApp2_2=2.2.2 \
    LatestPatchVersionForAspNetCoreAll2_2=2.2.2

#Add the subatomic cert
ADD https://raw.githubusercontent.com/absa-subatomic/local-hadron-collider/master/minishift-addons/subatomic/certs/subatomic.ca.crt /etc/subatomic.ca.crt

RUN yum install ca-certificates && \
    update-ca-trust force-enable && \
    cp /etc/subatomic.ca.crt /etc/pki/ca-trust/source/anchors/ && \
    update-ca-trust extract

# Run container by default as user with id 1001 (default)
USER 1001

# Set the default CMD to print the usage of the language image.
CMD /usr/libexec/s2i/usage
