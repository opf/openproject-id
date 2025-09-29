# OpenProject ID Helm Chart

This is the Helm Chart for OpenProject ID deployments. It's intended to be simple, which means we expose configuration
for things that we need to configure for our specific use case, but leave things that we don't need to configure static.
The intention is to have templates that are easier to read, while giving us flexibility where we need it.

## Configuration

### Development

The defaults in the helm chart should be working right away on a development cluster (e.g. minikube):

```bash
helm upgrade --install keycloak .
```

### Production

Make sure that the corresponding Helm repository is configured:

```bash
helm repo add openproject-id https://opf.github.io/openproject-id/
```

Configuration-wise you want to:

* disable the postgres dependency (because we want to run the database in a managed service like RDS)
* disable generation of secrets, because we usually seed these externally, e.g. via Terraform
* Customize the remaining values (e.g. adding annotations)

An example values.yaml for your production environment might look like this:

```yaml
config:
  databaseHost: my-custom-db-host.example.com
  databaseName: keycloak
  databaseUser: keycloak

image:
  name: openproject/openproject-id:26.3.3

ingress:
  annotations:
    alb.ingress.kubernetes.io/scheme: "internet-facing"
  class: alb
  host: id.example.com

scaling:
  replicaCount: 2

secrets:
  create: false
  name: keycloak

service:
  annotations:
    alb.ingress.kubernetes.io/target-type: "ip"

postgresql:
  create: false
```

## Limitations & things to note

### Resources

Default resource requests and limits are a "best guess" so far. We'll need to see what the actual demand in our real Kubernetes
clusters looks like.

### Caching

One of the complicating factors of a Keycloak deployment is that the pods are not absolutely stateless. Keycloak includes a
[distributed cache on top of Infinispan](https://www.keycloak.org/server/caching). If pods are rotated too quickly, the cache is
dropped and needs to be rebuilt. It's not yet clear whether this would be noticeable in a deployment of our size, but we should
be aware that this is a thing.

If we were to introduce a horizontal pod autoscaler (HPA), we'd need to ensure to drop pods one after another.
