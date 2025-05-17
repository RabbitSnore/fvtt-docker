FROM --platform=linux/amd64 amd64/node:24-bookworm-slim

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
    chown -R fvtt:fvtt /opt/foundryvtt/ && \
    chown -R fvtt:fvtt /opt/foundryvtt/resources && \
    chmod -R a+rwx /data/foundryvtt && \
    chmod -R a+rwx /opt/foundryvtt/ && \
    chmod -R a+rwx /opt/foundryvtt/resources && \
    chmod -R a+rwx /opt/foundryvtt/resources/app

USER root
VOLUME /data/foundryvtt
VOLUME /host
VOLUME /opt/foundryvtt/resources/app
EXPOSE 30000

USER fvtt
ENTRYPOINT /opt/foundryvtt/run-server.sh