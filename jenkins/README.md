# OpenShift Jenkins

This image is based off the [OpenShift Jenkins image](https://github.com/openshift/jenkins).
It adds the following:

* Subatomic [Root CA](https://raw.githubusercontent.com/absa-subatomic/local-hadron-collider/master/minishift-addons/subatomic/certs/subatomic-ca-chain.pem) from Local Hadron Collider for local development
* Use updated Jenkins plugins as well as any custom plugins used
* Remove the OpenShift sample Job
* Add Subatomic related configuration which prevents any manual configuration out the box

## Usage within your own environment

You can use this image as the base for a Jenkins image that should be altered for your environment.
For example, you might want to add your own Root CA certiticates.