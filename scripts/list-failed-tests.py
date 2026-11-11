#!/usr/bin/env python3
"""Print failed XCTest cases from an xcresult JSON report."""

from __future__ import annotations

import json
import sys


def walk(nodes: list[dict] | None, failed: list[str]) -> None:
    for node in nodes or []:
        if node.get("nodeType") == "Test Case" and node.get("result") == "Failed":
            identifier = node.get("nodeIdentifier") or node.get("name") or "Unknown test"
            messages = [
                child.get("name", "").strip()
                for child in node.get("children") or []
                if child.get("nodeType") == "Failure Message" and child.get("name")
            ]
            if messages:
                failed.append(f"{identifier}\n  " + "\n  ".join(messages))
            else:
                failed.append(identifier)
        walk(node.get("children"), failed)


def main() -> int:
    data = json.load(sys.stdin)
    failed: list[str] = []
    walk(data.get("testNodes"), failed)
    if failed:
        sys.stdout.write("\n\n".join(failed) + "\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
