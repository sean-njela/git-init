#!/usr/bin/env python3
"""Validate normative specification front matter."""

from __future__ import annotations

import re
import sys
from pathlib import Path

REQUIRED_FIELDS = ("id", "title", "status", "version", "date", "commit")
FULL_SHA = re.compile(r"^[0-9a-f]{40}$")


def front_matter(path: Path) -> dict[str, str]:
    lines = path.read_text(encoding="utf-8").splitlines()
    if not lines or lines[0].strip() != "---":
        raise ValueError("missing YAML front matter")

    try:
        end = lines.index("---", 1)
    except ValueError as exc:
        raise ValueError("unterminated YAML front matter") from exc

    values: dict[str, str] = {}
    for line in lines[1:end]:
        if not line.strip() or line.lstrip().startswith("#"):
            continue
        key, separator, value = line.partition(":")
        if not separator:
            raise ValueError(f"invalid front matter line: {line}")
        values[key.strip()] = value.strip().strip('"')
    return values


def validate(spec_root: Path) -> list[str]:
    errors: list[str] = []
    files = sorted(spec_root.rglob("*.md"))
    if not files:
        return [f"no specification files found under {spec_root}"]

    for path in files:
        try:
            values = front_matter(path)
        except (OSError, UnicodeError, ValueError) as exc:
            errors.append(f"{path}: {exc}")
            continue

        for field in REQUIRED_FIELDS:
            if not values.get(field):
                errors.append(f"{path}: missing front matter field '{field}'")
        commit = values.get("commit", "")
        if not FULL_SHA.fullmatch(commit):
            errors.append(f"{path}: commit must be a full 40-character SHA")
    return errors


def main() -> int:
    root = Path(sys.argv[1]) if len(sys.argv) > 1 else Path.cwd()
    errors = validate(root / "spec")
    if errors:
        for error in errors:
            print(error, file=sys.stderr)
        return 1
    print(f"Validated specification provenance under {root / 'spec'}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
