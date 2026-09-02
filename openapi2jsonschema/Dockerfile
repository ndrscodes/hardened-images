FROM --platform=$BUILDPLATFORM python:3.14.7-alpine3.24@sha256:c6ead215bfd31f1e433d968853b7a769989117115b728874824e6c0a27cb96fc AS builder

ARG GIT_TAG

RUN apk add --no-cache git

WORKDIR /build

RUN git clone --depth 1 --branch ${GIT_TAG} https://github.com/ndrscodes/openapi2jsonschema.git . \
    && python -m venv /opt/venv \
    && /opt/venv/bin/pip install --no-cache-dir -r requirements.txt .

FROM --platform=$BUILDPLATFORM python:3.14.7-alpine3.24@sha256:c6ead215bfd31f1e433d968853b7a769989117115b728874824e6c0a27cb96fc

COPY --from=builder /opt/venv /opt/venv

RUN addgroup -g 1000 appgroup \
    && adduser -u 1000 -G appgroup -D appgroup

ENV PATH="/opt/venv/bin:$PATH" \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

USER appuser
WORKDIR /home/appuser

ENTRYPOINT [ "openapi2jsonschema" ]