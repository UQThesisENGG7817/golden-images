## Best practices
* Using Security Advisor SACT/DAST such as Wiz, Snyk, SonarQube to find the best base image for the Product with “Size” and “Severity”

* Minimize the Number of Layers

* Multi-stage builds (sample Dockerfile)

* Run containerized app with least possible privilege (and never as root)

* Use Dockerignore

* Remove unnecessary cache/code/lib/package

## Quick reference origin images
docker: https://hub.docker.com/_/docker

docker-ci: https://hub.docker.com/_/docker

gocd-agent-docker-dind: https://hub.docker.com/r/gocd/gocd-agent-docker-dind

golang: https://hub.docker.com/_/golang

node: https://hub.docker.com/_/node/tags

openjdk: https://gallery.ecr.aws/docker/library/openjdk

openjdk-17-runtime: https://catalog.redhat.com/software/containers/ubi8/openjdk-17/618bdbf34ae3739687568813

openjdk-alpine: https://hub.docker.com/r/bellsoft/liberica-openjdk-alpine

python: https://hub.docker.com/_/python

