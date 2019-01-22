# Subatomic Laboratory [![Build Status](https://travis-ci.org/absa-subatomic/laboratory.svg?branch=master)](https://travis-ci.org/absa-subatomic/laboratory)
This repository contains OpenShift Templates, Build Configs, S2I images and other shared artifacts.

See the individual directories for more information.

## Building custom images

If you have custom requirements, like trusting additional root CA certificates to integrate with infrastructure in your environment, you can create your own custom builds using the Subatomic images as a base image.

Below is an example `Dockerfile` that uses the [Subatomic Java Maven S2I image](https://github.com/absa-subatomic/laboratory/tree/master/s2i-jdk8-maven3-subatomic) as a base and simply installs Git as an example:

```Dockerfile
FROM absasubatomic/s2i-jdk8-maven3-subatomic:latest

RUN yum install -y git \
  yum clean all && \
  rm -rf /var/cache/yum
```

## Additional root CA certificates

Provision has been made to add additional root CA certificates to images based off the various Subatomic images. Simply create a `certs` directory at the same level as the custom `Dockerfile` and copy all the root CA certificates you'd like to additionally trust into that directory.

When you build your custom image using your `Dockerile`, the [`OBNBUILD`](https://docs.docker.com/engine/reference/builder/#/onbuild) instruction will [add and update](https://github.com/absa-subatomic/laboratory/blob/f9cb385886898ceefe82f72544a8620168b3fa9f/s2i-jdk8-maven3-subatomic/Dockerfile#L121) the trusted CA certificates.

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of 
conduct, and the process for submitting pull requests to us.

## Versioning

No versioning numbering or tags in use at the time of this update.

## Authors

* **Kieran Bristow**    - [kbristow](https://github.com/kbristow)
* **Kieran Bester**     - [KieranHons](https://github.com/KieranHons)
* **Donovan Muller**    - [donovanmuller](https://github.com/donovanmuller)
* **Andre de Jager**    - [andrejonathan](https://github.com/andrejonathan)
* **Chris Kieser**      - [chriskieser](https://github.com/chriskieser)
* **Johnathan Asiamah** - [Asiamahj](https://github.com/Asiamahj)

See also the list of [contributors](https://github.com/absa-subatomic/laboratory/graphs/contributors) who participated in this project.

## License

This project is licensed under the Apache License v2.0 - see the 
[LICENSE](https://github.com/absa-subatomic/laboratory/blob/master/LICENSE) file for details