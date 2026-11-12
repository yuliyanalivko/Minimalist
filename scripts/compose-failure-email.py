#!/usr/bin/env python3
"""Compose a plain-text and HTML failure email from a failed-tests report."""

from __future__ import annotations

import argparse
import html
from pathlib import Path


def parse_failed_tests(text: str) -> list[dict[str, object]]:
    blocks = [block.strip() for block in text.strip().split("\n\n") if block.strip()]
    tests: list[dict[str, object]] = []
    for block in blocks:
        lines = block.splitlines()
        name = lines[0].strip()
        messages = [line.strip() for line in lines[1:] if line.strip()]
        tests.append({"name": name, "messages": messages})
    return tests


def render_plain(args: argparse.Namespace, tests: list[dict[str, object]]) -> str:
    lines = [
        f"Hello {args.author_name},",
        "",
        f"{len(tests)} unit test{'s' if len(tests) != 1 else ''} failed in {args.repository}.",
        "",
        f"Branch: {args.branch}",
        f"Commit: {args.commit}",
        f"Workflow run: {args.run_url}",
        "",
        "Failed tests:",
    ]
    for test in tests:
        lines.append("")
        lines.append(str(test["name"]))
        for message in test["messages"]:
            lines.append(f"  {message}")
    lines.append("")
    return "\n".join(lines)


def test_card(test: dict[str, object]) -> str:
    name = html.escape(str(test["name"]))
    messages = test["messages"]
    if messages:
        message_html = "".join(
            f"""
            <tr>
              <td style="padding: 0 0 8px 0; font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace; font-size: 13px; line-height: 20px; color: #7A2E0E;">
                {html.escape(str(message))}
              </td>
            </tr>
            """
            for message in messages
        )
        details = f"""
        <table role="presentation" cellpadding="0" cellspacing="0" border="0" width="100%" style="background-color: #FBF4EE; border-radius: 10px;">
          <tr>
            <td style="padding: 12px 14px;">
              <table role="presentation" cellpadding="0" cellspacing="0" border="0" width="100%">
                {message_html}
              </table>
            </td>
          </tr>
        </table>
        """
    else:
        details = """
        <p style="margin: 0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif; font-size: 14px; line-height: 20px; color: #78716C;">
          No assertion message was recorded for this test.
        </p>
        """

    return f"""
    <tr>
      <td style="padding: 0 0 14px 0;">
        <table role="presentation" cellpadding="0" cellspacing="0" border="0" width="100%" style="border: 1px solid #E8E0D8; border-radius: 16px; background-color: #FFFFFF;">
          <tr>
            <td style="padding: 16px 18px 14px 18px; border-left: 4px solid #FF3B30;">
              <p style="margin: 0 0 10px 0; font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace; font-size: 14px; line-height: 22px; color: #1C1917;">
                {name}
              </p>
              {details}
            </td>
          </tr>
        </table>
      </td>
    </tr>
    """


