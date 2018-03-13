FROM nginx:1.13

MAINTAINER Devis Lucato (https://github.com/dluc)

LABEL Tags="Azure,IoT,Solutions,Proxy,nginx"

ARG user=pcsuser

RUN useradd -m -s /bin/bash -U $user

COPY ./content/ /app
RUN  mkdir -p /app/config/ && mv /app/nginx.conf /app/config/ \
 && chown -R $user:$user /app \
 && mkdir -p /var/lib/nginx /var/cache/nginx /var/tmp/nginx \
 && chown -R $user:$user /var/lib/nginx /var/cache/nginx /var/tmp/nginx
WORKDIR /app

# TODO: remove port 8080
EXPOSE 8080 8443
VOLUME ["/app/certs", "/app/config"]

ENTRYPOINT ["/bin/bash", "/app/run.sh"]

USER $user
