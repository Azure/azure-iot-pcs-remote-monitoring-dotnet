FROM node:carbon

MAINTAINER Ramu bachala (https://github.com/rb531)

LABEL Tags="Azure,IoT,Solutions,Intel,AMT"

ARG user=pcsuser

RUN useradd -m -s /bin/bash -U $user

ENTRYPOINT ["/bin/bash", "/app/run.sh"]

COPY . /app/

RUN chown -R $user.$user /app
WORKDIR /app

USER $user