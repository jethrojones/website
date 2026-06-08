#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
build_root="$(mktemp -d "${TMPDIR:-/tmp}/note-git-dates.XXXXXX")"

cleanup() {
  rm -rf "$build_root"
}

trap cleanup EXIT

bundle exec jekyll build \
  --future \
  --source "$repo_root" \
  --destination "$build_root/site" \
  >/dev/null

built_note="$build_root/site/student-centered-learning-50.html"

if [[ ! -f "$built_note" ]]; then
  echo "Expected Student-Centered Learning note to be generated."
  exit 1
fi

if ! grep -q 'Originally published: May 23, 2024' "$built_note"; then
  echo "Expected missing note date to use the first git commit date."
  exit 1
fi

if ! grep -q 'Last updated: December 04, 2024' "$built_note"; then
  echo "Expected missing last_modified_at to use the latest git commit date."
  exit 1
fi

echo "Notes without date front matter use git creation and update dates."
