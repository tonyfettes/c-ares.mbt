#!/usr/bin/env python3

import sys
import json
import urllib.request
from pathlib import Path
import subprocess
import platform
import tarfile
import logging
import argparse
import os
import shutil
import tempfile

logger = logging.getLogger(__file__)
logging.basicConfig(level=logging.INFO)


def run_with_logging(
    cmd: str | list[str],
    cwd: str | bytes | Path,
    log_dir,
    log_prefix: str,
    env: dict[str, str] | None = None,
):
    """Run subprocess with stdout/stderr redirected to log files."""
    stdout_path = log_dir / f"{log_prefix}.stdout"
    stderr_path = log_dir / f"{log_prefix}.stderr"

    with open(stdout_path, "w") as stdout_file, open(stderr_path, "w") as stderr_file:
        return subprocess.run(
            cmd,
            cwd=cwd,
            check=True,
            stdout=stdout_file,
            stderr=stderr_file,
            env=env,
        )


GPG_KEYS = [
    "27EDEAF22F3ABCEB50DB9A125CC908FDB71E12C2",
    "DA7D64E4C82C6294CB73A20E22E3D13B5411B7CA",
]


def verify_cares(version: str):
    """Verify c-ares installation."""
    Path("vendor/src").mkdir(parents=True, exist_ok=True)
    url = f"https://github.com/c-ares/c-ares/releases/download/v{version}/c-ares-{version}.tar.gz.asc"
    tar_gz_asc = Path(f"vendor/src/c-ares-{version}.tar.gz.asc")
    if tar_gz_asc.exists():
        if tar_gz_asc.is_file():
            tar_gz_asc.unlink()
        else:
            shutil.rmtree(tar_gz_asc)
    urllib.request.urlretrieve(url, tar_gz_asc)
    tar_gz = Path(f"vendor/src/c-ares-{version}.tar.gz")
    if not tar_gz.exists():
        return False
    if not tar_gz.is_file():
        return False
    with tempfile.TemporaryDirectory() as tmpdir:
        try:
            for key in GPG_KEYS:
                run_with_logging(
                    ["gpg", "--keyserver", "keyserver.ubuntu.com", " --recv-keys", key],
                    log_dir=Path("vendor/log/cares"),
                    log_prefix="gpg-keyserver",
                    env={"GNUPGHOME": str(Path(tmpdir) / "gnupg")},
                )
            run_with_logging(
                ["gpg", "--verify", str(tar_gz_asc), str(tar_gz)],
                cwd=tmpdir,
                log_dir=Path("vendor/log/cares"),
                log_prefix="gpg-verify",
            )
            return True
        except subprocess.CalledProcessError:
            return False


def download_cares(version: str):
    """Download c-ares source code."""
    url = f"https://github.com/c-ares/c-ares/releases/download/v{version}/c-ares-{version}.tar.gz"
    dest = Path(f"vendor/src/c-ares-{version}.tar.gz")
    if dest.exists():
        if dest.is_file():
            dest.unlink()
        else:
            shutil.rmtree(dest)
    dest.parent.mkdir(parents=True, exist_ok=True)
    urllib.request.urlretrieve(url, dest)
    logger.info(f"Downloaded c-ares {version} to {dest}")


def extract_cares(version: str):
    """Extract c-ares source code."""
    tar_path = Path(f"vendor/src/c-ares-{version}.tar.gz")
    if not tar_path.exists():
        raise FileNotFoundError(f"c-ares tarball {tar_path} does not exist.")

    with tarfile.open(tar_path, "r:gz") as tar:
        tar.extractall(path="vendor/src")


