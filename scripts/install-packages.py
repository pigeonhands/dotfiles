#!/usr/bin/env python3
import argparse
import os
import subprocess
import sys
from pathlib import Path
from typing import List, Optional
from dataclasses import dataclass

import yaml

REPO_ROOT = Path(__file__).resolve().parent.parent
PACKAGES_FILE = REPO_ROOT / "packages.yaml"

_COLOR = sys.stdout.isatty() and "NO_COLOR" not in os.environ


def _c(code):
    return f"\033[{code}m" if _COLOR else ""



RESET = _c(0)
BOLD = _c(1)
DIM = _c(2)
RED = _c(31)
GREEN = _c(32)
YELLOW = _c(33)
CYAN = _c(36)

@dataclass()
class Package:
    distro: str
    package_name: str
    post_install: Optional[str]
    package_manager: Optional[str]



def log_step(msg):
    print(f"{BOLD}{GREEN}::{RESET} {BOLD}{msg}{RESET}")


def log_info(msg):
    print(f"{CYAN}  ->{RESET} {msg}")


def log_skip(msg):
    print(f"{DIM}  -- {msg} (skipping){RESET}")


def log_error(msg):
    print(f"{RED}{BOLD}!!{RESET} {msg}", file=sys.stderr)


def detect_distro():
    os_release = {}
    try:
        with open("/etc/os-release") as f:
            for line in f:
                key, sep, val = line.strip().partition("=")
                if sep:
                    os_release[key] = val.strip('"')
    except FileNotFoundError:
        pass
    return os_release.get("ID_LIKE") or os_release.get("ID") or ""


def install_arch_package(package: Package):
    manager = package.package_manager or "pacman"
    name = package.package_name

    check = subprocess.run(
        [manager, "-Q", name], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
    )
    if check.returncode == 0:
        log_skip(f"({manager}) {name} is already installed")
        return
    log_info(f"({manager}) installing {name}...")
    subprocess.run(["sudo", manager, "-S", "--noconfirm", name], check=True)


def run_post_install(script):
    if not script:
        return
    log_info("running post_install")
    print(f"{DIM}{script.rstrip()}{RESET}")
    subprocess.run(script, shell=True, executable="/bin/bash", check=True)



def install_packages(packages: List[Package], distro: str):
    installers = {
        "arch": install_arch_package
    }

    os_installer = installers.get(distro)
    if not os_installer:
        log_error(f"unsupported os: {distro}")
        sys.exit(1)

    for package in packages:
        os_installer(package)
        if package.post_install:
            run_post_install(package.post_install)

        print()


def read_packages(packages_file: Path, distro: str) -> List[Package]:
    with open(packages_file) as f:
        data = yaml.safe_load(f) or {}

    packages = []
    for pkg in data.get("packages", []):
        post_install = pkg.get("post_install")
        for key, val in pkg.items():
            if key == "post_install":
                continue
            if key == distro and val:
                package_name = val
                manager = None

                if ":" in package_name:
                    manager, package_name = package_name.split(":", 1)

                packages.append(Package(
                    distro=distro,
                    package_name=package_name,
                    post_install=post_install,
                    package_manager=manager
                ))


    return packages

def main():
    parser = argparse.ArgumentParser(description="Install packages from packages.yaml")
    parser.add_argument("--distro", help="distro to install packages for (defaults to the host's)")
    args = parser.parse_args()

    distro = args.distro or detect_distro()
    log_step(f"target distro: {distro}")
    print()

    packages = read_packages(PACKAGES_FILE, distro)
    install_packages(packages, distro)



if __name__ == "__main__":
    main()
