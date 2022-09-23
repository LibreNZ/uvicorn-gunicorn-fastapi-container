FROM ghcr.io/librenz/uvicorn-gunicorn-container/uvicorn-gunicorn:python3.10-slim-latest

ARG GIT_URL=local
LABEL org.opencontainers.image.source=$GIT_URL
COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

COPY ./app /app
