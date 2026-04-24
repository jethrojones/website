#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
build_root="$(mktemp -d "${TMPDIR:-/tmp}/redirect-from.XXXXXX")"
temp_post="$repo_root/_posts/2001-01-01-codex-redirect-from-test.md"

cleanup() {
  rm -f "$temp_post"
  rm -rf "$build_root"
}

trap cleanup EXIT

cat >"$temp_post" <<'POST'
---
title: Codex Redirect From Smoke Test
layout: post
permalink: /codex-redirect-target-test/
redirect_from:
  - /codex-old-redirect-test/
---
This temporary post exists only to verify that old paths redirect to renamed content.
POST

bundle exec jekyll build \
  --source "$repo_root" \
  --destination "$build_root/site" \
  >/dev/null

redirect_file="$build_root/site/codex-old-redirect-test/index.html"

if [[ ! -f "$redirect_file" ]]; then
  echo "Expected redirect page to be generated at /codex-old-redirect-test/, but it was missing."
  exit 1
fi

if ! grep -q '/codex-redirect-target-test/' "$redirect_file"; then
  echo "Expected redirect page to point to /codex-redirect-target-test/, but it did not."
  exit 1
fi

if [[ -e "$build_root/site/script/test-redirect-from.sh" ]]; then
  echo "Expected script/ test helpers to be excluded from the built site, but they were published."
  exit 1
fi

echo "Redirect-from pages are generated, and test helpers are excluded from the built site."
