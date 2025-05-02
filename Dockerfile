FROM node:21-alpine

# Run server

RUN mkdir -p /opt/foundryvtt/resources/app && \
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

USER fvtt
ENTRYPOINT ["/opt/foundryvtt/run-server.sh"]
CMD ["resources/app/main.mjs", "--port=30000", "--dataPath=/data/foundryvtt"]