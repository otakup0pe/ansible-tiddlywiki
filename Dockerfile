FROM node:alpine

ARG VERSION=0.0.0
LABEL license="MIT"
LABEL version="${VERSION}"
LABEL maintainer="Jonathan Freedman <jonafree@gmail.com>"

RUN npm install -g tiddlywiki
COPY scripts/docker-entrypoint /usr/local/bin/tiddly-entrypoint

VOLUME /opt/tiddlers
EXPOSE 8080
CMD ["/usr/local/bin/tiddly-entrypoint"]
