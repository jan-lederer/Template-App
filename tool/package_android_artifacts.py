#!/usr/bin/env python3
"""Copy Android builds into named, checksummed files for download."""

from __future__ import annotations

import hashlib
import re
import shutil
import zipfile
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
VERSION_FILE = ROOT / "pubspec.yaml"
APK_SOURCE = ROOT / "build/app/outputs/flutter-apk/app-debug.apk"
AAB_SOURCE = ROOT / "build/app/outputs/bundle/release/app-release.aab"
OUTPUT = ROOT / "build/deliverables"


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as source:
        for block in iter(lambda: source.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def main() -> None:
    version_match = re.search(
        r"(?m)^version:\s*([0-9A-Za-z.+-]+)\s*$", VERSION_FILE.read_text()
    )
    if not version_match:
        raise SystemExit(f"Could not read version from {VERSION_FILE}")
    if not APK_SOURCE.is_file() or not AAB_SOURCE.is_file():
        raise SystemExit("Build the debug APK and release AAB before packaging them.")

    version = version_match.group(1)
    apk_name = f"template-app-{version}-arm64-debug.apk"
    bundle_name = f"template-app-{version}-release-aab.zip"
    aab_name = f"template-app-{version}-release.aab"
    OUTPUT.mkdir(parents=True, exist_ok=True)

    apk = OUTPUT / apk_name
    bundle = OUTPUT / bundle_name
    shutil.copy2(APK_SOURCE, apk)

    aab_digest = sha256(AAB_SOURCE)
    with zipfile.ZipFile(bundle, "w", compression=zipfile.ZIP_DEFLATED) as archive:
        archive.write(AAB_SOURCE, aab_name)
        archive.writestr(
            "AAB-SHA256SUMS.txt", f"{aab_digest}  {aab_name}\n"
        )

    with zipfile.ZipFile(bundle) as archive:
        damaged_file = archive.testzip()
        if damaged_file:
            raise SystemExit(f"Corrupt file in release bundle ZIP: {damaged_file}")

    sums = OUTPUT / "SHA256SUMS.txt"
    sums.write_text(
        f"{sha256(apk)}  {apk.name}\n{sha256(bundle)}  {bundle.name}\n"
    )
    print(f"APK: {apk} ({apk.stat().st_size:,} bytes)")
    print(f"AAB ZIP: {bundle} ({bundle.stat().st_size:,} bytes)")
    print(f"Download checksums: {sums}")


if __name__ == "__main__":
    main()
