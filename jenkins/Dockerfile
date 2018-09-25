FROM openshift/jenkins-2-centos7:v3.9

LABEL subatomic-version="2.1"

# Add Subatomic trusted Root CA's
USER root
ADD https://raw.githubusercontent.com/absa-subatomic/local-hadron-collider/master/minishift-addons/subatomic/certs/subatomic.ca.crt /etc/pki/ca-trust/source/anchors/subatomic-ca-chain.crt
RUN update-ca-trust

# Remove Kube limits for slaves
RUN sed -i -e 's/resourceLimitCpu></resourceLimitCpu>0</g' /usr/local/bin/kube-slave-common.sh && \
    sed -i -e 's/resourceLimitMemory></resourceLimitMemory>0</g' /usr/local/bin/kube-slave-common.sh

# Add base and addtional plugins 
COPY base-plugins.txt /opt/openshift/base-plugins.txt
RUN /usr/local/bin/install-plugins.sh /opt/openshift/base-plugins.txt
COPY plugins.txt /opt/openshift/configuration/plugins.txt
RUN /usr/local/bin/install-plugins.sh /opt/openshift/configuration/plugins.txt

# Remove the OpenShift sample Job
RUN rm -rf /opt/openshift/configuration/jobs

# Add custom Jenkins configuration files
COPY configuration/*.tpl /opt/openshift/configuration/
COPY configuration/users/admin/admin-config.xml.tpl /opt/openshift/configuration/users/admin/

USER 1001

# # Allow adding root CA certificates for custom builds
# ONBUILD USER root
# # Copying the Dockerfile prevents failing on non existent additional certificates (see https://goo.gl/EVBRMg)
# ONBUILD ADD certs/* Dockerfile /etc/pki/ca-trust/source/anchors/
# ONBUILD RUN update-ca-trust
# ONBUILD USER 1001
