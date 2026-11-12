# BlackArch Linux Container Images

[![Auto-Sync BlackArch Release](https://github.com/gt-ayush/blackarch-images/actions/workflows/auto-release.yml/badge.svg)](https://github.com/gt-ayush/blackarch-images/actions/workflows/auto-release.yml)
[![Latest GitHub Release](https://img.shields.io/github/v/release/gt-ayush/blackarch-images)](https://github.com/gt-ayush/blackarch-images/releases)
[![GHCR Package](https://img.shields.io/badge/GHCR-blackarch-blue?logo=docker)](https://ghcr.io/gt-ayush/blackarch)
[![License](https://shields.io)](https://opensource.org)

Lightweight, rootless-ready BlackArch Linux container images based on Arch Linux for Podman and Docker. Available in Standard, Devel, and Distroless variants on the [GitHub Container Registry](https://ghcr.io/gt-ayush/blackarch).

> **Use responsibly:** These images provide access to security and penetration-testing software. Use them only on systems and networks you own or have explicit permission to assess.

## Images & Usage

- **Standard (`:latest`, `:standard`)**: Arch Linux with BlackArch repository/keyring for interactive use and package installation.
- **Devel (`:devel`)**: Based on `base-devel` with compilation tools and Python packages.
- **Distroless (`:distroless`)**: Minimal runtime with no shell or package manager for multi-stage builds.

Pull images via Podman or Docker:
```bash
podman pull ghcr.io/gt-ayush/blackarch:latest
docker pull ghcr.io/gt-ayush/blackarch:latest
```

Run an interactive container or install packages:
```bash
podman run --rm -it ghcr.io/gt-ayush/blackarch:latest
pacman -Syu && pacman -S <package-name>
```

For offline archives, local builds, release schedules, troubleshooting tips (including `--security-opt seccomp=unconfined`), and full documentation, please refer to the complete repository files.

## License and Responsible Use

The build scripts and `Containerfile` definitions are licensed under the **Apache License 2.0**. Upstream packages retain their respective licenses.
