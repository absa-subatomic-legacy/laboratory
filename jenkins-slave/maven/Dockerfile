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
RUN chmod a+r ${GLOBAL_MAVEN_SETTINGS}/settings.xml

# Upgrade Git and Maven
RUN rpm -Uvh http://repo.iotti.biz/CentOS/5/noarch/lux-release-0-1.noarch.rpm && \
  rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-LUX && \
  yum -y install git rh-maven35 && \
  yum clean all && \
  rm -rf /var/cache/yum

USER 1001