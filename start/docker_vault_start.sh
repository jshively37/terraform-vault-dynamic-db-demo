# Remove container named mongodb
docker rm -f postgresdb

docker run \
    --detach \
    --name postgresdb \
    -e POSTGRES_USER=pgadmin \
    -e POSTGRES_PASSWORD=password \
    -p 5432:5432 \
    --rm \
    postgres

# Start a dev vault instance
vault server -dev -dev-root-token-id=root
