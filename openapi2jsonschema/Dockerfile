FROM --platform=$BUILDPLATFORM python:3.14.7-alpine3.24@sha256:016508ba505da24f7139765bc4bb669df4e88eb2f12eeadd571bf2f88d7533df AS builder

ARG GIT_TAG

RUN apk add --no-cache git

WORKDIR /build

RUN git clone --depth 1 --branch ${GIT_TAG} https://github.com/ndrscodes/openapi2jsonschema.git . \
    && python -m venv /opt/venv \
    && /opt/venv/bin/pip install --no-cache-dir -r requirements.txt .

FROM --platform=$BUILDPLATFORM python:3.14.7-alpine3.24@sha256:016508ba505da24f7139765bc4bb669df4e88eb2f12eeadd571bf2f88d7533df

COPY --from=builder /opt/venv /opt/venv

RUN addgroup -g 1000 appgroup \
    && adduser -u 1000 -G appgroup -D appgroup

ENV PATH="/opt/venv/bin:$PATH" \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

USER appuser
WORKDIR /home/appuser

ENTRYPOINT [ "openapi2jsonschema" ]