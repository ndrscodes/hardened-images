FROM --platform=$BUILDPLATFORM python:3.15.1-alpine3.24@sha256:54448f67d7c31c39e5cdd3ea2d6382395ce142806c284425f8e897d78a0465b3 AS builder

ARG GIT_TAG

RUN apk add --no-cache git

WORKDIR /build

RUN git clone --depth 1 --branch ${GIT_TAG} https://github.com/ndrscodes/openapi2jsonschema.git . \
    && python -m venv /opt/venv \
    && /opt/venv/bin/pip install --no-cache-dir -r requirements.txt .

FROM --platform=$BUILDPLATFORM python:3.15.1-alpine3.24@sha256:54448f67d7c31c39e5cdd3ea2d6382395ce142806c284425f8e897d78a0465b3

COPY --from=builder /opt/venv /opt/venv

RUN addgroup -g 1000 appgroup \
    && adduser -u 1000 -G appgroup -D appgroup

ENV PATH="/opt/venv/bin:$PATH" \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

USER appuser
WORKDIR /home/appuser

ENTRYPOINT [ "openapi2jsonschema" ]