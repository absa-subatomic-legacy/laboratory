# OpenShift Jenkins Slaves

These images are based off the [OpenShift Jenkins slave images](https://github.com/openshift/jenkins).
It adds the following:

* Subatomic [Root CA](https://raw.githubusercontent.com/absa-subatomic/local-hadron-collider/master/minishift-addons/subatomic/certs/subatomic-ca-chain.pem) from Local Hadron Collider for local development

## Usage within your own environment

You can use these images as the base image that can be altered for your environment.
For example, you might want to add your own Root CA certiticates.