FROM --platform=$BUILDPLATFORM golang:1.27.3-alpine@sha256:d200d2dd76b03a99b52651fd1325aff7dcd35422c35c01bac56571b0507f3deb AS builder

ARG GIT_TAG
ARG TARGETOS
ARG TARGETARCH
# renovate: datasource=go depName=github.com/goreleaser/goreleaser
ARG GORELEASER_VERSION=v2.18.3
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

FROM alpine:3.24.3@sha256:be2656061b536c1883c4034790e21d0a09c5aaaf51968b89368a3c0371ea2c9a

RUN addgroup -g 1000 kubeconform \
  && adduser -u 1000 -G kubeconform -D kubeconform \
  && apk add --no-cache ca-certificates

USER kubeconform

COPY --from=builder /kubeconform /kubectl /openapi2jsonschema /usr/local/bin/

ENTRYPOINT [ "kubeconform" ]