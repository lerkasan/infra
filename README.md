# Getting Started

### Reference Documentation

For further reference, please consider the following sections:

* [Install Docker](https://docs.docker.com/engine/install/)


### Keycloak

Credentials for the Keycloak server and its database, as well as the port for Keycloak can be configured in the file `.env` in the `keycloak` directory.

Steps to run Keycloak locally:
* Make sure that Docker (or Docker Desktop) and Docker Compose v2 (included in Docker Desktop) are installed on your computer
* Change directory to `keycloak`
* If needed, add a custom realm configuration in the file `config.json` in the directory `keycloak` 
    
  _Notice:_ Please, see `config-example.json` file for reference  
* Run Keyckloak container by typing in command prompt `docker compose up`

  _Notice:_ All Keycloak data will be stored in the `db_data` subdirectory

Steps to stop Keycloak
* Press `Ctrl+C` in command prompt

Steps to delete Keycloak
* Change directory to `keycloak`
* Run `docker compose down` in command prompt
* Delete the `db_data` subdirectory
