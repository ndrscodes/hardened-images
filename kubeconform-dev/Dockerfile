FROM --platform=$BUILDPLATFORM golang:1.27.2-alpine@sha256:85dc1069ac644ea3c527b177303a406eb3358192816cd7f9e5848eb658851673 AS builder

ARG GIT_TAG
ARG TARGETOS
ARG TARGETARCH
# renovate: datasource=go depName=github.com/goreleaser/goreleaser
ARG GORELEASER_VERSION=v2.18.2
# renovate: datasource=github-tags depName=kubernetes/kubernetes
ARG KUBECTL_VERSION=v1.37.1

RUN go install github.com/goreleaser/goreleaser/v2@${GORELEASER_VERSION} \
  && apk add --no-cache git

RUN git clone --depth 1 --branch ${GIT_TAG} https://github.com/yannh/kubeconform.git \
  && cd kubeconform \
  && goreleaser build --clean \
  && cp dist/kubeconform_${TARGETOS}_${TARGETARCH}_*/kubeconform /kubeconform \
  && cp dist/openapi2jsonschema_${TARGETOS}_${TARGETARCH}_*/openapi2jsonschema /openapi2jsonschema

RUN wget -O /kubectl "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/${TARGETOS}/${TARGETARCH}/kubectl" \
  && wget -O /kubectl.sha256 "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/${TARGETOS}/${TARGETARCH}/kubectl.sha256" \
  && echo "$(cat /kubectl.sha256)  /kubectl" | sha256sum -c - \
  && chmod a+x /kubectl

FROM alpine:3.24.2@sha256:294b683cb724975bec92580e1e685676bd4b50bda910ddb8c51d4cabeaec77e6

RUN addgroup -g 1000 kubeconform \
  && adduser -u 1000 -G kubeconform -D kubeconform \
  && apk add --no-cache ca-certificates

USER kubeconform

COPY --from=builder /kubeconform /kubectl /openapi2jsonschema /usr/local/bin/

ENTRYPOINT [ "kubeconform" ]