def build_cares(version: str):
    """Build c-ares from source."""
    cares_path = Path(f"vendor/src/c-ares-{version}")
    if not cares_path.exists():
        raise FileNotFoundError(f"c-ares source directory {cares_path} does not exist.")

    log_dir = Path("vendor/log/c-ares")
    log_dir.mkdir(parents=True, exist_ok=True)

    # mkdir build
    build_dir = cares_path / "build"
    build_dir.mkdir(parents=True, exist_ok=True)

    if platform.system() == "Windows":
        run_with_logging(
            [
                "cmake",
                "-DCMAKE_BUILD_TYPE=Release",
                "-DCMAKE_INSTALL_PREFIX=" + str(Path("vendor").resolve()),
                "-DCARES_STATIC=ON",
                "-G",
                "NMake Makefiles",
                "..",
            ],
            cwd=build_dir,
            log_dir=log_dir,
            log_prefix="configure",
        )
    else:
        run_with_logging(
            [
                "cmake",
                "-DCMAKE_BUILD_TYPE=Release",
                "-DCMAKE_INSTALL_PREFIX=" + str(Path("vendor").resolve()),
                "-DCARES_STATIC=ON",
                "-G",
                "Ninja",
                "..",
            ],
            cwd=build_dir,
            log_dir=log_dir,
            log_prefix="configure",
        )

    logger.info("Building c-ares...")
    if platform.system() == "Windows":
        run_with_logging(
            ["nmake"],
            cwd=build_dir,
            log_dir=log_dir,
            log_prefix="build",
        )
    else:
        cpu_count = os.cpu_count() or 4
        run_with_logging(
            ["ninja"],
            cwd=build_dir,
            log_dir=log_dir,
            log_prefix="build",
        )

    logger.info("Installing c-ares...")
    if platform.system() == "Windows":
        run_with_logging(
            ["nmake", "install"],
            cwd=build_dir,
            log_dir=log_dir,
            log_prefix="install",
        )
    else:
        run_with_logging(
            ["ninja", "install"],
            cwd=build_dir,
            log_dir=log_dir,
            log_prefix="install",
        )


def cares_is_built():
    if platform.system() == "Windows":
        return Path("vendor/lib/libcares.lib").exists()
    elif platform.system() == "Linux":
        return Path("vendor/lib64/libcares.a").exists()
    elif platform.system() == "Darwin":
        return Path("vendor/lib/libcares.a").exists()
    else:
        raise NotImplementedError(f"Unsupported platform: {platform.system()}")


def main():
    parser = argparse.ArgumentParser(description="Build c-ares for MoonBit")
    parser.add_argument(
        "--manual",
        action="store_true",
        help="Run the build script manually without reading from stdin",
    )
    args = parser.parse_args()
    env = os.environ.copy()
    if args.manual is False:
        """Simple cat that reads from stdin and saves content to build.input"""
        text = sys.stdin.read()
        data = json.loads(text)
        env = data
    moon_home = None
    if "MOON_HOME" in env:
        moon_home = env["MOON_HOME"]
    else:
        moon_home = Path.home() / ".moon"
    moon_home = Path(moon_home)
    if not moon_home.exists():
        raise FileNotFoundError(f"MOON_HOME directory {moon_home} does not exist.")
    vendor = Path("vendor")
    version = "1.34.5"
    if not cares_is_built():
        if not verify_cares(version=version):
            logger.warning(
                "Failed to verify the integrity of c-ares, re-downloading..."
            )
            download_cares(version=version)
        logger.info("c-ares is not built, extracting and building...")
        extract_cares(version=version)
        build_cares(version=version)
    link_flags = []
    link_libs = []
    link_search_paths = []
    if platform.system() == "Windows":
        link_libs.append(str((vendor / "lib").resolve() / "libcares"))
    elif platform.system() == "Darwin":
        link_libs.append("cares")
        link_search_paths.append(str((vendor / "lib").resolve()))
    elif platform.system() == "Linux":
        link_libs.append("cares")
        link_search_paths.append(str((vendor / "lib64").resolve()))
    else:
        raise NotImplementedError(f"Unsupported platform: {platform.system()}")
    cc = None
    if "CC" in env:
        cc = env["CC"]
    else:
        if platform.system() == "Windows":
            cc = "cl"
        elif platform.system() == "Darwin":
            cc = "clang"
        else:
            cc = "gcc"
    cc_flags = []
    include_directory = Path("vendor/include").resolve()
    if platform.system() == "Windows":
        cc_flags.append(f"/I{include_directory}")
    else:
        cc_flags.append(f"-I{include_directory}")
    output = json.dumps(
        {
            "vars": {
                "CC": cc,
                "CC_FLAGS": " ".join(cc_flags),
            },
            "link_configs": [
                {
                    "package": "tonyfettes/cares",
                    "link_flags": " ".join(link_flags),
                    "link_libs": link_libs,
                    "link_search_paths": link_search_paths,
                }
            ],
        }
    )
    sys.stdout.write(output)


if __name__ == "__main__":
    main()
