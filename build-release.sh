#!/usr/bin/env bash
set -e

USERNAME="<your-github-username>"
TARGET=${1:-all}
VERSION=${2:-v1.0.0}
IMAGE="ghcr.io/${USERNAME}/blackarch"

VARIANTS=("standard" "devel" "distroless")

build_and_push() {
  local variant=$1
  echo "=== Building blackarch:${variant} (${VERSION}) ==="
  podman build -t "${IMAGE}:${variant}" -t "${IMAGE}:${variant}-${VERSION}" "./${variant}"

  echo "=== Pushing blackarch:${variant} to ghcr.io ==="
  podman push "${IMAGE}:${variant}"
  podman push "${IMAGE}:${variant}-${VERSION}"

  # Also tag 'standard' as 'latest'
  if [ "$variant" == "standard" ]; then
    podman tag "${IMAGE}:${variant}" "${IMAGE}:latest"
    podman push "${IMAGE}:latest"
  fi
}

echo "=== 1. Committing and pushing code to GitHub ==="
git add .
git commit -m "Release BlackArch ${TARGET} ${VERSION}" || echo "No new code changes to commit"
git push origin main

if [ "$TARGET" == "all" ]; then
  for v in "${VARIANTS[@]}"; do
    build_and_push "$v"
  done
else
  build_and_push "$TARGET"
fi

echo "=== 2. Publishing GitHub Release ${VERSION} ==="
gh release create "${VERSION}" \
  --title "BlackArch Container Release ${VERSION}" \
  --notes "Published BlackArch variants (standard, devel, distroless) for ${VERSION}." || echo "Release ${VERSION} already exists"

echo "Done! All BlackArch variants are live on ghcr.io."
