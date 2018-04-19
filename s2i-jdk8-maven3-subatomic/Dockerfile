# Heavily based off https://github.com/codecentric/springboot-maven3-centos
FROM openshift/base-centos7

# Spring Boot Maven 3
# ===
EXPOSE 8080

LABEL io.k8s.description="Subatomic S2I for building and running Java applications" \
      io.k8s.display-name="Subatomic Oracle JDK with Maven 3" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,java,java8,maven,maven3" \
      io.fabric8.s2i.version.jolokia="1.3.6.redhat-1" \
      io.fabric8.s2i.version.prometheus.jmx_exporter="0.10" \      
      io.openshift.s2i.scripts-url="image:///usr/local/s2i" \
      io.openshift.s2i.destination="/tmp" \      
      subatomic-version="2.0" \
      author="Subatomic <https://github.com/absa-subatomic>"

# See http://download.oracle.com/otn-pub/java/jdk/8u162-b12/0da788060d494f5095bf8624735fa2f1/jdk-8u162-linux-x64.tar.gz
# JCE. See https://golb.hplar.ch/p/JCE-policy-changes-in-Java-SE-8u151-and-8u152
ENV UPDATE_VERSION=8u171
ENV JAVA_VERSION=1.8.0_171
ENV BUILD=b11
ENV HASH 512cd62ec5174c3487ac17c61aaa89e8
RUN yum -y update && \
  yum -y install wget && \
  wget -c --no-cookies --no-check-certificate \
  --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" \
    "http://download.oracle.com/otn-pub/java/jdk/${UPDATE_VERSION}-${BUILD}/${HASH}/jdk-${UPDATE_VERSION}-linux-x64.rpm" \
  --output-document="jdk-${UPDATE_VERSION}-linux-x64.rpm" && \
  rpm -i jdk-${UPDATE_VERSION}-linux-x64.rpm && \
  alternatives --install /usr/bin/java java /usr/java/jdk${JAVA_VERSION}/bin/java 1 && \
  alternatives --set java /usr/java/jdk${JAVA_VERSION}/bin/java && \
  export JAVA_HOME=/usr/java/jdk${JAVA_VERSION}/ && \
  echo "export JAVA_HOME=/usr/java/jdk${JAVA_VERSION}/" | tee /etc/environment && \
  source /etc/environment && \
  rm jdk-${UPDATE_VERSION}-linux-x64.rpm && \
  yum clean all && \
  rm -rf /var/cache/yum
ENV JAVA_HOME=/usr/java/jdk${JAVA_VERSION}
RUN echo $JAVA_HOME
ENV PATH=$JAVA_HOME/bin:$PATH

ENV MAVEN_VERSION 3.5.2
RUN curl -fsSL https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
  && mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn
ENV MAVEN_HOME /usr/share/maven
COPY settings.xml /usr/share/maven/conf/settings.xml
# ===

# Java S2I. See https://github.com/fabric8io-images/s2i/tree/master/java/images/rhel
# === 
# Prometheus JMX exporter agent
 RUN mkdir -p /opt/prometheus/etc \
  && curl http://central.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.10/jmx_prometheus_javaagent-0.10.jar \
          -o /opt/prometheus/jmx_prometheus_javaagent.jar
 ADD prometheus-opts /opt/prometheus/prometheus-opts
 ADD prometheus-config.yml /opt/prometheus/prometheus-config.yml
 RUN chmod 444 /opt/prometheus/jmx_prometheus_javaagent.jar \
  && chmod 444 /opt/prometheus/prometheus-config.yml \
  && chmod 755 /opt/prometheus/prometheus-opts \
  && chmod 775 /opt/prometheus/etc \
  && chgrp root /opt/prometheus/etc

EXPOSE 9779

# Jolokia agent
RUN mkdir -p /opt/jolokia/etc \
 && curl https://maven.repository.redhat.com/ga/org/jolokia/jolokia-jvm/1.3.6.redhat-1/jolokia-jvm-1.3.6.redhat-1-agent.jar \
         -o /opt/jolokia/jolokia.jar
ADD jolokia-opts /opt/jolokia/jolokia-opts
RUN chmod 444 /opt/jolokia/jolokia.jar \
 && chmod 755 /opt/jolokia/jolokia-opts \
 && chmod 775 /opt/jolokia/etc \
 && chgrp root /opt/jolokia/etc

 # S2I scripts + README
COPY s2i /usr/local/s2i
RUN chmod 755 /usr/local/s2i/*
ADD README.md /usr/local/s2i/usage.txt

# Add run script as /opt/run-java/run-java.sh and make it executable
COPY run-java.sh /deployments/
RUN chmod 755 /deployments/run-java.sh

# Necessary to permit running with a randomised UID
RUN mkdir -p /deployments \
 && chmod -R "g+rwX" /deployments

# Use the run script as default since we are working as an hybrid image which can be
# used directly to. (If we were a plain s2i image we would print the usage info here)
CMD [ "/usr/local/s2i/run" ]
# ===

# Subatomic
# ===
ADD https://raw.githubusercontent.com/absa-subatomic/local-hadron-collider/master/minishift-addons/subatomic/certs/subatomic-ca-chain.pem /etc/ca.cert.pem
RUN keytool -importcert \
  -file /etc/ca.cert.pem \
  -alias subatomic.local \
  -keystore $JAVA_HOME/jre/lib/security/cacerts \
  -storepass changeit \
  -noprompt

ADD logback.xml /maven/config/logback.xml

VOLUME /tmp

RUN wget https://download.newrelic.com/newrelic/java-agent/newrelic-agent/current/newrelic-java.zip
RUN unzip newrelic-java.zip -d /
# Add a newrelic.yml template that allows envrionment variables to set values
# seee https://docs.newrelic.com/docs/agents/java-agent/configuration/java-agent-configuration-config-file
RUN mv /newrelic/newrelic.yml /newrelic/newrelic.yml.original
ADD newrelic.yml /newrelic/newrelic.yml
RUN mkdir -p /newrelic/logs/
RUN chmod -R a+rwx /newrelic
VOLUME /newrelic/logs/

USER 1001

# # Allow adding root CA certificates for custom builds
# ONBUILD USER root
# # Copying the Dockerfile prevents failing on non existent additional certificates (see https://goo.gl/EVBRMg)
# ONBUILD ADD certs/* Dockerfile /etc/pki/ca-trust/source/anchors/
# ONBUILD RUN update-ca-trust
# ONBUILD USER 1001
# # ===