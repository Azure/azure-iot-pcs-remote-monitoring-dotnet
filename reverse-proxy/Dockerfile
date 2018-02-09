FROM nginx:1.13

MAINTAINER Devis Lucato (https://github.com/dluc)

LABEL Tags="Azure,IoT,Solutions,Proxy,nginx"

COPY ./content/ /app
WORKDIR /app

RUN mkdir /app/config/ && mv /app/nginx.conf /app/config/

# TODO: remove port 80
EXPOSE 80 443
VOLUME ["/app/certs", "/app/config"]

ENTRYPOINT ["/bin/bash", "/app/run.sh"]