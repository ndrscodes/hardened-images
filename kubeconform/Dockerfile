FROM --platform=$BUILDPLATFORM golang:1.27.3-alpine@sha256:b8c9b82affbbb82a020bbcf998dad2ba9516944ac7e883524642a481a9505e9c AS builder

ARG GIT_TAG
ARG TARGETOS
ARG TARGETARCH
# renovate: datasource=go depName=github.com/goreleaser/goreleaser
ARG GORELEASER_VERSION=v2.18.3

RUN go install github.com/goreleaser/goreleaser/v2@${GORELEASER_VERSION} \
  && apk add --no-cache git

RUN git clone --depth 1 --branch ${GIT_TAG} https://github.com/yannh/kubeconform.git \
  && cd kubeconform \
  && goreleaser build --clean \
  && cp dist/kubeconform_${TARGETOS}_${TARGETARCH}_*/kubeconform /kubeconform \
  && cp dist/openapi2jsonschema_${TARGETOS}_${TARGETARCH}_*/openapi2jsonschema /openapi2jsonschema

FROM alpine:3.24.3@sha256:be2656061b536c1883c4034790e21d0a09c5aaaf51968b89368a3c0371ea2c9a

RUN addgroup -g 1000 kubeconform \
  && adduser -u 1000 -G kubeconform -D kubeconform \
  && apk add --no-cache ca-certificates

USER kubeconform

COPY --from=builder /kubeconform /openapi2jsonschema /usr/local/bin/

ENTRYPOINT [ "kubeconform" ]