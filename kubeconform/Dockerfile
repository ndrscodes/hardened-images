FROM alpine:3.24.1

RUN addgroup -g 1000 kubeconform \
  && adduser -u 1000 -G kubeconform -D kubeconform
RUN apk add ca-certificates

USER kubeconform

COPY --from=ghcr.io/yannh/kubeconform:v0.8.0-alpine@sha256:6b90a5f23d846140ce0194fe050b1995e546eba938f3a6bf10c039dd5e24588f \
  /kubeconform /openapi2jsonschema /usr/local/bin/

ENTRYPOINT [ "kubeconform" ]