# See https://github.com/absa-subatomic/laboratory/issues/19
FROM openshift/jenkins-slave-base-centos7:v3.9

LABEL subatomic-version="2.0" \
        role=jenkins-slave

ENV PYTHON_VERSION=3.6 \
    PATH=$HOME/.local/bin/:$PATH \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    PIP_NO_CACHE_DIR=off

RUN INSTALL_PKGS="rh-python36 rh-python36-python-devel rh-python36-python-setuptools rh-python36-python-pip nss_wrapper \
        httpd24 httpd24-httpd-devel httpd24-mod_ssl httpd24-mod_auth_kerb httpd24-mod_ldap \
        httpd24-mod_session atlas-devel gcc-gfortran libffi-devel libtool-ltdl enchant" && \
    yum install -y centos-release-scl && \
    yum -y --setopt=tsflags=nodocs install --enablerepo=centosplus $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    # Remove centos-logos (httpd dependency) to keep image size smaller.
    rpm -e --nodeps centos-logos && \
    yum -y clean all --enablerepo='*'

# Copy extra files to the image.
COPY contrib/bin/scl_enable /usr/local/bin/scl_enable

# - Create a Python virtual environment for use by any application to avoid
#   potential conflicts with Python packages preinstalled in the main Python
#   installation.
# - In order to drop the root user, we have to make some directories world
#   writable as OpenShift default security model is to run the container
#   under random UID.
RUN source scl_source enable rh-python36 && \
    virtualenv ${HOME}/venv && \
    chown -R 1001:0 $HOME && \
    chmod -R g+rw $HOME

# Add Subatomic trusted Root CA's
ADD https://raw.githubusercontent.com/absa-subatomic/local-hadron-collider/master/minishift-addons/subatomic/certs/subatomic.ca.crt /etc/pki/ca-trust/source/anchors/subatomic-ca-chain.crt
RUN chown 1001:0 /etc/pki/ca-trust/source/anchors/subatomic-ca-chain.crt && \
    update-ca-trust

USER 1001

RUN source ${HOME}/venv/bin/activate

# # Allow adding root CA certificates for custom builds
# ONBUILD USER root
# # Copying the Dockerfile prevents failing on non existent additional certificates (see https://goo.gl/EVBRMg)
# ONBUILD ADD certs/* Dockerfile /etc/pki/ca-trust/source/anchors/
# ONBUILD RUN update-ca-trust
# ONBUILD USER 1001