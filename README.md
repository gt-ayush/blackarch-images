# BlackArch Linux Container Images for Podman & Docker

[![Auto-Sync BlackArch Release](https://github.com)](https://github.com)
[![GitHub Release](https://shields.io)](https://github.com)

Automated, minimal, and up-to-date **BlackArch Linux** container images based on Arch Linux. Available in **Standard**, **Devel**, and **Distroless** variants for **Podman** and **Docker**.

---

## 📦 Available Variants

| Variant | Registry Tag (`ghcr.io`) | Description & Included Tools |
| :--- | :--- | :--- |
| **Standard** | `ghcr.io/gt-ayush/blackarch:latest`<br>`ghcr.io/gt-ayush/blackarch:standard` | Minimal Arch Linux + `bash` + `pacman` pre-configured with the official BlackArch repository. Ideal for interactive shells and on-demand tool installation. |
| **Devel** | `ghcr.io/gt-ayush/blackarch:devel` | Built on `archlinux:base-devel` with `git`, `gcc`, `make`, `python`, and `python-pip` for compiling source code, AUR packages, or custom exploits. |
| **Distroless** | `ghcr.io/gt-ayush/blackarch:distroless` | Ultra-minimal, zero-shell, zero-package-manager runtime containing core libraries (`glibc`, `openssl`, `ca-certificates`) for hardened multi-stage images. |

---

## 🚀 Installation

### Method 1: Pull via Podman or Docker (Recommended)
```bash
podman pull ghcr.io/gt-ayush/blackarch:latest
podman pull ghcr.io/gt-ayush/blackarch:devel
podman pull ghcr.io/gt-ayush/blackarch:distroless
```
*(Replace `podman` with `docker` if applicable.)*

### Method 2: Offline Download via GitHub Releases
Download the `.tar.gz` archive for your variant from the [Releases](https://github.com) page and load it locally:
```bash
podman load -i blackarch-standard-vYYYY.MM.DD.tar.gz
```

---

## 🛠️ Usage Examples

1. **Interactive Shell (Standard / Devel):**
   ```bash
   podman run -it --rm ghcr.io/gt-ayush/blackarch:latest
   pacman -Sy nmap sqlmap ffuf gobuster
   ```

2. **Persistent Storage & Network Access:**
   ```bash
   podman run -it --rm --network=host -v \$(pwd)/workspace:/root/workspace:Z ghcr.io/gt-ayush/blackarch:latest
   ```

3. **Building Hardened Containers (Distroless):**
   Use the `distroless` variant as a final runtime stage in a multi-stage `Containerfile` to package compiled security tools with a minimal attack surface.

---

## 🔄 Automated Release Schedule & Disclaimer

* **Automation:** GitHub Actions checks the official [BlackArch Downloads](https://blackarch.org) page daily to rebuild and push fresh variants on new releases (`YYYY.MM.DD`).
* **Legal Disclaimer:** Strictly intended for **educational purposes, authorized penetration testing, and security research**.
