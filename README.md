# Hardened Images

A small collection of hardened Docker images for infrastructure and developer tooling. The goal of this project is to package trusted upstream binaries in minimal, non-root images that are easy to consume in CI/CD pipelines and Kubernetes workflows.

This repository is intentionally kept current: images are automatically refreshed via Dependabot and GitHub Actions so the latest upstream tool versions and base images can be picked up continuously.

## What is included

The repository currently contains:

- kubeconform
  - Source directory: `kubeconform/`
  - Hardened runtime image built on Alpine
  - Runs as a non-root user and includes CA certificates
- openapi2jsonschema
  - Source directory: `openapi2jsonschema/`
  - Based on python-alpine
  - Runs as a non-root user
  - Based on a [custom fork](https://github.com/ndrscodes/openapi2jsonschema/) of openapi2jsonschema with up-to-date python dependencies

## Where the images are published

Images are published to GitHub Container Registry (GHCR):

- GHCR image name: `ghcr.io/ndrscodes/hardened-images/<image>`
- GHCR package page: https://github.com/ndrscodes/hardened-images/pkgs/container/hardened-images

Examples:

```bash
docker pull ghcr.io/ndrscodes/hardened-images/kubeconform:latest

docker run --rm \
  -v "$PWD:/work" \
  -w /work \
  ghcr.io/ndrscodes/hardened-images/kubeconform:latest \
  -summary -strict -kubernetes-version 1.30.0 ./manifests
```

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
