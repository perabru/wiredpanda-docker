FROM alpine:3.22 AS download

RUN apk add --no-cache git ca-certificates

RUN git clone \
    --depth 1 \
    --single-branch \
    --branch site \
    https://github.com/GIBIS-UNIFESP/wiredpanda.git \
    /wiredpanda

FROM nginx:alpine

COPY --from=download /wiredpanda/public/wasm/ /usr/share/nginx/html/
COPY default.conf.template /etc/nginx/templates/default.conf.template

ENV PORT=8080

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s \
    CMD wget -q --spider "http://127.0.0.1:${PORT}/" || exit 1