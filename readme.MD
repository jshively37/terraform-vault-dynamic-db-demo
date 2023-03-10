# HashiCorp Vault and Postgres Dynamic DB Demo

Repo that contains a shell script and Terraform code that will configure the following:

* A shell script will launch a Postgres docker container and a HashiCorp dev vault instance with the token set to root.
* Terraform code that will configure the dev Vault environment to create dynamic Postgres credentials using the Postgres docker container.

*NOTE* This is for demo purpose only.

## Requirements

This has been tested under the following versions
```
Docker version 20.10.21, build baeda1
Terraform==1.3.7
```

## Building the environment

In a terminal window, issue the `./start/docker_vault_start.sh`. This shell script is responsible for:

* Launch a docker container using the latest Postgres docker container.
* Start a vault dev instance with the token set to root.


Open another terminal window and issue the following export commands:
```shell
export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN=root
```

In the same terminal window where you exported the variables we will use Terraform to configure Vault.

```terraform
terraform init
terraform plan
terraform apply -auto-approve
```

## Creating dynamic users

Once Vault has been configured use the following commands to interact with Vault and test the dynamic DB functionality.

Create a dynamic user: `vault read db/creds/readonly`

List the db users configured on the Postgres Docker container:
```docker
docker exec -i \
    postgresdb \
    psql -U pgadmin -c "SELECT usename, valuntil FROM pg_user;"
```

Revoke a dynamic user: `vault lease revoke {{lease_id}}`

The lease_id can be found in the `vault read db/creds/readonly` output

```
Key                Value
---                -----
lease_id           db/creds/readonly/wSPPN3H8uYlcmS3JkMZKG9NU
lease_duration     768h
lease_renewable    true
(username and password removed)
```

## Shutting down the environment

Issue a `terraform destroy -auto-approve` to remove the Vault configuration

Issue a `ctrl + c` to terminate the vault instance

To find the running container issue a `docker container ls | grep postgres` and then `docker container stop {{ container_id }}`
