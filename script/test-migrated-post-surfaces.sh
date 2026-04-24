#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
build_root="$(mktemp -d "${TMPDIR:-/tmp}/migrated-post-surfaces.XXXXXX")"
temp_note="$repo_root/_notes/posts/2026-04-23-codex-migrated-post-surface-test.md"

cleanup() {
  rm -f "$temp_note"
  rm -rf "$build_root"
}

trap cleanup EXIT

cat >"$temp_note" <<'MARKDOWN'
---
title: Codex Migrated Post Surface Test
layout: note
content_type: post
date: 2026-04-23
permalink: /2026/04/23/codex-migrated-post-surface-test/
categories:
- Codex Migration
tags:
- migration-test
---
This temporary migrated post exists only to verify post surfaces after posts move to notes.
MARKDOWN

bundle exec jekyll build \
  --future \
  --source "$repo_root" \
  --destination "$build_root/site" \
  >/dev/null

built_index="$build_root/site/index.html"
built_feed="$build_root/site/feed.xml"
built_notes_feed="$build_root/site/feed_notes.xml"
built_search="$build_root/site/search.json"
built_category="$build_root/site/categories/codex-migration/index.html"

if ! grep -q 'Codex Migrated Post Surface Test' "$built_index"; then
  echo "Expected homepage blog archive to include the migrated post note."
  exit 1
fi

if ! grep -q '<summary class="year-summary">2026</summary>' "$built_index"; then
  echo "Expected homepage blog archive to group migrated post notes by year."
  exit 1
fi

if ! grep -q 'Codex Migrated Post Surface Test' "$built_feed"; then
  echo "Expected feed.xml to include the migrated post note."
  exit 1
fi

if grep -q 'Codex Migrated Post Surface Test' "$built_notes_feed"; then
  echo "Expected feed_notes.xml to exclude migrated post notes."
  exit 1
fi

ruby -rjson -e '
  item = JSON.parse(File.read(ARGV[0])).find { |entry| entry["title"] == "Codex Migrated Post Surface Test" }
  abort "Expected search.json to include migrated post note." unless item
  abort "Expected migrated post note search type to be posts, got #{item["type"].inspect}." unless item["type"] == "posts"
' "$built_search"

if [[ ! -f "$built_category" ]]; then
  echo "Expected category page for migrated post note."
  exit 1
fi

if ! grep -q 'Codex Migrated Post Surface Test' "$built_category"; then
  echo "Expected migrated post note to appear on its category page."
  exit 1
fi

echo "Migrated post notes appear on blog surfaces and stay out of notes feed."
