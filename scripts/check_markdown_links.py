#!/usr/bin/env python3
"""Validate local and external links in Markdown files."""

from __future__ import annotations

import argparse
import re
from pathlib import Path
from urllib.parse import urlparse

LINK_PATTERN = re.compile(r"(!)?\[(?P<label>[^\]]*)\]\((?P<target>[^)\s]+)(?:\s+\"[^\"]*\")?\)")
IGNORED_SCHEMES = {"mailto", "tel"}


def iter_markdown_files(base_dir: Path) -> list[Path]:
    return sorted(path for path in base_dir.rglob("*.md") if path.is_file())


def normalize_target(target: str) -> str:
    return target.split("#", 1)[0].strip()


def is_external(target: str) -> bool:
    parsed = urlparse(target)
    return parsed.scheme in {"http", "https"}


def check_local_target(file_path: Path, target: str, docs_root: Path) -> str | None:
    normalized = normalize_target(target)
    if not normalized:
        return None

    parsed = urlparse(normalized)
    if parsed.scheme in IGNORED_SCHEMES:
        return None
    if parsed.scheme:
        return None

    if normalized.startswith("/"):
        candidate = docs_root / normalized.lstrip("/")
    else:
        candidate = (file_path.parent / normalized).resolve()

    if candidate.exists():
        return None

    # Markdown links can omit the .md extension.
    md_candidate = candidate.with_suffix(".md")
    if md_candidate.exists():
        return None

    index_candidate = candidate / "index.md"
    if index_candidate.exists():
        return None

    return f"Lien local introuvable: '{target}'"


def check_external_target(target: str, timeout: int) -> str | None:
    try:
        import requests
    except ModuleNotFoundError:
        return (
            "Verification externe impossible: module 'requests' absent. "
            "Installez les dependances avec `pip install -r requirements.txt`."
        )

    try:
        response = requests.head(target, allow_redirects=True, timeout=timeout)
        if response.status_code >= 400:
            response = requests.get(target, allow_redirects=True, timeout=timeout)
        if response.status_code >= 400:
            return f"Lien externe en erreur ({response.status_code}): '{target}'"
    except requests.RequestException as exc:
        return f"Lien externe inaccessible: '{target}' ({exc})"
    return None


def run(base_dir: Path, check_external: bool, timeout: int) -> int:
    docs_root = base_dir.resolve()
    errors: list[str] = []
    markdown_files = iter_markdown_files(base_dir)

    for md_file in markdown_files:
        content = md_file.read_text(encoding="utf-8")
        for match in LINK_PATTERN.finditer(content):
            target = match.group("target").strip()

            if is_external(target):
                if check_external:
                    error = check_external_target(target, timeout)
                    if error:
                        errors.append(f"{md_file}: {error}")
                continue

            error = check_local_target(md_file, target, docs_root)
            if error:
                errors.append(f"{md_file}: {error}")

    if errors:
        print("Erreurs de liens detectees:")
        for error in errors:
            print(f"- {error}")
        return 1

    print("Verification des liens Markdown: OK")
    return 0


def main() -> int:
    parser = argparse.ArgumentParser(description="Validate markdown links.")
    parser.add_argument(
        "--docs-dir",
        default="docs",
        help="Markdown root directory (default: docs)",
    )
    parser.add_argument(
        "--check-external",
        action="store_true",
        help="Also validate external links (http/https).",
    )
    parser.add_argument(
        "--timeout",
        type=int,
        default=10,
        help="HTTP timeout in seconds for external links.",
    )
    args = parser.parse_args()

    return run(Path(args.docs_dir), args.check_external, args.timeout)


if __name__ == "__main__":
    raise SystemExit(main())
