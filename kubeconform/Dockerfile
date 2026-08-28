FROM alpine:3.24.1

RUN addgroup -g 1000 kubeconform \
  && adduser -u 1000 -G kubeconform -D kubeconform
RUN apk add ca-certificates

USER kubeconform

COPY --from=ghcr.io/yannh/kubeconform:v0.8.0@sha256:faffaf43f95aa6425306e1ab8d6fcad72acb9049158f38e574c085ea1ec0f64e \
  /kubeconform /openapi2jsonschema /usr/local/bin/

ENTRYPOINT [ "kubeconform" ]