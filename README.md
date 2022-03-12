# Docker Container Configurations

## Details

### File Structure

The main file is `docker-compose.yml`, where all components of the MentorBank are defined.

In the `dockerfiles/` there are several `.Dockerfile` files, they are Docker configurations for each containers.

This repository contains 3 submodules, `backend`, `database` and `frontend`. These correspond to the actural project structure.

### Network Organisation and Interconnection

The backend has been splitted up to 4 micro services, each running independently in its own Docker container, each of the 4 backend
containers is connected to two different networks:

1. `mentorbank-network`: Network between backend gRPC server to the frontend `Node.JS` server.
2. `mentorbank-db-network`: Network between backend gRPC server to the database.

Within one network, containers are able to communicate with each other, so two networks are separated to ensure an enhanced security, 
preventing illicit access to the database from the frontend side.

## Dependencies

- Docker
- `docker-compose`

## Configuration and Usage

1. Open `docker-compose.yml` and change corresponding fields:
   - Change `NEXTAUTH_URL` to your hosting URL
   - Change `JWT_SECRET`, `NEXTAUTH_SECRET` and `API_SECRET_KEY` to randomly generated strings.
 
     You can generate one using `openssl rand -hex 32`

2. To make sure the permission is correct, you should run `chmod a+rw ./database/*.sql` if these files are not global-readable.
3. Run `docker-compose build` in the repository root directory, to build the containers.
4. Run `docker-compose up` to start the containers for the first time.

   **Note: When it's the first time to start the container, the database container will do**
   **initialisations, causing backends failures when they're trying to connect to the DB**
   **at this time, producing error messages.**

   When this happens, stop and restart the container will fix the problem, since the database is
   fully initialised now.

5. The web server is now accessible via [`http://localhost:9000/`](http://localhost:9000/), to configure TLS for secure connections you'll need a reverse proxy engine, which could be Nginx, Apache, Caddy or any web server
that supports this.



