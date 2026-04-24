#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
build_root="$(mktemp -d "${TMPDIR:-/tmp}/homepage-archive.XXXXXX")"
temp_post="$repo_root/_posts/2026-04-23-codex-homepage-archive-test.md"

cleanup() {
  rm -f "$temp_post"
  rm -rf "$build_root"
}

trap cleanup EXIT

cat >"$temp_post" <<'EOF'
---
title: Codex Dynamic Archive Smoke Test
layout: post
---
This temporary post exists only to verify that the homepage archive is generated from site posts.
EOF

bundle exec jekyll build \
  --future \
  --source "$repo_root" \
  --destination "$build_root/site" \
  >/dev/null

built_index="$build_root/site/index.html"

if ! grep -q 'Codex Dynamic Archive Smoke Test' "$built_index"; then
  echo "Expected homepage archive to include the temporary post, but it was missing."
  exit 1
fi

if ! grep -q '<summary class="year-summary">2026</summary>' "$built_index"; then
  echo "Expected homepage archive to include a 2026 year section, but it was missing."
  exit 1
fi

echo "Homepage archive includes new posts automatically."
