#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp_root="$(mktemp -d "${TMPDIR:-/tmp}/redirect-guard.XXXXXX")"
fixture="$tmp_root/site"

cleanup() {
  rm -rf "$tmp_root"
}

trap cleanup EXIT

mkdir -p "$fixture/_layouts" "$fixture/_notes" "$fixture/script"

cp "$repo_root/Gemfile" "$fixture/Gemfile"
cp "$repo_root/Gemfile.lock" "$fixture/Gemfile.lock"
cp "$repo_root/_config.yml" "$fixture/_config.yml"
cp "$repo_root/script/check-redirects-for-renamed-urls.sh" "$fixture/script/check-redirects-for-renamed-urls.sh"

cat >"$fixture/_layouts/default.html" <<'HTML'
<!doctype html>
<html lang="en">
  <body>{{ content }}</body>
</html>
HTML

cat >"$fixture/_notes/old-name.md" <<'MARKDOWN'
---
title: Old Name
layout: default
permalink: /codex-old-guard-url/
---
Original content.
MARKDOWN

git -C "$fixture" init --quiet
git -C "$fixture" config user.email "codex@example.com"
git -C "$fixture" config user.name "Codex"
git -C "$fixture" add .
git -C "$fixture" commit --quiet -m "Baseline old URL"

rm "$fixture/_notes/old-name.md"
cat >"$fixture/_notes/new-name.md" <<'MARKDOWN'
---
title: New Name
layout: default
permalink: /codex-new-guard-url/
---
Moved content without a redirect.
MARKDOWN

set +e
missing_output="$(
  cd "$fixture" &&
    bash script/check-redirects-for-renamed-urls.sh HEAD 2>&1
)"
missing_status=$?
set -e

if [[ "$missing_status" -eq 0 ]]; then
  echo "Expected the redirect guard to fail when the old URL is missing."
  exit 1
fi

if ! grep -q '/codex-old-guard-url/' <<<"$missing_output"; then
  echo "Expected the redirect guard to report /codex-old-guard-url/."
  echo "$missing_output"
  exit 1
fi

cat >"$fixture/_notes/new-name.md" <<'MARKDOWN'
---
title: New Name
layout: default
permalink: /codex-new-guard-url/
redirect_from:
  - /codex-old-guard-url/
---
Moved content with a redirect.
MARKDOWN

(
  cd "$fixture"
  bash script/check-redirects-for-renamed-urls.sh HEAD
)

echo "Redirect guard detects missing old URLs and accepts redirect_from coverage."
