FROM --platform=$BUILDPLATFORM golang:1.27.1-alpine@sha256:cf6fca6641884b8433441b2b0652976f975e1d0fdd26d177eaaf8596087f3125 AS builder

ARG GIT_TAG
ARG TARGETOS
ARG TARGETARCH
# renovate: datasource=go depName=github.com/goreleaser/goreleaser
ARG GORELEASER_VERSION=v2.18.0
# renovate: datasource=github-tags depName=kubernetes/kubernetes
ARG KUBECTL_VERSION=v1.37.0

RUN go install github.com/goreleaser/goreleaser/v2@${GORELEASER_VERSION} \
  && apk add --no-cache git

RUN git clone --depth 1 --branch ${GIT_TAG} https://github.com/yannh/kubeconform.git \
  && cd kubeconform \
  && goreleaser build --clean \
  && cp dist/kubeconform_${TARGETOS}_${TARGETARCH}_*/kubeconform /kubeconform \
  && cp dist/openapi2jsonschema_${TARGETOS}_${TARGETARCH}_*/openapi2jsonschema /openapi2jsonschema

RUN wget -O /kubectl "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/${TARGETOS}/${TARGETARCH}/kubectl" \
  && wget -O /kubectl.sha256 "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/${TARGETOS}/${TARGETARCH}/kubectl.sha256" \
  && echo "$(cat /kubectl.sha256) /kubectl" | sha256sum --check \
  && chmod u+x /kubectl

FROM alpine:3.24.1@sha256:28bd5fe8b56d1bd048e5babf5b10710ebe0bae67db86916198a6eec434943f8b

RUN addgroup -g 1000 kubeconform \
  && adduser -u 1000 -G kubeconform -D kubeconform \
  && apk add --no-cache ca-certificates

USER kubeconform

COPY --from=builder /kubeconform /kubectl /openapi2jsonschema /usr/local/bin/

ENTRYPOINT [ "kubeconform" ]