# Ghost

Docker image packaging for [Ghost][1]. Available on the [Docker Hub][2].

## Usage

This Docker image uses [Ghost CLI][3]. This new way of managing Ghost installations presented an interesting challenge for producing an easy to use and configure Docker image. Ghost CLI is now the only recommended method of installing Ghost, but also tries to manage elements of your system's configuration too (e.g. configuring a user to run as, systemd, Nginx, MySQL, etc.). This image skips most of those checks, and presents some environment variables for easy configuration.

**Configuration**

You can use the following environment variables to configure the image:

| Env Variable Name | Description                                       | Default                 |
|-------------------|---------------------------------------------------|-------------------------|
| `GHOST_DB`        | Database type, `mysql` or `sqlite3`.              | `mysql`                 |
| `GHOST_DB_HOST`   | Database host (if `mysql` host).                  | `db.docker`             |
| `GHOST_DB_PORT`   | Database port (if `mysql` host).                  | `3306`                  |
| `GHOST_DB_USER`   | Database user (if `mysql` host).                  | `ghost`                 |
| `GHOST_DB_PASS`   | Database password (if `mysql` host).              | `ghost`                 |
| `GHOST_DB_NAME`   | Database name (if `mysql` host).                  | `ghost`                 |
| `GHOST_URL`       | Ghost public URL.                                 | `http://localhost:2368` |
| `GHOST_ENV`       | Ghost environment, `production` or `development`. | `production`            |
| `GHOST_VERSION`   | Ghost version (increase this to update Ghost).    | `1.1.0`                 |
| `NODE_ENV`        | Node environment.                                 | `production`            |
| `GHOST_DIR`       | Ghost installation directory (in container).      | `/opt/ghost`            |

If you start the image up with the default configuration, or the included `docker-compose.yml` file you should be able to access an instance of Ghost running in production mode at `http://localhost:2368` (unless you're running Docker in a VM, etc.).

## License

MIT

[1]: https://ghost.org
[2]: https://hub.docker.com/r/seeruk/ghost/
[3]: https://github.com/TryGhost/Ghost-CLI
