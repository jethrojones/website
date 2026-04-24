#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp_root="$(mktemp -d "${TMPDIR:-/tmp}/posts-to-notes.XXXXXX")"
fixture="$tmp_root/site"

cleanup() {
  rm -rf "$tmp_root"
}

trap cleanup EXIT

mkdir -p "$fixture/_posts" "$fixture/_notes" "$fixture/script"
cp "$repo_root/script/migrate-posts-to-notes.rb" "$fixture/script/migrate-posts-to-notes.rb"

cat >"$fixture/_posts/2020-01-02-sample-post.md" <<'MARKDOWN'
---
layout: post
title: Sample Post
categories:
- Reflection
tags:
- testing
published: true
last_modified_at: 2024-01-01 12:00:00
---
This is a [[Linked Note]] from a Markdown post.
MARKDOWN

cat >"$fixture/_posts/2020-01-03-legacy-html.html" <<'HTML'
---
layout: post
title: Legacy HTML
permalink: /legacy-html-alias/
blogger_orig_url: https://mrjonesed.blogspot.com/2020/01/legacy-html.html
---
<p>This HTML post has <strong>bold text</strong>.</p>
HTML

ruby "$fixture/script/migrate-posts-to-notes.rb" \
  --root "$fixture" \
  --dry-run \
  --reports-dir "$fixture/reports"

if [[ ! -f "$fixture/_posts/2020-01-02-sample-post.md" ]]; then
  echo "Dry run moved the Markdown post."
  exit 1
fi

if [[ -e "$fixture/_notes/posts/2020-01-02-sample-post.md" ]]; then
  echo "Dry run created the migrated Markdown post."
  exit 1
fi

if [[ ! -f "$fixture/reports/pre-migration-url-manifest.json" ]]; then
  echo "Dry run did not write the pre-migration manifest."
  exit 1
fi

ruby "$fixture/script/migrate-posts-to-notes.rb" \
  --root "$fixture" \
  --apply \
  --reports-dir "$fixture/reports"

markdown_target="$fixture/_notes/posts/2020-01-02-sample-post.md"
html_target="$fixture/_notes/posts/2020-01-03-legacy-html.md"

if [[ ! -f "$markdown_target" ]]; then
  echo "Markdown post was not migrated to _notes/posts."
  exit 1
fi

if [[ ! -f "$html_target" ]]; then
  echo "HTML post was not converted to Markdown in _notes/posts."
  exit 1
fi

if [[ -e "$fixture/_posts/2020-01-02-sample-post.md" || -e "$fixture/_posts/2020-01-03-legacy-html.html" ]]; then
  echo "Source posts remained after apply migration."
  exit 1
fi

grep -q '^layout: note$' "$markdown_target"
grep -q '^content_type: post$' "$markdown_target"
grep -q '^permalink: "/2020/01/02/sample-post/"$' "$markdown_target"
grep -q '^original_post_path: _posts/2020-01-02-sample-post.md$' "$markdown_target"
grep -q 'This is a \[\[Linked Note\]\]' "$markdown_target"

grep -q '^permalink: "/2020/01/03/legacy-html/"$' "$html_target"
grep -q '^redirect_from:$' "$html_target"
grep -q '^- "/legacy-html-alias/"' "$html_target"

if grep -q 'mrjonesed.blogspot.com' <(sed -n '/^redirect_from:/,/^[^ -]/p' "$html_target"); then
  echo "External Blogger URL was incorrectly added to redirect_from."
  exit 1
fi

if ! grep -q '\*\*bold text\*\*' "$html_target"; then
  echo "HTML body was not converted to Markdown."
  exit 1
fi

if [[ ! -f "$fixture/reports/post-migration-url-manifest.json" ]]; then
  echo "Apply run did not write the post-migration manifest."
  exit 1
fi

if [[ ! -f "$fixture/reports/rollback.md" ]]; then
  echo "Apply run did not write the rollback note."
  exit 1
fi

echo "Posts-to-notes migration preserves URLs, adds needed redirects, and converts HTML posts."
