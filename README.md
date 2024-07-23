[![Test](https://github.com/LibreNZ/uvicorn-gunicorn-fastapi-container/workflows/Test/badge.svg)](https://github.com/LibreNZ/uvicorn-gunicorn-fastapi-container/actions?query=workflow%3ATest) [![Deploy](https://github.com/LibreNZ/uvicorn-gunicorn-fastapi-container/workflows/Deploy/badge.svg)](https://github.com/LibreNZ/uvicorn-gunicorn-fastapi-container/actions?query=workflow%3ADeploy)

## Supported tags and respective `Dockerfile` links

* [`python3.12`, `latest` _(Dockerfile)_](https://github.com/LibreNZ/uvicorn-gunicorn-fastapi-container/blob/master/docker-images/python3.12.dockerfile)
* [`python3.11`, _(Dockerfile)_](https://github.com/LibreNZ/uvicorn-gunicorn-fastapi-container/blob/master/docker-images/python3.11.dockerfile)
* [`python3.10`, _(Dockerfile)_](https://github.com/LibreNZ/uvicorn-gunicorn-fastapi-container/blob/master/docker-images/python3.10.dockerfile)
* [`python3.12-slim` _(Dockerfile)_](https://github.com/LibreNZ/uvicorn-gunicorn-fastapi-container/blob/master/docker-images/python3.12-slim.dockerfile)
* [`python3.11-slim` _(Dockerfile)_](https://github.com/LibreNZ/uvicorn-gunicorn-fastapi-container/blob/master/docker-images/python3.11-slim.dockerfile)

---

**Note**: There are [tags for each build date](ghcr.io/librenz/uvicorn-gunicorn-fastapi-container/uvicorn-gunicorn-fastapi/tags). If you need to "pin" the Docker image version you use, you can select one of those tags. E.g. `ghcr.io/librenz/uvicorn-gunicorn-fastapi-container/uvicorn-gunicorn-fastapi:python3.10-2019-10-15`.

# uvicorn-gunicorn-fastapi

[**Docker**](https://www.docker.com/) image with [**Uvicorn**](https://www.uvicorn.org/) managed by [**Gunicorn**](https://gunicorn.org/) for high-performance [**FastAPI**](https://fastapi.tiangolo.com/) web applications in **[Python](https://www.python.org/) 3.6 and above** with performance auto-tuning. Optionally in a slim version or based on Alpine Linux.

**GitHub repo**: [https://github.com/LibreNZ/uvicorn-gunicorn-fastapi-container](https://github.com/LibreNZ/uvicorn-gunicorn-fastapi-container)

**Docker Hub image**: [ghcr.io/librenz/uvicorn-gunicorn-fastapi-container/uvicorn-gunicorn-fastapi/](ghcr.io/librenz/uvicorn-gunicorn-fastapi-container/uvicorn-gunicorn-fastapi/)

## Description

**FastAPI** has shown to be a Python web framework with [one of the best performances, as measured by third-party benchmarks](https://www.techempower.com/benchmarks/#section=test&runid=a979de55-980d-4721-a46f-77298b3f3923&hw=ph&test=fortune&l=zijzen-7), thanks to being based on and powered by [**Starlette**](https://www.starlette.io/).

The achievable performance is on par with (and in many cases superior to) **Go** and **Node.js** frameworks.

This image has an **auto-tuning** mechanism included to start a number of worker processes based on the available CPU cores. That way you can just add your code and get **high performance** automatically, which is useful in **simple deployments**.

---

In some cases (e.g. using Kubernetes) you would probably want to build a **Docker image from scratch**, installing your dependencies, and running **a single Uvicorn process** instead of this image.

For example, your `Dockerfile` could look like:

```Dockerfile
FROM python:3.9

WORKDIR /code

COPY ./requirements.txt /code/requirements.txt

RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt

COPY ./app /code/app

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "80"]
```

You can read more about this in the [FastAPI documentation about: FastAPI in Containers - Docker](https://fastapi.tiangolo.com/deployment/docker/#replication-number-of-processes).

## When to Use this Docker Image

### A Simple App

You could want a process manager like Gunicorn running Uvicorn workers in the container if your application is **simple enough** that you don't need (at least not yet) to fine-tune the number of processes too much, and you can just use an automated default, and you are running it on a **single server**, not a cluster.

### Docker Compose

You could be deploying to a **single server** (not a cluster) with **Docker Compose**, so you wouldn't have an easy way to manage replication of containers (with Docker Compose) while preserving the shared network and **load balancing**.

Then you could want to have **a single container** with a Gunicorn **process manager** starting **several Uvicorn worker processes** inside, as this Docker image does.

### Prometheus and Other Reasons

You could also have **other reasons** that would make it easier to have a **single container** with **multiple processes** instead of having **multiple containers** with **a single process** in each of them.

For example (depending on your setup) you could have some tool like a Prometheus exporter in the same container that should have access to **each of the requests** that come.

In this case, if you had **multiple containers**, by default, when Prometheus came to **read the metrics**, it would get the ones for **a single container each time** (for the container that handled that particular request), instead of getting the **accumulated metrics** for all the replicated containers.

Then, in that case, it could be simpler to have **one container** with **multiple processes**, and a local tool (e.g. a Prometheus exporter) on the same container collecting Prometheus metrics for all the internal processes and exposing those metrics on that single container.

---

Read more about it all in the [FastAPI documentation about: FastAPI in Containers - Docker](https://fastapi.tiangolo.com/deployment/docker/).

## Technical Details

### Uvicorn

**Uvicorn** is a lightning-fast "ASGI" server.

It runs asynchronous Python web code in a single process.

### Gunicorn

You can use **Gunicorn** to start and manage multiple Uvicorn worker processes.

That way, you get the best of concurrency and parallelism in simple deployments.

### FastAPI

FastAPI is a modern, fast (high-performance), web framework for building APIs with Python 3.6+.

The key features are:

* **Fast**: Very high performance, on par with **NodeJS** and **Go** (thanks to Starlette and Pydantic).
* **Fast to code**: Increase the speed to develop features by about 200% to 300% *.
* **Less bugs**: Reduce about 40% of human (developer) induced errors. *
* **Intuitive**: Great editor support. <abbr title="also known as auto-complete, autocompletion, IntelliSense">Completion</abbr> everywhere. Less time debugging.
* **Easy**: Designed to be easy to use and learn. Less time reading docs.
* **Short**: Minimize code duplication. Multiple features from each parameter declaration. Less bugs.
* **Robust**: Get production-ready code. With automatic interactive documentation.
* **Standards-based**: Based on (and fully compatible with) the open standards for APIs: <a href="https://github.com/OAI/OpenAPI-Specification" target="_blank">OpenAPI</a> (previously known as Swagger) and <a href="http://json-schema.org/" target="_blank">JSON Schema</a>.

<small>* estimation based on tests on an internal development team, building production applications.</small>

### `ghcr.io/librenz/uvicorn-gunicorn-fastapi-container/uvicorn-gunicorn-fastapi`

This image will set a sensible configuration based on the server it is running on (the amount of CPU cores available) without making sacrifices.

It has sensible defaults, but you can configure it with environment variables or override the configuration files.

## Advanced usage

### Environment variables

These are the environment variables that you can set in the container to configure it and their default values:

#### `MODULE_NAME`

The Python "module" (file) to be imported by Gunicorn, this module would contain the actual application in a variable.

By default:

* `app.main` if there's a file `/app/app/main.py` or
* `main` if there's a file `/app/main.py`

For example, if your main file was at `/app/custom_app/custom_main.py`, you could set it like:

```bash
docker run -d -p 80:80 -e MODULE_NAME="custom_app.custom_main" myimage
```

#### `VARIABLE_NAME`

The variable inside of the Python module that contains the FastAPI application.

By default:

* `app`

For example, if your main Python file has something like:

```Python
from fastapi import FastAPI

api = FastAPI()


@api.get("/")
def read_root():
    return {"Hello": "World"}
```

In this case `api` would be the variable with the FastAPI application. You could set it like:

```bash
docker run -d -p 80:80 -e VARIABLE_NAME="api" myimage
```

#### `APP_MODULE`

The string with the Python module and the variable name passed to Gunicorn.

By default, set based on the variables `MODULE_NAME` and `VARIABLE_NAME`:

* `app.main:app` or
* `main:app`

You can set it like:

```bash
docker run -d -p 80:80 -e APP_MODULE="custom_app.custom_main:api" myimage
```

#### `GUNICORN_CONF`

The path to a Gunicorn Python configuration file.

By default:

* `/app/gunicorn_conf.py` if it exists
* `/app/app/gunicorn_conf.py` if it exists
* `/gunicorn_conf.py` (the included default)

You can set it like:

```bash
docker run -d -p 80:80 -e GUNICORN_CONF="/app/custom_gunicorn_conf.py" myimage
```

You can use the [config file from the base image](https://github.com/tiangolo/uvicorn-gunicorn-docker/blob/master/docker-images/gunicorn_conf.py) as a starting point for yours.

#### `WORKERS_PER_CORE`

This image will check how many CPU cores are available in the current server running your container.

It will set the number of workers to the number of CPU cores multiplied by this value.

By default:

* `1`

You can set it like:

```bash
docker run -d -p 80:80 -e WORKERS_PER_CORE="3" myimage
```

If you used the value `3` in a server with 2 CPU cores, it would run 6 worker processes.

You can use floating point values too.

So, for example, if you have a big server (let's say, with 8 CPU cores) running several applications, and you have a FastAPI application that you know won't need high performance. And you don't want to waste server resources. You could make it use `0.5` workers per CPU core. For example:

```bash
docker run -d -p 80:80 -e WORKERS_PER_CORE="0.5" myimage
```

In a server with 8 CPU cores, this would make it start only 4 worker processes.

**Note**: By default, if `WORKERS_PER_CORE` is `1` and the server has only 1 CPU core, instead of starting 1 single worker, it will start 2. This is to avoid bad performance and blocking applications (server application) on small machines (server machine/cloud/etc). This can be overridden using `WEB_CONCURRENCY`.

#### `MAX_WORKERS`

Set the maximum number of workers to use.

You can use it to let the image compute the number of workers automatically but making sure it's limited to a maximum.

This can be useful, for example, if each worker uses a database connection and your database has a maximum limit of open connections.

By default it's not set, meaning that it's unlimited.

You can set it like:

```bash
docker run -d -p 80:80 -e MAX_WORKERS="24" myimage
```

This would make the image start at most 24 workers, independent of how many CPU cores are available in the server.

#### `WEB_CONCURRENCY`

Override the automatic definition of number of workers.

By default:

* Set to the number of CPU cores in the current server multiplied by the environment variable `WORKERS_PER_CORE`. So, in a server with 2 cores, by default it will be set to `2`.

You can set it like:

```bash
docker run -d -p 80:80 -e WEB_CONCURRENCY="2" myimage
```

This would make the image start 2 worker processes, independent of how many CPU cores are available in the server.

#### `HOST`

The "host" used by Gunicorn, the IP where Gunicorn will listen for requests.

It is the host inside of the container.

So, for example, if you set this variable to `127.0.0.1`, it will only be available inside the container, not in the host running it.

It's is provided for completeness, but you probably shouldn't change it.

By default:

* `0.0.0.0`

#### `PORT`

The port the container should listen on.

If you are running your container in a restrictive environment that forces you to use some specific port (like `8080`) you can set it with this variable.

By default:

* `80`

You can set it like:

```bash
docker run -d -p 80:8080 -e PORT="8080" myimage
```

#### `BIND`

The actual host and port passed to Gunicorn.

By default, set based on the variables `HOST` and `PORT`.

So, if you didn't change anything, it will be set by default to:

* `0.0.0.0:80`

You can set it like:

```bash
docker run -d -p 80:8080 -e BIND="0.0.0.0:8080" myimage
```

#### `LOG_LEVEL`

The log level for Gunicorn.

One of:

* `debug`
* `info`
* `warning`
* `error`
* `critical`

By default, set to `info`.

If you need to squeeze more performance sacrificing logging, set it to `warning`, for example:

You can set it like:

```bash
docker run -d -p 80:8080 -e LOG_LEVEL="warning" myimage
```

#### `WORKER_CLASS`

The class to be used by Gunicorn for the workers.

By default, set to `uvicorn.workers.UvicornWorker`.

The fact that it uses Uvicorn is what allows using ASGI frameworks like FastAPI, and that is also what provides the maximum performance.

You probably shouldn't change it.

But if for some reason you need to use the alternative Uvicorn worker: `uvicorn.workers.UvicornH11Worker` you can set it with this environment variable.

You can set it like:

```bash
docker run -d -p 80:8080 -e WORKER_CLASS="uvicorn.workers.UvicornH11Worker" myimage
```

#### `TIMEOUT`

Workers silent for more than this many seconds are killed and restarted.

Read more about it in the [Gunicorn docs: timeout](https://docs.gunicorn.org/en/stable/settings.html#timeout).

By default, set to `120`.

Notice that Uvicorn and ASGI frameworks like FastAPI are async, not sync. So it's probably safe to have higher timeouts than for sync workers.

You can set it like:

```bash
docker run -d -p 80:8080 -e TIMEOUT="20" myimage
```

#### `KEEP_ALIVE`

The number of seconds to wait for requests on a Keep-Alive connection.

Read more about it in the [Gunicorn docs: keepalive](https://docs.gunicorn.org/en/stable/settings.html#keepalive).

By default, set to `2`.

You can set it like:

```bash
docker run -d -p 80:8080 -e KEEP_ALIVE="20" myimage
```

#### `GRACEFUL_TIMEOUT`

Timeout for graceful workers restart.

Read more about it in the [Gunicorn docs: graceful-timeout](https://docs.gunicorn.org/en/stable/settings.html#graceful-timeout).

By default, set to `120`.

You can set it like:

```bash
docker run -d -p 80:8080 -e GRACEFUL_TIMEOUT="20" myimage
```

#### `ACCESS_LOG`

The access log file to write to.

By default `"-"`, which means stdout (print in the Docker logs).

If you want to disable `ACCESS_LOG`, set it to an empty value.

For example, you could disable it with:

```bash
docker run -d -p 80:8080 -e ACCESS_LOG= myimage
```

#### `ERROR_LOG`

The error log file to write to.

By default `"-"`, which means stderr (print in the Docker logs).

If you want to disable `ERROR_LOG`, set it to an empty value.

For example, you could disable it with:

```bash
docker run -d -p 80:8080 -e ERROR_LOG= myimage
```

#### `GUNICORN_CMD_ARGS`

Any additional command line settings for Gunicorn can be passed in the `GUNICORN_CMD_ARGS` environment variable.

Read more about it in the [Gunicorn docs: Settings](https://docs.gunicorn.org/en/stable/settings.html#settings).

These settings will have precedence over the other environment variables and any Gunicorn config file.

For example, if you have a custom TLS/SSL certificate that you want to use, you could copy them to the Docker image or mount them in the container, and set [`--keyfile` and `--certfile`](http://docs.gunicorn.org/en/latest/settings.html#ssl) to the location of the files, for example:

```bash
docker run -d -p 80:8080 -e GUNICORN_CMD_ARGS="--keyfile=/secrets/key.pem --certfile=/secrets/cert.pem" -e PORT=443 myimage
```

**Note**: instead of handling TLS/SSL yourself and configuring it in the container, it's recommended to use a "TLS Termination Proxy" like [Traefik](https://docs.traefik.io/). You can read more about it in the [FastAPI documentation about HTTPS](https://fastapi.tiangolo.com/deployment/#https).

#### `PRE_START_PATH`

The path where to find the pre-start script.

By default, set to `/app/prestart.sh`.

You can set it like:

```bash
docker run -d -p 80:8080 -e PRE_START_PATH="/custom/script.sh" myimage
```

### Custom Gunicorn configuration file

The image includes a default Gunicorn Python config file at `/gunicorn_conf.py`.

It uses the environment variables declared above to set all the configurations.

You can override it by including a file in:

* `/app/gunicorn_conf.py`
* `/app/app/gunicorn_conf.py`
* `/gunicorn_conf.py`

### Custom `/app/prestart.sh`

If you need to run anything before starting the app, you can add a file `prestart.sh` to the directory `/app`. The image will automatically detect and run it before starting everything.

For example, if you want to add Alembic SQL migrations (with SQLALchemy), you could create a `./app/prestart.sh` file in your code directory (that will be copied by your `Dockerfile`) with:

```bash
#! /usr/bin/env bash

# Let the DB start
sleep 10;
# Run migrations
alembic upgrade head
```

and it would wait 10 seconds to give the database some time to start and then run that `alembic` command.

If you need to run a Python script before starting the app, you could make the `/app/prestart.sh` file run your Python script, with something like:

```bash
#! /usr/bin/env bash

# Run custom Python script before starting
python /app/my_custom_prestart_script.py
```

You can customize the location of the prestart script with the environment variable `PRE_START_PATH` described above.

### Development live reload

The default program that is run is at `/start.sh`. It does everything described above.

There's also a version for development with live auto-reload at:

```bash
/start-reload.sh
```

#### Details

For development, it's useful to be able to mount the contents of the application code inside of the container as a Docker "host volume", to be able to change the code and test it live, without having to build the image every time.

In that case, it's also useful to run the server with live auto-reload, so that it re-starts automatically at every code change.

The additional script `/start-reload.sh` runs Uvicorn alone (without Gunicorn) and in a single process.

It is ideal for development.

#### Usage

For example, instead of running:

```bash
docker run -d -p 80:80 myimage
```

You could run:

```bash
docker run -d -p 80:80 -v $(pwd):/app myimage /start-reload.sh
```

* `-v $(pwd):/app`: means that the directory `$(pwd)` should be mounted as a volume inside of the container at `/app`.
    * `$(pwd)`: runs `pwd` ("print working directory") and puts it as part of the string.
* `/start-reload.sh`: adding something (like `/start-reload.sh`) at the end of the command, replaces the default "command" with this one. In this case, it replaces the default (`/start.sh`) with the development alternative `/start-reload.sh`.

#### Development live reload - Technical Details

As `/start-reload.sh` doesn't run with Gunicorn, any of the configurations you put in a `gunicorn_conf.py` file won't apply.

But these environment variables will work the same as described above:

* `MODULE_NAME`
* `VARIABLE_NAME`
* `APP_MODULE`
* `HOST`
* `PORT`
* `LOG_LEVEL`

## License

This project is licensed under the terms of the MIT license.
