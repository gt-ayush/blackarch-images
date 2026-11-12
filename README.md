# BlackArch Linux Container Images

[![Auto-Sync BlackArch Release](https://github.com/gt-ayush/blackarch-images/actions/workflows/auto-release.yml/badge.svg)](https://github.com/gt-ayush/blackarch-images/actions/workflows/auto-release.yml)
[![Latest GitHub Release](https://img.shields.io/github/v/release/gt-ayush/blackarch-images?display_name=tag)](https://github.com/gt-ayush/blackarch-images/releases)
[![GHCR Package](https://img.shields.io/badge/GHCR-blackarch-blue?logo=docker)](https://ghcr.io/gt-ayush/blackarch)


Lightweight BlackArch Linux container images based on Arch Linux, for use with Podman and Docker. Choose a general-purpose image, a development image, or a minimal runtime image.

> **Use responsibly:** These images provide access to security and penetration-testing software. Use them only on systems and networks you own or have explicit permission to assess. You are responsible for complying with applicable laws and policies.

## Images

All images are published to the GitHub Container Registry:

[`ghcr.io/gt-ayush/blackarch`](https://ghcr.io/gt-ayush/blackarch)

| Variant | Image | Description |
| --- | --- | --- |
| Standard | `ghcr.io/gt-ayush/blackarch:latest` or `:standard` | Arch Linux with the BlackArch repository configured. Intended for interactive use and installing packages as needed. |
| Devel | `ghcr.io/gt-ayush/blackarch:devel` | Based on Arch Linux `base-devel`, with development tools and Python packages added. |
| Distroless | `ghcr.io/gt-ayush/blackarch:distroless` | Minimal `scratch`-based runtime containing selected libraries and certificates. It has no shell or package manager and is not intended for interactive use. |

When a new BlackArch release is detected, the workflow also publishes versioned tags, such as:

- `ghcr.io/gt-ayush/blackarch:standard-v2026.11.12`
- `ghcr.io/gt-ayush/blackarch:devel-v2026.11.12`
- `ghcr.io/gt-ayush/blackarch:distroless-v2026.11.12`
- `ghcr.io/gt-ayush/blackarch:v2026.11.12` — the Standard image

Check the [GHCR package page](https://ghcr.io/gt-ayush/blackarch) for the tags currently available.

## Pull an image

### Podman


```bash
podman pull ghcr.io/gt-ayush/blackarch:latest
podman pull ghcr.io/gt-ayush/blackarch:devel
podman pull ghcr.io/gt-ayush/blackarch:distroless
```

### Docker

```bash
docker pull ghcr.io/gt-ayush/blackarch:latest
docker pull ghcr.io/gt-ayush/blackarch:devel
docker pull ghcr.io/gt-ayush/blackarch:distroless
```

The images are public. If you get an authentication error, check the package visibility on GHCR and sign in to the registry if required.

## Use the images

### Start an interactive Standard container

```bash
podman run --rm -it ghcr.io/gt-ayush/blackarch:latest
```

The Standard and Devel images start Bash. Containers are ephemeral: files written inside a container are lost when it is removed unless you use a volume or copy the files out.

### Install packages

Refresh and upgrade the system before installing packages. Arch Linux is a rolling release, so avoid refreshing package databases without upgrading the installed system.

```bash
podman run --rm -it ghcr.io/gt-ayush/blackarch:latest

```

Then, inside the container:

```bash
pacman -Syu
pacman -S <package-name>
```

For a one-off command, pass it to the container:

```bash
podman run --rm ghcr.io/gt-ayush/blackarch:latest \
  pacman -Syu --noconfirm <package-name>
```

Replace `<package-name>` with a package available from the enabled repositories. Review package details and signatures before installing software.

### Keep work in a host directory

Mount a local directory to preserve files after the container exits:

```bash
mkdir -p workspace
podman run --rm -it \
  -v "$PWD/workspace:/root/workspace:Z" \
  ghcr.io/gt-ayush/blackarch:latest
```

The `:Z` option is useful on SELinux-enabled systems with Podman. For Docker or systems without SELinux, omit it if it is not supported.

### Use the Devel image

The Devel image is intended for compilation and development workflows:

```bash
podman run --rm -it \
  -v "$PWD/workspace:/root/workspace:Z" \
  ghcr.io/gt-ayush/blackarch:devel
```

### Use the Distroless image

The Distroless image has no shell or package manager. Use it as a final stage in a multi-stage build, copying in the application and any required runtime files:

```dockerfile
FROM docker.io/library/archlinux:base-devel AS builder

# Install build dependencies and build your application here.
WORKDIR /src
COPY . .
RUN make

FROM ghcr.io/gt-ayush/blackarch:distroless
COPY --from=builder /src/your-application /usr/local/bin/your-application
ENTRYPOINT ["/usr/local/bin/your-application"]
```

Adjust the build and copy steps to match your application. Ensure the application’s required shared libraries and runtime data are available in the final image. The Distroless image is not a general-purpose BlackArch environment and does not include a shell or the full set of BlackArch tools.

## Offline image archives

If the workflow successfully publishes a GitHub Release with image archives, download the desired `.tar.gz` file from the [Releases page](https://github.com/gt-ayush/blackarch-images/releases).

Load an archive with Podman:

```bash
podman load -i blackarch-standard-v2026.11.12.tar.gz
```

Or with Docker:

```bash
docker load -i blackarch-standard-v2026.11.12.tar.gz
```

The registry is the primary distribution method. Release archives are optional and may not be available for every build.

## Release and update schedule

The GitHub Actions workflow checks the BlackArch website once per day.

- On a scheduled run, it normally rebuilds and updates the rolling tags (`latest`, `standard`, `devel`, and `distroless`) on Sunday.
- When it detects a version without a corresponding GitHub Release, it builds versioned image tags and attempts to create a GitHub Release with downloadable image archives.
- A manually dispatched workflow run also triggers a build.

The schedule controls when this repository checks for updates; it does not guarantee that BlackArch publishes a new ISO or that every build will succeed. See [Actions](https://github.com/gt-ayush/blackarch-images/actions) for the latest run status.

## Build locally

Clone the repository and build a variant using Docker or Podman:

```bash
git clone https://github.com/gt-ayush/blackarch-images.git
cd blackarch-images

podman build -f standard/Containerfile -t blackarch:standard ./standard
podman build -f devel/Containerfile -t blackarch:devel ./devel
podman build -f distroless/Containerfile -t blackarch:distroless ./distroless
```

Replace `podman` with `docker` to build with Docker.

## Troubleshooting

### Package database or signature errors

The image build configures BlackArch using the upstream setup process. If package synchronization or signature verification fails, check the GitHub Actions log and retry after confirming the upstream BlackArch repository and keyring are available. Do not disable package signature verification to work around a trust error.

### Cannot run a shell in the Distroless image

That is expected. The Distroless image is a minimal runtime image, not an interactive environment. Use the Standard or Devel image when you need a shell or package manager.

### Image tag is missing

Versioned tags are created only when the workflow detects a new BlackArch version. Use the rolling tags (`latest`, `standard`, `devel`, or `distroless`) or check the [GHCR package page](https://ghcr.io/gt-ayush/blackarch) for published tags.

## License and Responsible Use

The build scripts and `Containerfile` definitions are licensed under the **Apache License 2.0**. Upstream packages retain their respective licenses.
