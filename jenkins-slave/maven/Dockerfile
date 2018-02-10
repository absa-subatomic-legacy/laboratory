FROM openshift/jenkins-slave-maven-centos7:v3.9

LABEL subatomic-version="2.0" \
        role=jenkins-slave

# Add Subatomic trusted Root CA's
USER root
ADD https://raw.githubusercontent.com/absa-subatomic/local-hadron-collider/master/minishift-addons/subatomic/certs/subatomic-ca-chain.pem /etc/pki/ca-trust/source/anchors/subatomic-ca-chain.crt
RUN update-ca-trust

USER 1001