def render_html(args: argparse.Namespace, tests: list[dict[str, object]]) -> str:
    count = len(tests)
    count_label = "1 test failed" if count == 1 else f"{count} tests failed"
    short_sha = args.commit[:7] if args.commit else "unknown"
    greeting_name = html.escape(args.author_name or "there")
    repository = html.escape(args.repository)
    branch = html.escape(args.branch)
    run_url = html.escape(args.run_url, quote=True)
    commit_url = html.escape(args.commit_url or args.run_url, quote=True)
    cards = "\n".join(test_card(test) for test in tests)

    return f"""<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Unit tests failed</title>
</head>
<body style="margin: 0; padding: 0;">
  <div style="display: none; max-height: 0; overflow: hidden; opacity: 0;">
    {html.escape(count_label)} in {repository} on {branch}.
  </div>
  <table role="presentation" cellpadding="0" cellspacing="0" border="0" width="100%">
    <tr>
      <td align="center" style="padding: 36px 16px;">
        <table role="presentation" cellpadding="0" cellspacing="0" border="0" width="100%" style="max-width: 600px;">
          <tr>
            <td style="padding: 0 8px 20px 8px;">
              <p style="margin: 0; font-family: sans-serif; font-size: 20px; letter-spacing: 0.12em; text-transform: uppercase; color: #1C1917;">
                Minimalist
              </p>
            </td>
          </tr>
          <tr>
            <td>
              <table role="presentation" cellpadding="0" cellspacing="0" border="0" width="100%" style="background-color: #FFFFFF; border-radius: 10px; overflow: hidden; box-shadow: 0 18px 40px rgba(28, 25, 23, 0.08);">
                <tr>
                  <td style="background-color: #A2BD80; padding: 28px 32px 24px 32px;">
                    <p style="margin: 0 0 8px 0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif; font-size: 12px; letter-spacing: 0.16em; text-transform: uppercase; color: #FFFFFF;">
                      CI notification
                    </p>
                    <h1 style="margin: 0; font-family: sans-serif; font-size: 32px; line-height: 38px; font-weight: normal; color: #FFFFFF;">
                      Unit tests failed
                    </h1>
                    <p style="margin: 12px 0 0 0; font-family: sans-serif; font-size: 16px; line-height: 24px; color: #FFFFFF;">
                      {html.escape(count_label)} in {repository}
                    </p>
                  </td>
                </tr>
                <tr>
                  <td style="padding: 28px 32px 8px 32px;">
                    <p style="margin: 0 0 20px 0; font-family: sans-serif; font-size: 16px; line-height: 26px; color: #44403C;">
                      Hello {greeting_name}, a commit you authored did not pass unit tests. The failing cases are listed below.
                    </p>
                    <table role="presentation" cellpadding="0" cellspacing="0" border="0" width="100%" style="background-color: #F9F9F9; border-radius: 10px;">
                      <tr>
                        <td style="padding: 16px 18px;">
                          <table role="presentation" cellpadding="0" cellspacing="0" border="0" width="100%">
                            <tr>
                              <td width="33%" style="padding: 6px 8px; vertical-align: top;">
                                <p style="margin: 0 0 4px 0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif; font-size: 11px; letter-spacing: 0.12em; text-transform: uppercase; color: #A8A29A;">Branch</p>
                                <p style="margin: 0; font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace; font-size: 13px; color: #1C1917;">{branch}</p>
                              </td>
                              <td width="33%" style="padding: 6px 8px; vertical-align: top;">
                                <p style="margin: 0 0 4px 0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif; font-size: 11px; letter-spacing: 0.12em; text-transform: uppercase; color: #A8A29A;">Commit</p>
                                <p style="margin: 0; font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace; font-size: 13px;">
                                  <a href="{commit_url}" style="color: #1C1917; text-decoration: none;">{html.escape(short_sha)}</a>
                                </p>
                              </td>
                              <td width="33%" style="padding: 6px 8px; vertical-align: top;">
                                <p style="margin: 0 0 4px 0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif; font-size: 11px; letter-spacing: 0.12em; text-transform: uppercase; color: #A8A29A;">Failed</p>
                                <p style="margin: 0; font-family: Georgia, 'Times New Roman', serif; font-size: 18px; color: #FF3B30;">{count}</p>
                              </td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr>
                  <td style="padding: 24px 32px 8px 32px;">
                    <p style="margin: 0 0 14px 0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif; font-size: 12px; letter-spacing: 0.14em; text-transform: uppercase; color: #A8A29A;">
                      Failed tests
                    </p>
                    <table role="presentation" cellpadding="0" cellspacing="0" border="0" width="100%">
                      {cards}
                    </table>
                  </td>
                </tr>
                <tr>
                  <td style="padding: 8px 32px 32px 32px;">
                    <table role="presentation" cellpadding="0" cellspacing="0" border="0">
                      <tr>
                        <td style="border-radius: 10px; background-color: #A2BD80;">
                          <a href="{run_url}" style="display: inline-block; padding: 12px 22px; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif; font-size: 14px; letter-spacing: 0.04em; text-decoration: none; color: #FFFFFF;">
                            Open workflow run
                          </a>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td style="padding: 20px 8px 0 8px;">
              <p style="margin: 0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif; font-size: 12px; line-height: 18px; color: #A8A29A;">
                Sent by GitHub Actions for {repository}. You received this because you authored the commit.
              </p>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>
"""


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--failed-tests", required=True)
    parser.add_argument("--author-name", required=True)
    parser.add_argument("--repository", required=True)
    parser.add_argument("--branch", required=True)
    parser.add_argument("--commit", required=True)
    parser.add_argument("--run-url", required=True)
    parser.add_argument("--commit-url", default="")
    parser.add_argument("--html-out", default="email-body.html")
    parser.add_argument("--text-out", default="email-body.txt")
    args = parser.parse_args()

    report = Path(args.failed_tests).read_text(encoding="utf-8")
    tests = parse_failed_tests(report)
    if not tests:
        tests = [{
            "name": "Test run failed",
            "messages": ["The test run failed before individual test results were produced."],
        }]

    Path(args.text_out).write_text(render_plain(args, tests), encoding="utf-8")
    Path(args.html_out).write_text(render_html(args, tests), encoding="utf-8")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
