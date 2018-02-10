FROM openshift/jenkins-2-centos7:v3.9

LABEL subatomic-version="2.0"

# Add Subatomic trusted Root CA's
USER root
ADD https://raw.githubusercontent.com/absa-subatomic/local-hadron-collider/master/minishift-addons/subatomic/certs/subatomic-ca-chain.pem /etc/pki/ca-trust/source/anchors/subatomic-ca-chain.crt
RUN update-ca-trust

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