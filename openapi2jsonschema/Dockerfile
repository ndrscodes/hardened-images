FROM --platform=$BUILDPLATFORM python:3.15.0-alpine3.24@sha256:ff4d3c9b1a48f646eedd93182aaea385c7a5452f4c8a8cd7cef686babacf4928 AS builder

ARG GIT_TAG

RUN apk add --no-cache git

WORKDIR /build

RUN git clone --depth 1 --branch ${GIT_TAG} https://github.com/ndrscodes/openapi2jsonschema.git . \
    && python -m venv /opt/venv \
    && /opt/venv/bin/pip install --no-cache-dir -r requirements.txt .

FROM --platform=$BUILDPLATFORM python:3.15.0-alpine3.24@sha256:ff4d3c9b1a48f646eedd93182aaea385c7a5452f4c8a8cd7cef686babacf4928

COPY --from=builder /opt/venv /opt/venv

RUN addgroup -g 1000 appgroup \
    && adduser -u 1000 -G appgroup -D appgroup

ENV PATH="/opt/venv/bin:$PATH" \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

USER appuser
WORKDIR /home/appuser

ENTRYPOINT [ "openapi2jsonschema" ]