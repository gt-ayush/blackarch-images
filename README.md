# BlackArch Linux Container Images for Podman

Maintained BlackArch Linux container images available in multiple variants for Podman and Docker.

## Available Tags

| Variant | Pull Command | Description |
| :--- | :--- | :--- |
| **Standard** | `podman pull ghcr.io/gt-ayush/blackarch:latest` | Interactive Arch + `pacman` + BlackArch repo. |
| **Devel** | `podman pull ghcr.io/gt-ayush/blackarch:devel` | Includes `base-devel`, `git`, `gcc`, and `python-pip` for building tools. |
| **Distroless** | `podman pull ghcr.io/gt-ayush/blackarch:distroless` | Zero-shell, zero-pacman minimal runtime base (`glibc`, `openssl`). |

## Quick Start

Start an interactive BlackArch container:
```bash
podman run -it --rm ghcr.io/gt-ayush/blackarch:latest
```

Use the distroless variant as a base in your own `Containerfile`:
```dockerfile
FROM ghcr.io/gt-ayush/blackarch:distroless
COPY ./my-compiled-tool /usr/bin/my-tool
ENTRYPOINT ["/usr/bin/my-tool"]
```
