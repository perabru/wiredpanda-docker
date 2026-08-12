FROM alpine:3.22 AS downloader

RUN apk add --no-cache git ca-certificates

RUN git clone \
    --depth 1 \
    --single-branch \
    --branch site \
    https://github.com/GIBIS-UNIFESP/wiredpanda.git \
    /wiredpanda \
    && test -f /wiredpanda/public/wasm/index.html

FROM nginx:alpine

COPY --from=downloader /wiredpanda/public/wasm/ /usr/share/nginx/html/
COPY default.conf.template /etc/nginx/templates/default.conf.template

ENV PORT=8080

EXPOSE 8080
