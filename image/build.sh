docker build -t openproject-id-keycloak:$1 -f Containerfile --build-arg KEYCLOAK_VERSION=$1 .
