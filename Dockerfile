ARG NODE_IMAGE_VERSION=22-bookworm-slim

FROM node:${NODE_IMAGE_VERSION} AS compile-typescript-stage

WORKDIR /root

COPY \
  package.json \
  package-lock.json \
  tsconfig.json \
  ./
RUN npm install && npm install --global typescript
COPY /src/*.ts src/
RUN tsc
RUN grep -l "#!" dist/*.js | xargs chmod a+x

FROM node:${NODE_IMAGE_VERSION} AS optional-release-stage

# Run server

RUN deluser node && \
    mkdir -p /opt/foundryvtt/resources/app && \
    mkdir /data && \
    mkdir /data/foundryvtt && \
    adduser --disabled-password fvtt && \
    chown fvtt:fvtt /opt/foundryvtt && \
    chown fvtt:fvtt /data/foundryvtt && \
    chmod g+s+rwx /opt/foundryvtt && \
    chmod g+s+rwx /data/foundryvtt
USER fvtt

COPY --chown=fvtt run-server.sh /opt/foundryvtt
RUN chmod +x /opt/foundryvtt/run-server.sh

# Set permissions for the volumes
USER root
RUN chown -R fvtt:fvtt /data/foundryvtt && \
    chown -R fvtt:fvtt /opt/foundryvtt/resources && \
    chmod -R g+s+rwx /data/foundryvtt && \
    chmod -R g+s+rwx /opt/foundryvtt/resources && \
    chmod -R g+s+rwx /opt/foundryvtt/resources/app

USER fvtt
VOLUME /data/foundryvtt
VOLUME /host
VOLUME /opt/foundryvtt/resources/app
EXPOSE 30000

ENTRYPOINT /opt/foundryvtt/run-server.sh
