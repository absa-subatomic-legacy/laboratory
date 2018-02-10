# Subatomic Java Maven S2I image

This S2I image is based off the [Spring Boot Maven 3 S2I image](https://github.com/codecentric/springboot-maven3-centos) from Codecentric.

It add the following:

* Maven 3
* Oracle JDK 8
* [NewRelic Java agent](https://docs.newrelic.com/docs/agents/java-agent)
* Subatomic [Root CA](https://raw.githubusercontent.com/absa-subatomic/local-hadron-collider/master/minishift-addons/subatomic/certs/subatomic-ca-chain.pem) from Local Hadron Collider for local development

It also borrows from the following projects:

* [RHEL S2I Java builder image with OpenJDK 8](https://github.com/fabric8io-images/s2i/tree/master/java/images/rhel) with:
  * Prometheus JMX Java agent
  * Jolokia Java agent
  * [run-java.sh](https://github.com/fabric8io-images/s2i/blob/master/java/images/rhel/run-java.sh) 

## Usage within your own environment

You can use this image as the base for a Jenkins image that should be altered for your environment.
For example, you might want to add your own Root CA certiticates.