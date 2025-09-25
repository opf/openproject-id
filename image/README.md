# OpenProject ID Image

This is the image setup for the optimized Keycloak image used by OpenProject ID. Building a custom image has two purposes:

* Preoptimizing the image, reducing the startup time of containers (see [Keycloak docs](https://www.keycloak.org/server/containers#_creating_a_customized_and_optimized_container_image))
* Customizing what's in the image (e.g. adding custom themes and providers)

## Usage in Development

Assuming that you develop locally with Minikube, you can make sure that built images are built using the Docker Daemon that runs
Minikube. In a terminal run:

```bash
eval $(minikube docker-env)
```

Afterwards, you should be able to interact with Minikube through your regular `docker` command. To build an image, run

```bash
# This builds an image for Keycloak version 26.3.3
./build.sh 26.3.3
```

The built image will be tagged `openproject-id-keycloak:26.3.3`. This tag can be used as the image name when running the Helm chart.

## Building a new image to be used in production

TODO: We have yet to figure out how to do that
