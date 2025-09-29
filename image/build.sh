docker build -t openproject/openproject-id:$1-dev -f Containerfile --build-arg KEYCLOAK_VERSION=$1 .
