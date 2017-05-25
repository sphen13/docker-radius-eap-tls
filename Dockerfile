FROM alpine:3.5

RUN apk add --no-cache freeradius openssl

ENV CLIENT_ADDRESS CLIENT_SECRET \
    PRIVATE_CERT PRIVATE_KEY PRIVATE_KEY_PASSWORD \
    CA_CERT DH_FILE

COPY radiusd.conf clients.conf /etc/raddb/
COPY eap /etc/raddb/mods-available
COPY site /etc/raddb/sites-available

RUN rm /etc/raddb/sites-enabled/* && \
    rm -rf /etc/raddb/certs && \
    ln -s /etc/raddb/sites-available/site /etc/raddb/sites-enabled/site && \
    chgrp -R radius /etc/raddb/ && \
    mkdir /tmp/radiusd

EXPOSE 1812/udp
VOLUME /etc/raddb/certs

ENTRYPOINT ["/usr/sbin/radiusd"]
CMD ["-X", "-f"]
