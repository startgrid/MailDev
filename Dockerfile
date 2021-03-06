FROM node:8-alpine
MAINTAINER "Dan Farrelly <daniel.j.farrelly@gmail.com>"

ENV NODE_ENV production

RUN apk add --no-cache curl

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ADD package*.json /usr/src/app/

RUN npm install && \
    npm prune && \
    npm cache clean --force && \
    rm -rf /tmp/*

ADD . /usr/src/app/

EXPOSE 80 25

ENTRYPOINT ["bin/maildev"]
CMD ["--web", "80", "--smtp", "25"]

HEALTHCHECK --interval=10s --timeout=1s \
  CMD curl -k -f -v http://localhost/healthz || exit 1
