#!/usr/bin/env bash
set -euo pipefail

USERNAME="gt-ayush"
TARGET=${1:-all}
VERSION=${2:-v1.0.0}
IMAGE="ghcr.io/${USERNAME}/blackarch"

VARIANTS=("standard" "devel" "distroless")
ARCHS=("amd64" "arm64")

build_and_push_multiarch() {
  local variant=$1
  local manifest_rolling="${IMAGE}:${variant}"
  local manifest_versioned="${IMAGE}:${variant}-${VERSION}"

  echo "=== Creating multi-arch manifests for blackarch:${variant} (${VERSION}) ==="
  podman manifest rm "${manifest_rolling}" 2>/dev/null || true
  podman manifest rm "${manifest_versioned}" 2>/dev/null || true
  podman manifest create "${manifest_rolling}"
  podman manifest create "${manifest_versioned}"

  for arch in "${ARCHS[@]}"; do
    echo "--- Building ${variant} for linux/${arch} ---"
    podman build \
      --platform "linux/${arch}" \
      --manifest "${manifest_rolling}" \
      "./${variant}"

    # Tag the architecture-specific image into the versioned manifest as well
    local arch_digest
    arch_digest=$(podman manifest inspect "${manifest_rolling}" | grep -B 2 "\"architecture\": \"${arch}\"" | grep '"digest"' | awk -F'"' '{print $4}')
    podman manifest add "${manifest_versioned}" "${manifest_rolling}@${arch_digest}"
  done

  echo "=== Pushing multi-arch manifests for blackarch:${variant} to ghcr.io ==="
  podman manifest push --all "${manifest_rolling}" "docker://${manifest_rolling}"
  podman manifest push --all "${manifest_versioned}" "docker://${manifest_versioned}"

  # Also push 'standard' multi-arch manifests as ':latest' and ':${VERSION}'
  if [ "$variant" == "standard" ]; then
    podman manifest push --all "${manifest_rolling}" "docker://${IMAGE}:latest"
    podman manifest push --all "${manifest_versioned}" "docker://${IMAGE}:${VERSION}"
  fi
}

echo "=== 1. Committing and pushing code to GitHub ==="
git add .
git commit -m "Release BlackArch ${TARGET} ${VERSION}" || echo "No new code changes to commit"
git push origin main

if [ "$TARGET" == "all" ]; then
  for v in "${VARIANTS[@]}"; do
    build_and_push_multiarch "$v"
  done
else
  build_and_push_multiarch "$TARGET"
fi

echo "=== 2. Publishing GitHub Release ${VERSION} ==="
gh release create "${VERSION}" \
  --title "BlackArch Container Release ${VERSION}" \
  --notes "Published multi-arch (amd64/arm64) BlackArch variants (standard, devel, distroless) for ${VERSION}." || echo "Release ${VERSION} already exists"

echo "Done! All multi-arch BlackArch variants are live on ghcr.io."
