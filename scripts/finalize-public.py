#!/usr/bin/env python3
"""Finalize the public/ tree after the four Zensical builds."""

from __future__ import annotations

import json
import shutil
from pathlib import Path


PUBLIC = Path("public")

VERSIONS = [
    {"version": "5.0", "title": "5.0", "aliases": ["dev"]},
    {"version": "4.4", "title": "4.4", "aliases": ["latest"]},
]

ALIASES = {
    PUBLIC / "fr" / "latest": PUBLIC / "fr" / "4.4",
    PUBLIC / "fr" / "dev": PUBLIC / "fr" / "5.0",
    PUBLIC / "en" / "latest": PUBLIC / "en" / "4.4",
    PUBLIC / "en" / "dev": PUBLIC / "en" / "5.0",
}


def redirect_html(target: str, title: str = "Redirecting") -> str:
    return "\n".join(
        [
            "<!DOCTYPE html>",
            '<html lang="fr">',
            "<head>",
            '  <meta charset="utf-8">',
            f"  <title>{title}</title>",
            "  <noscript>",
            f'    <meta http-equiv="refresh" content="1; url={target}" />',
            "  </noscript>",
            "  <script>",
            f'    window.location.replace("{target}" + window.location.search + window.location.hash);',
            "  </script>",
            "</head>",
            "<body>",
            f'  Redirecting to <a href="{target}">{target}</a>...',
            "</body>",
            "</html>",
            "",
        ]
    )


def copy_aliases() -> None:
    for alias, source in ALIASES.items():
        if not source.is_dir():
            print(f"Skipping alias {alias}: missing source directory {source}")
            continue
        if alias.exists():
            shutil.rmtree(alias)
        shutil.copytree(source, alias)


def write_versions() -> None:
    for lang in ("fr", "en"):
        lang_dir = PUBLIC / lang
        lang_dir.mkdir(parents=True, exist_ok=True)
        (lang_dir / "versions.json").write_text(
            json.dumps(VERSIONS, indent=2, ensure_ascii=False) + "\n",
            encoding="utf-8",
        )


def write_indexes() -> None:
    PUBLIC.mkdir(parents=True, exist_ok=True)
    (PUBLIC / "index.html").write_text(redirect_html("fr/latest/"), encoding="utf-8")
    (PUBLIC / "fr" / "index.html").write_text(redirect_html("latest/"), encoding="utf-8")
    (PUBLIC / "en" / "index.html").write_text(redirect_html("latest/"), encoding="utf-8")


def main() -> None:
    copy_aliases()
    write_versions()
    write_indexes()


if __name__ == "__main__":
    main()
