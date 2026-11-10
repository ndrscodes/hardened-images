FROM --platform=$BUILDPLATFORM golang:1.27.3-alpine@sha256:fa3d596898d9f126af7c01d14ee7597bab3f39cccf392ef36b69fe77cd681f18 AS builder

ARG GIT_TAG
ARG TARGETOS
ARG TARGETARCH
# renovate: datasource=go depName=github.com/goreleaser/goreleaser
ARG GORELEASER_VERSION=v2.20.0

RUN go install github.com/goreleaser/goreleaser/v2@${GORELEASER_VERSION} \
  && apk add --no-cache git

RUN git clone --depth 1 --branch ${GIT_TAG} https://github.com/yannh/kubeconform.git \
  && cd kubeconform \
  && goreleaser build --clean \
  && cp dist/kubeconform_${TARGETOS}_${TARGETARCH}_*/kubeconform /kubeconform \
  && cp dist/openapi2jsonschema_${TARGETOS}_${TARGETARCH}_*/openapi2jsonschema /openapi2jsonschema

FROM alpine:3.24.4@sha256:f59abe656b692d901e184be3445e084786602108599d2a51d229c0f5a48c71bf

RUN addgroup -g 1000 kubeconform \
  && adduser -u 1000 -G kubeconform -D kubeconform \
  && apk add --no-cache ca-certificates

USER kubeconform

COPY --from=builder /kubeconform /openapi2jsonschema /usr/local/bin/

ENTRYPOINT [ "kubeconform" ]