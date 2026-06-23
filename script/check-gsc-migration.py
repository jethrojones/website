#!/usr/bin/env python3
"""Check Search Console migration health without printing OAuth secrets."""

from __future__ import annotations

import json
import subprocess
from pathlib import Path

from google.auth.transport.requests import Request as GoogleAuthRequest
from google.oauth2.credentials import Credentials
from googleapiclient.discovery import build


ROOT = Path(__file__).resolve().parents[1]
TOKEN_FILE = ROOT / ".gsc-token.json"
SITE = "sc-domain:jethrojones.com"
OLD_SITE = "sc-domain:jethro.site"


def load_credentials() -> Credentials:
    token = json.loads(TOKEN_FILE.read_text())
    creds = Credentials(
        token=token.get("token"),
        refresh_token=token.get("refresh_token"),
        token_uri=token.get("token_uri"),
        client_id=token.get("client_id"),
        client_secret=token.get("client_secret"),
        scopes=token.get("scopes"),
    )
    if creds.expired and creds.refresh_token:
        creds.refresh(GoogleAuthRequest())
        token.update(
            {
                "token": creds.token,
                "refresh_token": creds.refresh_token,
                "token_uri": creds.token_uri,
                "client_id": creds.client_id,
                "client_secret": creds.client_secret,
                "scopes": creds.scopes,
            }
        )
        TOKEN_FILE.write_text(json.dumps(token, indent=2))
        TOKEN_FILE.chmod(0o600)
    return creds


def public_status(url: str) -> tuple[int | None, str | None]:
    result = subprocess.run(
        ["curl", "-sS", "-I", "--max-time", "20", url],
        check=False,
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        return None, result.stderr.strip() or result.stdout.strip()

    status = None
    location = None
    for line in result.stdout.splitlines():
        normalized = line.strip()
        if normalized.startswith("HTTP/"):
            parts = normalized.split()
            if len(parts) > 1 and parts[1].isdigit():
                status = int(parts[1])
        elif normalized.lower().startswith("location:"):
            location = normalized.split(":", 1)[1].strip()
    return status, location


def print_public_checks() -> None:
    print("PUBLIC_CHECKS")
    for url in (
        "https://jethrojones.com/sitemap.xml",
        "https://jethrojones.com/video-sitemap.xml",
        "https://jethro.site/",
        "https://www.jethrojones.com/",
    ):
        status, location = public_status(url)
        suffix = f" -> {location}" if location else ""
        print(f"  {url}: {status}{suffix}")


def print_sitemap_status(service) -> None:
    print("GSC_SITEMAPS")
    for site in (SITE, OLD_SITE):
        response = service.sitemaps().list(siteUrl=site).execute()
        sitemaps = response.get("sitemap", [])
        if not sitemaps:
            print(f"  {site}: no submitted sitemaps")
            continue
        for sitemap in sitemaps:
            path = sitemap.get("path", "")
            if "jethrojones.com/sitemap.xml" not in path and "jethrojones.com/video-sitemap.xml" not in path:
                continue
            print(
                "  "
                + "\t".join(
                    [
                        path,
                        f"lastSubmitted={sitemap.get('lastSubmitted')}",
                        f"lastDownloaded={sitemap.get('lastDownloaded')}",
                        f"warnings={sitemap.get('warnings')}",
                        f"errors={sitemap.get('errors')}",
                        f"isPending={sitemap.get('isPending')}",
                    ]
                )
            )


def print_url_inspection(service) -> None:
    print("GSC_URL_INSPECTION")
    for url in ("https://jethrojones.com/", "https://jethrojones.com/inspirational-videos"):
        response = (
            service.urlInspection()
            .index()
            .inspect(body={"inspectionUrl": url, "siteUrl": SITE})
            .execute()
        )
        status = response.get("inspectionResult", {}).get("indexStatusResult", {})
        print(
            "  "
            + "\t".join(
                [
                    url,
                    f"verdict={status.get('verdict')}",
                    f"coverageState={status.get('coverageState')}",
                    f"indexingState={status.get('indexingState')}",
                    f"lastCrawlTime={status.get('lastCrawlTime')}",
                    f"googleCanonical={status.get('googleCanonical')}",
                    f"userCanonical={status.get('userCanonical')}",
                ]
            )
        )


def main() -> None:
    print_public_checks()
    service = build("searchconsole", "v1", credentials=load_credentials(), cache_discovery=False)
    print_sitemap_status(service)
    print_url_inspection(service)


if __name__ == "__main__":
    main()
