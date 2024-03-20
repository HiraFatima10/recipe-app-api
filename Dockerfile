FROM python:3.9-alpine3.13
LABEL maintainer="hirafatima10"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000


ARG DEV=false
# Docker creates a new image layer with the changes made by the RUN command. 
# Each RUN command creates a new layer, allowing Docker to optimize caching and reuse previously built layers

# using multiple commands in single RUN to prevent docker for creating multiple layers.
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    # remove the /tmp directory to make the image light weighted.
    rm -rf /tmp && \     
    # Add new user inside docker image. using root user is not recommended. 
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/py/bin:$PATH"

USER django-user